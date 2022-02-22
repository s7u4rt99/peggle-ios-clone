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
        let collisionVector = CGVector(dx: secondBody.position.x - firstBody.position.x,
                                       dy: secondBody.position.y - firstBody.position.y)
        let distance = distanceBetween(firstPoint: firstBody.position, secondPoint: secondBody.position)
        let collisionNormalVector = CGVector(dx: collisionVector.dx / (distance),
                                             dy: collisionVector.dy / (distance))
        let relativeVelocity = firstBody.velocity.subtract(vector: secondBody.velocity)
        let tempSpeed = (relativeVelocity.dx * collisionVector.dx + relativeVelocity.dy * collisionVector.dy)
        let speedAfterScale = Double(tempSpeed) * speedScale
        let speedAfterRestitution = speedAfterScale * restitution
        let impulse = 2 * speedAfterRestitution / (firstBody.mass + secondBody.mass)
        if speedAfterRestitution >= 0 {
            firstBody.forces.append(collisionNormalVector.multiplyWithScalar(scalar: -1 * impulse * secondBody.mass))
            secondBody.forces.append(collisionNormalVector.multiplyWithScalar(scalar: impulse * firstBody.mass))
        }
    }

    private func distanceBetween(firstPoint: CGPoint, secondPoint: CGPoint) -> Double {
        let xDist = firstPoint.x - secondPoint.x
        let yDist = firstPoint.y - secondPoint.y
        return Double(sqrt(xDist * xDist + yDist * yDist))
    }
}
