//
//  SLGameEngine.swift
//  peggleclone
//
//  Created by Stuart Long on 10/2/22.
//

import Foundation
import SwiftUI

class SLGameEngine {
    private var physicsEngine = SLPhysicsWorld()
    private var mappings: [PeggleObject: SLPhysicsBody] = [:]
    private var trianglesRemovedTemporarily: [TriangleBlock: SLPhysicsBody] = [:]
    private let msPerUpdate = TimeInterval(0.016)
    private var lag = 0.0
    private var previous: Date?
    private weak var gameDisplayDelegate: GameDisplayDelegate?
    private weak var gameLogicDelegate: GameLogicDelegate?
    private var canvasDimensions: CGRect
    private var cannonBall: Peg?
    private var similarPositionCounter = 0
    private var mostRecentPosition: Point?
    private var bucket: Bucket?
    private var numOfCannonBallsLeft: Int
    private var numOfOrangePegs: Int
    private var cannonBallInBucket = false
    private var powerUpHandler = PowerUpHandler()
    var timerStart = false

    init(canvasDimensions: CGRect) {
        self.canvasDimensions = canvasDimensions
        self.numOfCannonBallsLeft = 10
        self.numOfOrangePegs = 0
    }

    func loadLevel(
        gameDisplayDelegate: GameDisplayDelegate,
        gameLogicDelegate: GameLogicDelegate,
        level: Level, bucket: Bucket) {
        // create physics body for each object, loads to physics engine
        self.gameDisplayDelegate = gameDisplayDelegate
        self.gameLogicDelegate = gameLogicDelegate
        self.bucket = bucket
        self.numOfCannonBallsLeft = 10
        self.numOfOrangePegs = 0
        self.powerUpHandler.resetCount()

        var physicsObjects: [SLPhysicsBody] = []
        for peggleObject in level.peggleObjects {
            if let peg = peggleObject as? Peg {
                let physicsBody = SLPhysicsCircle(position: peg.center, isDynamic: false, radius: peg.radius)
                physicsObjects.append(physicsBody)
                mappings[peg] = physicsBody
                if peg.color == PegState.orangePeg {
                    numOfOrangePegs += 1
                }
            } else if let triangle = peggleObject as? TriangleBlock {
                let physicsBody = SLPhysicsTriangle(position: triangle.center,
                                                    height: triangle.height,
                                                    width: triangle.base,
                                                    isDynamic: false)
                physicsObjects.append(physicsBody)
                mappings[triangle] = physicsBody
            }
        }
        // create body for bucket
        let bucketPhysicsBody = SLPhysicsBucket(position: bucket.center,
                                                height: bucket.size,
                                                width: bucket.size * 1.05)
        // add bucket to mappings
        mappings[bucket] = bucketPhysicsBody
        physicsObjects.append(bucketPhysicsBody)
        physicsEngine.load(physicsBodies: physicsObjects, canvasDimensions: canvasDimensions)
        addCannonBall()
        guard cannonBall != nil else {
            return
        }
        if numOfOrangePegs == 0 {
            gameLogicDelegate.gameWin()
        }
    }

    func addCannonBall() {
        guard let gameDisplayDelegate = gameDisplayDelegate else {
            return
        }
        let middleOfTopScreen = CGPoint(x: canvasDimensions.width / 2,
                                        y: canvasDimensions.height / 15)
        let cannonBall = Peg(color: PegState.cannonPeg, center: toPoint(point: middleOfTopScreen),
                             radius: Peg.pegMinRadiusRatio * canvasDimensions.width)
        self.cannonBall = cannonBall
        gameDisplayDelegate.didAddCannonBall(cannonBall: cannonBall)
        self.mostRecentPosition = cannonBall.center
    }

    func toPoint(point: CGPoint) -> Point {
        Point(xCoordinate: point.x, yCoordinate: point.y)
    }

