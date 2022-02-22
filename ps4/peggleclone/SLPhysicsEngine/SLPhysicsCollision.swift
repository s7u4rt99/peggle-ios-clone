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

    // assuming circle
    func resolve() {
        let collisionVector = Vector(xDirection: secondBody.position.xCoordinate - firstBody.position.xCoordinate,
                                     yDirection: secondBody.position.yCoordinate - firstBody.position.yCoordinate)
        let distance = distanceBetween(firstPoint: firstBody.position, secondPoint: secondBody.position)
        let collisionNormalVector = Vector(xDirection: collisionVector.xDirection / (distance),
                                           yDirection: collisionVector.yDirection / (distance))
        let relativeVelocity = firstBody.velocity.subtract(vector: secondBody.velocity)
        let tempSpeed = (relativeVelocity.xDirection * collisionVector.xDirection +
                         relativeVelocity.yDirection * collisionVector.yDirection)
        let speedAfterScale = Double(tempSpeed) * speedScale
        let speedAfterRestitution = speedAfterScale * restitution
        let impulse = 2 * speedAfterRestitution / (firstBody.mass + secondBody.mass)
        if speedAfterRestitution >= 0 {
            firstBody.forces.append(collisionNormalVector.multiplyWithScalar(scalar: -1 * impulse * secondBody.mass))
            secondBody.forces.append(collisionNormalVector.multiplyWithScalar(scalar: impulse * firstBody.mass))
        }
    }

    private func distanceBetween(firstPoint: Point, secondPoint: Point) -> Double {
        let xDist = firstPoint.xCoordinate - secondPoint.xCoordinate
        let yDist = firstPoint.yCoordinate - secondPoint.yCoordinate
        return Double(sqrt(xDist * xDist + yDist * yDist))
    }
}
