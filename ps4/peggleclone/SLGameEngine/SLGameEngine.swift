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
    private var mappings: [Peg: SLPhysicsBody] = [:]
    private let msPerUpdate = TimeInterval(0.016)
    private var lag = 0.0
    private var previous = Date()
    private var pegManager: PegManager?
    private var canvasDimensions: CGRect
    private var cannonBall: Peg?
    private var similarPositionCounter = 0
    private var mostRecentPosition: Point?

    init(canvasDimensions: CGRect) {
        self.canvasDimensions = canvasDimensions
    }

    func loadLevel(pegManager: PegManager) {
        // create physics body for each object, loads to physics engine
        self.pegManager = pegManager

        var physicsObjects: [SLPhysicsBody] = []
        for peg in pegManager.level.pegs {
            let physicsBody = SLPhysicsCircle(position: peg.center, isDynamic: false, radius: peg.radius)
            physicsObjects.append(physicsBody)
            mappings[peg] = physicsBody
        }

        physicsEngine.load(physicsBodies: physicsObjects, canvasDimensions: canvasDimensions)
        addCannonBall()
    }

    func addCannonBall() {
        guard let pegManager = pegManager else {
            return
        }
        let middleOfTopScreen = CGPoint(x: 400, y: 50)
        let cannonBall = Peg(type: PegType.cannonPeg, center: toPoint(point: middleOfTopScreen))
        self.cannonBall = cannonBall

        pegManager.addCannonBall(cannonBall: cannonBall)
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
        guard let pegManager = pegManager, let cannonBall = cannonBall,
              let cannonBallPhysicsBody = mappings[cannonBall] else {
            return
        }

        cannonBall.center = cannonBallPhysicsBody.position
        pegManager.movePeg(peg: cannonBall, newLocation: cannonBallPhysicsBody.position)
        let collisions = cannonBallPhysicsBody.collisionsWith
        var currentCollisions: [Peg] = []
        for (key, value) in mappings where value.hasCollided {
            key.glow()
            if contains(arr: collisions, physicsBody: value) {
                currentCollisions.append(key)
            }
            if cannonBallCount == 0 {
                pegManager.delete(peg: key)
                value.ignore()
            }
        }

        let similarPositionLimit = 75

        if cannonBallCount == 0 {
            cannonBallPhysicsBody.ignore()
            mappings.removeValue(forKey: cannonBall)
            pegManager.delete(peg: cannonBall)
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
                            pegManager.delete(peg: peg)
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