    func createDisplayLink() {
        self.previous = Date()
        let displayLink = CADisplayLink(target: self, selector: #selector(start))
        displayLink.add(to: .current, forMode: .common)
    }

    @objc func start() {
        guard let previous = previous,
              let gameLogicDelegate = gameLogicDelegate else {
            return
        }

        let current = Date()
        let elapsed = current.timeIntervalSince(previous)
        self.previous = current
        lag += elapsed
        if timerStart {
            gameLogicDelegate.moveTimer(elapsed)
        }

        var numberOfCannonBalls = 1

        while lag >= msPerUpdate {
            numberOfCannonBalls = physicsEngine.simulatePhysics(duration: msPerUpdate)
            lag -= msPerUpdate
        }

        render(cannonBallCount: numberOfCannonBalls)
    }

    private func handleCannonBallMovement(_ cannonBallCount: Int, _ currentCollisions: [PeggleObject]) {
        guard let cannonBall = cannonBall,
              let cannonBallPhysicsBody = mappings[cannonBall],
              let gameDisplayDelegate = gameDisplayDelegate,
              let gameLogicDelegate = gameLogicDelegate else {
            return
        }
        let similarPositionLimit = 75

        if cannonBallCount == 0 {
            cannonBallPhysicsBody.ignore()
            mappings.removeValue(forKey: cannonBall)
            gameDisplayDelegate.didRemove(peggleObject: cannonBall)
            if cannonBallInBucket {
                numOfCannonBallsLeft += 1
                gameLogicDelegate.addCannonball()
                cannonBallInBucket = false
            }
            addCannonBall()
            self.similarPositionCounter = 0
        } else {
            if isCannonBallSamePosition() {
                if similarPositionCounter > similarPositionLimit {
                    for peggleObject in currentCollisions {
                        guard let peggleObjInTouch = mappings[peggleObject] else {
                            continue
                        }
                        if peggleObjInTouch.hasCollided {
                            peggleObjInTouch.ignore()
                            gameDisplayDelegate.didRemove(peggleObject: peggleObject)
                            if let triangle = peggleObject as? TriangleBlock {
                                // handle them -> put in an array or whatever
                                trianglesRemovedTemporarily[triangle] = peggleObjInTouch
                            }
                        }
                    }
                } else {
                    similarPositionCounter += 1
                }
            } else {
                self.mostRecentPosition = cannonBallPhysicsBody.position
                similarPositionCounter = 0
            }
        }
    }

    func render(cannonBallCount: Int) {
        guard let gameLogicDelegate = gameLogicDelegate else {
            return
        }

        if gameLogicDelegate.hasTimerEnded()
            && (numOfCannonBallsLeft > 0
            || (numOfCannonBallsLeft == 0 && cannonBall != nil)) {
            gameLogicDelegate.timerUp()
            self.timerStart = false
            return
        }

        guard let gameDisplayDelegate = gameDisplayDelegate,
              let bucket = bucket,
              let bucketPhysicsBody = mappings[bucket] else {
            return
        }

        moveBucket(bucket, bucketPhysicsBody, gameDisplayDelegate)

        guard let cannonBall = cannonBall,
              let cannonBallPhysicsBody = mappings[cannonBall] else {
            return
        }

        moveCannonBall(cannonBall, cannonBallPhysicsBody, gameDisplayDelegate)

        let collisions = cannonBallPhysicsBody.collisionsWith
        let currentCollisions = handleCollisions(collisions, cannonBallCount)

        checkCollidedTriangles()
        handleCannonBallMovement(cannonBallCount, currentCollisions)

        if numOfCannonBallsLeft == 0 && cannonBallCount == 0 {
            if numOfOrangePegs == 0 {
                gameLogicDelegate.gameWin()
            } else {
                gameLogicDelegate.gameLose()
                self.timerStart = false
            }
        }
    }

    private func checkCollidedTriangles() {
        for (key, value) in trianglesRemovedTemporarily {
            if !touchingCannonBall(value) {
                gameDisplayDelegate?.didAdd(peggleObject: key)
                mappings[key] = value
                value.unignore()
                trianglesRemovedTemporarily.removeValue(forKey: key)
            }
        }
    }

    private func touchingCannonBall(_ physicsBody: SLPhysicsBody) -> Bool {
        guard let cannonBall = cannonBall, let cannonBallMapping = mappings[cannonBall] else {
            return false
        }
        return cannonBallMapping.intersectWith(physicsBody: physicsBody)
    }

    private func moveBucket(
        _ bucket: Bucket, _ bucketPhysicsBody: SLPhysicsBody, _ gameDisplayDelegate: GameDisplayDelegate) {
        bucket.center = bucketPhysicsBody.position
        gameDisplayDelegate.didMove(peggleObject: bucket, newLocation: bucketPhysicsBody.position)
    }

    private func handleCollisions(_ collisions: [SLPhysicsBody], _ cannonBallCount: Int) -> [PeggleObject] {
        guard let gameLogicDelegate = gameLogicDelegate,
              let gameDisplayDelegate = gameDisplayDelegate,
              let cannonBall = cannonBall else {
            return []
        }

        var currentCollisions: [PeggleObject] = []

        for (key, value) in mappings where value.hasCollided {
            if let peg = key as? Peg {
                peg.glow()
                if contains(arr: collisions, physicsBody: value) {
                    currentCollisions.append(peg)
                }
                if peg is SpookyPeg || peg is KaboomPeg {
                    powerUpHandler.handlePowerUp(powerPeg: peg, mappings: mappings,
                                                 cannonBall: cannonBall, gameDisplayDelegate: gameDisplayDelegate)
                }
                if cannonBallCount == 0 && peg != cannonBall {
                    gameDisplayDelegate.didRemove(peggleObject: peg)
                    mappings.removeValue(forKey: peg)
                    if peg.color != cannonBall.color {
                        gameLogicDelegate.didAddPoints(peg.points)
                    }
                    value.ignore()
                    powerUpHandler.removePowerPeg(powerPeg: peg)
                    if peg.color == .orangeGlow {
                        numOfOrangePegs -= 1
                        if numOfOrangePegs == 0 {
                            gameLogicDelegate.gameWin()
                        }
                    }
                }
            } else if let triangle = key as? TriangleBlock {
                if contains(arr: collisions, physicsBody: value) {
                    currentCollisions.append(triangle)
                }
            }
        }

        return currentCollisions
    }

    private func moveCannonBall(
        _ cannonBall: Peg, _ cannonBallPhysicsBody: SLPhysicsBody, _ gameDisplayDelegate: GameDisplayDelegate) {
        cannonBall.center = cannonBallPhysicsBody.position
        gameDisplayDelegate.didMove(peggleObject: cannonBall, newLocation: cannonBallPhysicsBody.position)

        if isCannonBallInBucket(cannonBallPhysicsBody) {
            cannonBallInBucket = true
        }
        powerUpHandler.handleCannonBall(canvasDimension: canvasDimensions,
                                        cannonBall: cannonBall,
                                        cannonBallPhysicsBody: cannonBallPhysicsBody,
                                        gameDisplayDelegate: gameDisplayDelegate)
    }

    private func isOutOfScreen(peg: Peg) -> Bool {
        peg.center.yCoordinate >= canvasDimensions.height + peg.radius
    }

    private func isCannonBallInBucket(_ cannonBallPhysicsBody: SLPhysicsBody) -> Bool {
        guard let bucket = bucket, let bucketPhysicsBody = mappings[bucket] else {
            return false
        }
        let bucketCenter = bucketPhysicsBody.position
        let bucketWidth = bucketPhysicsBody.width
        let bucketHeight = bucketPhysicsBody.height
        let cannonBallCenter = cannonBallPhysicsBody.position

        return cannonBallCenter.xCoordinate > bucketCenter.xCoordinate - bucketWidth / 2
        && cannonBallCenter.xCoordinate < bucketCenter.xCoordinate + bucketWidth / 2
        && cannonBallCenter.yCoordinate > bucketCenter.yCoordinate - bucketHeight / 2
        && cannonBallCenter.yCoordinate < bucketCenter.yCoordinate + bucketWidth / 2
    }

    private func isCannonBallSamePosition() -> Bool {
        // roughly same can already
        let allowance = 10.0
        guard let cannonBall = cannonBall,
                let cannonBallPhysicBody = mappings[cannonBall],
                let mostRecentPosition = mostRecentPosition else {
            return false
        }
        return abs(cannonBallPhysicBody.position.xCoordinate - mostRecentPosition.xCoordinate) < allowance &&
            abs(cannonBallPhysicBody.position.yCoordinate - mostRecentPosition.yCoordinate) < allowance
    }

    private func contains(arr: [SLPhysicsBody], physicsBody: SLPhysicsBody) -> Bool {
        for body in arr where body.position == physicsBody.position {
            return true
        }
        return false
    }

    func fireCannonBall(directionOf: Point) -> Bool {
        guard let cannonBall = cannonBall else {
            return false
        }

        if mappings[cannonBall] != nil {
            return false
        }

        self.numOfCannonBallsLeft -= 1
        var modifiedDirection = directionOf
        if directionOf.yCoordinate < cannonBall.center.yCoordinate {
            modifiedDirection = Point(xCoordinate: directionOf.xCoordinate,
                                      yCoordinate: cannonBall.center.yCoordinate)
        }
        let cannonBallPhysics = SLPhysicsCircle(
            velocity: Vector(xDirection: modifiedDirection.xCoordinate - cannonBall.center.xCoordinate,
                             yDirection: modifiedDirection.yCoordinate - cannonBall.center.yCoordinate)
                                                    .multiplyWithScalar(scalar: 1.5),
                                                position: cannonBall.center,
                                                isDynamic: true,
                                                radius: cannonBall.radius)
        mappings[cannonBall] = cannonBallPhysics
        physicsEngine.addCannonBall(cannonBall: cannonBallPhysics)
        return true
    }

    func gameEnd() {
        physicsEngine.removeBodies()
        gameLogicDelegate?.resetPoints()
        mappings = [:]
        cannonBall = nil
        similarPositionCounter = 0
        mostRecentPosition = nil
        bucket = nil
        numOfCannonBallsLeft = 0
        numOfOrangePegs = 0
        cannonBallInBucket = false
        timerStart = false
    }
}
