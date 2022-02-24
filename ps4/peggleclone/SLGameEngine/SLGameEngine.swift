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
    private let msPerUpdate = TimeInterval(0.016)
    private var lag = 0.0
    private var previous: Date?
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

    init(canvasDimensions: CGRect) {
        self.canvasDimensions = canvasDimensions
        self.numOfCannonBallsLeft = 10
        self.numOfOrangePegs = 0
    }

    func loadLevel(gameLogicDelegate: GameLogicDelegate, level: Level, bucket: Bucket) {
        // create physics body for each object, loads to physics engine
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
                if peg.color == PegColor.orangePeg {
                    numOfOrangePegs += 1
                }
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
        if numOfOrangePegs == 0 {
            gameLogicDelegate.gameWin()
        }
    }

    func addCannonBall() {
        guard let gameLogicDelegate = gameLogicDelegate else {
            return
        }
        let middleOfTopScreen = CGPoint(x: 400, y: 50)
        let cannonBall = Peg(color: PegColor.cannonPeg, center: toPoint(point: middleOfTopScreen))
        self.cannonBall = cannonBall

        gameLogicDelegate.didAddCannonBall(cannonBall: cannonBall)
        self.mostRecentPosition = cannonBall.center
    }

    func toPoint(point: CGPoint) -> Point {
        return Point(xCoordinate: point.x, yCoordinate: point.y)
    }

    func createDisplayLink() {
        self.previous = Date()
        let displayLink = CADisplayLink(target: self, selector: #selector(start))
        displayLink.add(to: .current, forMode: .common)
    }

    @objc func start() {
        guard let previous = previous else {
            return
        }

        let current = Date()
        let elapsed = current.timeIntervalSince(previous)
        self.previous = current
        lag += elapsed

        var numberOfCannonBalls = 1

        while lag >= msPerUpdate {
            numberOfCannonBalls = physicsEngine.simulatePhysics(duration: msPerUpdate)
            lag -= msPerUpdate
        }

        render(cannonBallCount: numberOfCannonBalls)
    }

    func render(cannonBallCount: Int) {
        guard let gameLogicDelegate = gameLogicDelegate,
              let bucket = bucket,
              let bucketPhysicsBody = mappings[bucket] else {
            return
        }

        moveBucket(bucket, bucketPhysicsBody, gameLogicDelegate)

        guard let cannonBall = cannonBall,
              let cannonBallPhysicsBody = mappings[cannonBall] else {
            return
        }

        moveCannonBall(cannonBall, cannonBallPhysicsBody, gameLogicDelegate)

        let collisions = cannonBallPhysicsBody.collisionsWith
        let currentCollisions = handleCollisions(collisions, gameLogicDelegate, cannonBallCount, cannonBall)

        let similarPositionLimit = 75

        if cannonBallCount == 0 {
            cannonBallPhysicsBody.ignore()
            mappings.removeValue(forKey: cannonBall)
            gameLogicDelegate.didRemove(peg: cannonBall)
            if cannonBallInBucket {
                numOfCannonBallsLeft += 1
                cannonBallInBucket = false
            }
            addCannonBall()
            self.similarPositionCounter = 0
        } else {
            if isCannonBallSamePosition() {
                if similarPositionCounter > similarPositionLimit {
                    for peg in currentCollisions {
                        guard let pegInTouch = mappings[peg] else {
                            continue
                        }
                        if pegInTouch.hasCollided {
                            pegInTouch.ignore()
                            gameLogicDelegate.didRemove(peg: peg)
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

        if numOfCannonBallsLeft == 0 && cannonBallCount == 0 {
            gameLogicDelegate.gameLose()
        }
    }

    private func moveBucket(
        _ bucket: Bucket, _ bucketPhysicsBody: SLPhysicsBody, _ gameLogicDelegate: GameLogicDelegate) {
        bucket.center = bucketPhysicsBody.position
        gameLogicDelegate.didMove(peggleObject: bucket, newLocation: bucketPhysicsBody.position)
    }

    private func handleCollisions(
        _ collisions: [SLPhysicsBody], _ gameLogicDelegate: GameLogicDelegate,
        _ cannonBallCount: Int, _ cannonBall: Peg) -> [Peg] {
        var currentCollisions: [Peg] = []

        for (key, value) in mappings where value.hasCollided {
            if let peg = key as? Peg {
                peg.glow()
                if contains(arr: collisions, physicsBody: value) {
                    currentCollisions.append(peg)
                }
                // TODO: refactor
                if peg is SpookyPeg || peg is KaboomPeg {
                    powerUpHandler.handlePowerUp(powerPeg: peg, mappings: mappings,
                                                 cannonBall: cannonBall, gameLogicDelegate: gameLogicDelegate)
                }
//                if let spookyPeg = peg as? SpookyPeg {
//                    if !spookyPeg.activated {
//                        spookyBallsActivated += 1
//                        print(spookyBallsActivated)
//                        spookyPeg.setActivated()
//                    }
//                }
                // TODO: add the handler
                if cannonBallCount == 0 {
                    gameLogicDelegate.didRemove(peg: peg)
                    mappings.removeValue(forKey: peg)
                    value.ignore()
                    powerUpHandler.removePowerPeg(powerPeg: peg)
                    if peg.color == .orangeGlow {
                        numOfOrangePegs -= 1
                        if numOfOrangePegs == 0 {
                            gameLogicDelegate.gameWin()
                        }
                    }
                }
            }
        }

        return currentCollisions
    }

    // TODO: add handler
    private func moveCannonBall(
        _ cannonBall: Peg, _ cannonBallPhysicsBody: SLPhysicsBody, _ gameLogicDelegate: GameLogicDelegate) {
        cannonBall.center = cannonBallPhysicsBody.position
        gameLogicDelegate.didMove(peggleObject: cannonBall, newLocation: cannonBallPhysicsBody.position)
//        if spookyBallsActivated > 0 {
//            gameLogicDelegate.spookCannonBall(cannonBall: cannonBall)
//        }
        if isCannonBallInBucket(cannonBallPhysicsBody) {
            cannonBallInBucket = true
        }
        powerUpHandler.handleCannonBall(canvasDimension: canvasDimensions,
                                        cannonBall: cannonBall,
                                        cannonBallPhysicsBody: cannonBallPhysicsBody,
                                        gameLogicDelegate: gameLogicDelegate)
//        if spookyBallsActivated > 0 && isOutOfScreen(peg: cannonBall) {
//            gameLogicDelegate.didMove(peggleObject: cannonBall,
//                                      newLocation: Point(xCoordinate: cannonBall.center.xCoordinate, yCoordinate: 0))
//            cannonBallPhysicsBody.moveTo(position: Point(xCoordinate: cannonBall.center.xCoordinate, yCoordinate: 0))
//            cannonBallPhysicsBody
//                .setVelocity(newVelocity: cannonBallPhysicsBody.velocity.multiplyWithScalar(scalar: 0.5))
//            spookyBallsActivated -= 1
//            print("used one spooky ball, \(spookyBallsActivated) left")
//        }
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

    func fireCannonBall(directionOf: Point) {
        guard let cannonBall = cannonBall else {
            return
        }

        if mappings[cannonBall] != nil {
            return
        }

        self.numOfCannonBallsLeft -= 1
        print(numOfCannonBallsLeft)
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
    }
}
