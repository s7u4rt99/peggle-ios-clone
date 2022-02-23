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
    private var previous = Date()
    private weak var gameLogicDelegate: GameLogicDelegate?
    private var canvasDimensions: CGRect
    private var cannonBall: Peg?
    private var similarPositionCounter = 0
    private var mostRecentPosition: Point?

    init(canvasDimensions: CGRect) {
        self.canvasDimensions = canvasDimensions
    }

    func loadLevel(gameLogicDelegate: GameLogicDelegate, level: Level) {
        // create physics body for each object, loads to physics engine
        self.gameLogicDelegate = gameLogicDelegate

        var physicsObjects: [SLPhysicsBody] = []
        for peg in level.pegs {
            let physicsBody = SLPhysicsCircle(position: peg.center, isDynamic: false, radius: peg.radius)
            physicsObjects.append(physicsBody)
            mappings[peg] = physicsBody
        }

        physicsEngine.load(physicsBodies: physicsObjects, canvasDimensions: canvasDimensions)
        addCannonBall()
    }

    func addCannonBall() {
        guard let gameLogicDelegate = gameLogicDelegate else {
            return
        }
        let middleOfTopScreen = CGPoint(x: 400, y: 50)
        let cannonBall = Peg(type: PegType.cannonPeg, center: toPoint(point: middleOfTopScreen))
        self.cannonBall = cannonBall

        gameLogicDelegate.didAddCannonBall(cannonBall: cannonBall)
        self.mostRecentPosition = cannonBall.center
    }

    func toPoint(point: CGPoint) -> Point {
        return Point(xCoordinate: point.x, yCoordinate: point.y)
    }

    func createDisplayLink() {
        let displayLink = CADisplayLink(target: self, selector: #selector(start))
        displayLink.add(to: .current, forMode: .common)
    }

    @objc func start() {
        let current = Date()
        let elapsed = current.timeIntervalSince(previous)
        previous = current
        lag += elapsed

        var numberOfCannonBalls = 1

        while lag >= msPerUpdate {
            numberOfCannonBalls = physicsEngine.simulatePhysics(duration: msPerUpdate)
            lag -= msPerUpdate
        }

        render(cannonBallCount: numberOfCannonBalls)
    }

    func render(cannonBallCount: Int) {
        guard let gameLogicDelegate = gameLogicDelegate, let cannonBall = cannonBall,
              let cannonBallPhysicsBody = mappings[cannonBall] else {
            return
        }

        moveCannonBall(cannonBall, cannonBallPhysicsBody, gameLogicDelegate)

        let collisions = cannonBallPhysicsBody.collisionsWith
        let currentCollisions = handleCollisions(collisions, gameLogicDelegate, cannonBallCount)

        let similarPositionLimit = 75

        if cannonBallCount == 0 {
            cannonBallPhysicsBody.ignore()
            mappings.removeValue(forKey: cannonBall)
            gameLogicDelegate.didRemove(peg: cannonBall)
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
    }

    private func handleCollisions(
        _ collisions: [SLPhysicsBody], _ gameLogicDelegate: GameLogicDelegate, _ cannonBallCount: Int) -> [Peg] {
        var currentCollisions: [Peg] = []

        for (key, value) in mappings where value.hasCollided {
            if let peg = key as? Peg {
                peg.glow()
                if contains(arr: collisions, physicsBody: value) {
                    currentCollisions.append(peg)
                }
                if cannonBallCount == 0 {
                    gameLogicDelegate.didRemove(peg: peg)
                    mappings.removeValue(forKey: peg)
                    value.ignore()
                }
            }
        }

        if mappings.count == 0 {
            gameLogicDelegate.gameEnded()
        }

        return currentCollisions
    }

    private func moveCannonBall(
        _ cannonBall: Peg, _ cannonBallPhysicsBody: SLPhysicsBody, _ gameLogicDelegate: GameLogicDelegate) {
        cannonBall.center = cannonBallPhysicsBody.position
        gameLogicDelegate.didMove(peg: cannonBall, newLocation: cannonBallPhysicsBody.position)
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
