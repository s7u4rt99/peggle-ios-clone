//
//  SLPhysicsCollision.swift
//  peggleclone
//
//  Created by Stuart Long on 11/2/22.
//

import Foundation
import SwiftUI

class SLPhysicsCollision {
    var firstBody: SLPhysicsBody
    var secondBody: SLPhysicsBody
    private let restitution = 0.9
    private var speedScale: Double = 1 / 23

    init(firstBody: SLPhysicsBody, secondBody: SLPhysicsBody) {
        self.firstBody = firstBody
        self.secondBody = secondBody
    }

    func resolve() {
        if let firstCircle = firstBody as? SLPhysicsCircle,
           let secondCircle = secondBody as? SLPhysicsCircle {
            resolveCircleCircleCollision(firstCircle: firstCircle, secondCircle: secondCircle)
        } else if let bucket = firstBody as? SLPhysicsBucket,
            let circle = secondBody as? SLPhysicsCircle {
            resolveCircleBucketCollision(bucket: bucket, circle: circle)
        } else if let bucket = secondBody as? SLPhysicsBucket,
            let circle = firstBody as? SLPhysicsCircle {
            resolveCircleBucketCollision(bucket: bucket, circle: circle)
        }
    }

    private func resolveCircleBucketCollision(bucket: SLPhysicsBucket, circle: SLPhysicsCircle) {
        let restitution = 0.9

        circle.setVelocity(newVelocity: Vector(xDirection: -abs(circle.position.xCoordinate) * restitution,
                                               yDirection: circle.position.yCoordinate))

        if circle.position.xCoordinate < bucket.position.xCoordinate - bucket.width / 2 {
            circle.moveTo(position: Point(
                xCoordinate: bucket.position.xCoordinate - bucket.width / 2 - circle.width / 2,
                yCoordinate: circle.position.yCoordinate))
        } else if circle.position.xCoordinate > bucket.position.xCoordinate + bucket.width / 2 {
            circle.moveTo(position: Point(
                xCoordinate: bucket.position.xCoordinate + bucket.width / 2 + circle.width / 2,
                yCoordinate: circle.position.yCoordinate))
        } else if circle.position.xCoordinate < bucket.position.xCoordinate {
            circle.moveTo(position: Point(
                xCoordinate: bucket.position.xCoordinate - bucket.width / 2 + circle.width / 2,
                yCoordinate: circle.position.yCoordinate))
        } else if circle.position.xCoordinate > bucket.position.xCoordinate {
            circle.moveTo(position: Point(
                xCoordinate: bucket.position.xCoordinate + bucket.width / 2 - circle.width / 2,
                yCoordinate: circle.position.yCoordinate))
        }
    }

    private func resolveCircleCircleCollision(firstCircle: SLPhysicsCircle, secondCircle: SLPhysicsCircle) {
        let collisionVector = Vector(xDirection: secondCircle.position.xCoordinate
                                     - firstCircle.position.xCoordinate,
                                     yDirection: secondCircle.position.yCoordinate
                                     - firstCircle.position.yCoordinate)
        let distance = distanceBetween(firstPoint: firstCircle.position, secondPoint: secondCircle.position)
        let collisionNormalVector = Vector(xDirection: collisionVector.xDirection / (distance),
                                           yDirection: collisionVector.yDirection / (distance))
        let relativeVelocity = firstCircle.velocity.subtract(vector: secondCircle.velocity)
        let tempSpeed = (relativeVelocity.xDirection * collisionVector.xDirection +
                         relativeVelocity.yDirection * collisionVector.yDirection)
        let speedAfterScale = Double(tempSpeed) * speedScale
        let speedAfterRestitution = speedAfterScale * restitution
        let impulse = 2 * speedAfterRestitution / (firstCircle.mass + secondCircle.mass)
        if speedAfterRestitution >= 0 {
            firstCircle.forces.append(collisionNormalVector
                                        .multiplyWithScalar(scalar: -1 * impulse * secondCircle.mass))
            secondCircle.forces.append(collisionNormalVector
                                        .multiplyWithScalar(scalar: impulse * firstCircle.mass))
        }
    }

    private func distanceBetween(firstPoint: Point, secondPoint: Point) -> Double {
        let xDist = firstPoint.xCoordinate - secondPoint.xCoordinate
        let yDist = firstPoint.yCoordinate - secondPoint.yCoordinate
        return Double(sqrt(xDist * xDist + yDist * yDist))
    }
}
