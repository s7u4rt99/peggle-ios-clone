//
//  SLPhysicsWorld.swift
//  peggleclone
//
//  Created by Stuart Long on 9/2/22.
//

import Foundation
import UIKit

class SLPhysicsWorld {
    private var physicsBodies: [SLPhysicsBody] = []
    private var collisions: [SLPhysicsCollision] = []
    private var canvasDimensions: CGRect?

    func load(physicsBodies: [SLPhysicsBody], canvasDimensions: CGRect) {
        self.physicsBodies = physicsBodies
        self.canvasDimensions = canvasDimensions
    }

    func simulatePhysics(duration: TimeInterval) -> Int {
        let cannonBallCount = generateNewPositions(duration: duration)
        getCollisions()
        resolveCollisions()
        resolveEdgeCollisions()
        resolveOverlaps()
        updateVelocityOfNodes(duration: duration)
        collisions.removeAll()
        return cannonBallCount
    }

    private func generateNewPositions(duration: TimeInterval) -> Int {
        var cannonBallCount = 0
        var count = 0
        for (index, body) in physicsBodies.enumerated() {
            if isOutOfScreen(physicsBody: body) {
                // remove body
                physicsBodies.remove(at: index - count)
                count += 1
                body.setNotDynamic()
            } else if body.isDynamic {
                if body is SLPhysicsCircle {
                    cannonBallCount += 1
                }
                generateNewPosition(physicsBody: body, duration: duration)
            }
        }
        return cannonBallCount
    }

    private func generateNewPosition(physicsBody: SLPhysicsBody, duration: TimeInterval) {
        // v = u + at
        let newVelocity = physicsBody.velocity.addTo(vector: physicsBody.gravity, scale: duration)
        // s = ut + 1/2 * a * t *2
        let distanceMoved = physicsBody.velocity.multiplyWithScalar(scalar: duration)
            .addTo(vector: physicsBody.gravity.multiplyWithScalar(scalar: 0.5 * duration * duration))
        let newPosition = distanceMoved.addTo(point: physicsBody.position)
        physicsBody.moveTo(position: newPosition)
        physicsBody.setVelocity(newVelocity: newVelocity)
        physicsBody.clearCollisionsWith()
    }

    private func isOutOfScreen(physicsBody: SLPhysicsBody) -> Bool {
        guard let canvasDimensions = canvasDimensions else {
            fatalError("No canvas dimensions included")
        }

        return physicsBody.position.yCoordinate >= canvasDimensions.height * 2
    }

    private func getCollisions() {
        for firstIndex in 0..<physicsBodies.count {
            let currentBody = physicsBodies[firstIndex]
            for secondIndex in (firstIndex + 1)..<physicsBodies.count {
                let nextBody = physicsBodies[secondIndex]
                let canIgnore = currentBody.canIgnore || nextBody.canIgnore
                if !canIgnore && currentBody.intersectWith(physicsBody: nextBody) {
                    currentBody.setCollided()
                    nextBody.setCollided()
                    collisions.append(SLPhysicsCollision(firstBody: currentBody,
                                                              secondBody: nextBody))
                    currentBody.addCollisionWith(physicsBody: nextBody)
                    nextBody.addCollisionWith(physicsBody: currentBody)
//                    MusicManager.shared.ballBounceMusic()
                }
            }
         }
    }

    private func resolveCollisions() {
        for collision in collisions {
            // resolve the collisions and set the new distance after resolving all
            collision.resolve()
        }
    }

    private func resolveEdgeCollisions() {
        guard let canvasDimensions = canvasDimensions else {
            return
        }

        let restitution = 0.9

        for physicsBody in physicsBodies where physicsBody.isDynamic {
            if physicsBody.position.xCoordinate < physicsBody.width / 2 {
                physicsBody
                    .setVelocity(newVelocity: Vector(xDirection: abs(physicsBody.velocity.xDirection) * restitution,
                                                     yDirection: physicsBody.velocity.yDirection))
                physicsBody.moveTo(position: Point(xCoordinate: physicsBody.width / 2,
                                                   yCoordinate: physicsBody.position.yCoordinate))
            } else if physicsBody.position.xCoordinate > canvasDimensions.width - physicsBody.width / 2 {
                physicsBody
                    .setVelocity(newVelocity: Vector(xDirection: -abs(physicsBody.velocity.xDirection) * restitution,
                                                     yDirection: physicsBody.velocity.yDirection))
                physicsBody.moveTo(position: Point(xCoordinate: canvasDimensions.width - physicsBody.width / 2,
                                                   yCoordinate: physicsBody.position.yCoordinate))
            }
        }
    }

    private func updateVelocityOfNodes(duration: TimeInterval) {
        for physicsBody in physicsBodies where physicsBody.isDynamic {
            physicsBody.resolveForces()
        }
    }

    private func resolveOverlaps() {
        for collision in collisions.reversed() {
            let firstBody = collision.firstBody
            let secondBody = collision.secondBody
            if firstBody.intersectWith(physicsBody: secondBody) {
                // translate them
                if let firstCircle = firstBody as? SLPhysicsCircle,
                   let secondCircle = secondBody as? SLPhysicsCircle {
                let intersectAmount = getCircleIntersectAmount(firstCircle, secondCircle)
                    // move the dynamic one only
                    if firstCircle.isDynamic {
                        firstCircle.moveBackBy(distance: intersectAmount)
                    } else if secondCircle.isDynamic {
                        secondCircle.moveBackBy(distance: intersectAmount)
                    }
                } else {
                    if firstBody.isDynamic {
                        firstBody.moveTo(position: firstBody.previousPosition)
                    } else {
                        secondBody.moveTo(position: secondBody.previousPosition)
                    }
                }
            }
        }
    }

    private func getCircleIntersectAmount(_ firstBody: SLPhysicsCircle, _ secondBody: SLPhysicsCircle) -> Double {
        let xDistance = firstBody.position.xCoordinate - secondBody.position.xCoordinate
        let yDistance = firstBody.position.yCoordinate - secondBody.position.yCoordinate
        let closestRange = firstBody.radius + secondBody.radius

        return closestRange - sqrt((xDistance * xDistance + yDistance * yDistance))
    }

    func addCannonBall(cannonBall: SLPhysicsCircle) {
        self.physicsBodies.append(cannonBall)
    }

    func add(_ physicsBody: SLPhysicsBody) {
        self.physicsBodies.append(physicsBody)
    }

    func removeBodies() {
        physicsBodies = []
        collisions = []
    }
}
