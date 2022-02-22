//
//  SLPhysicsCircle.swift
//  peggleclone
//
//  Created by Stuart Long on 9/2/22.
//

import Foundation
import SwiftUI

class SLPhysicsCircle: SLPhysicsBody {
    var height: Double
    var width: Double
    var mass: Double
    var velocity: CGVector
    var position: CGPoint
    var gravity: CGVector
    var isDynamic: Bool
    var forces: [CGVector] = []
    var collisionsWith: [SLPhysicsBody] = []
    var radius: Double
    var hasCollided = false
    var canIgnore = false

    init(velocity: CGVector,
         position: CGPoint,
         gravity: CGVector = CGVector(dx: 0, dy: 9.81),
         isDynamic: Bool,
         radius: Double) {
        self.velocity = velocity
        self.position = position
        self.gravity = gravity
        self.isDynamic = isDynamic
        self.radius = radius
        self.mass = Double.pi * radius * radius
        self.height = radius * 2
        self.width = radius * 2
    }

    init(position: CGPoint, isDynamic: Bool, radius: Double) {
        self.velocity = CGVector()
        self.position = position
        self.gravity = CGVector(dx: 0, dy: 9.81)
        self.isDynamic = isDynamic
        self.radius = radius
        self.mass = Double.pi * radius * radius
        self.height = radius * 2
        self.width = radius * 2
    }

    func moveTo(position: CGPoint) {
        self.position = position
    }

    func setVelocity(newVelocity: CGVector) {
        self.velocity = newVelocity
    }

    func intersectWithCircle(circleBody: SLPhysicsBody) -> Bool {
        if let collidingCircle = circleBody as? SLPhysicsCircle {
            return isColliding(collidingCircle: collidingCircle)
        }
        fatalError("Argument is not a circle")
    }

    private func isColliding(collidingCircle: SLPhysicsCircle) -> Bool {
        let xDistance = self.position.x - collidingCircle.position.x
        let yDistance = self.position.y - collidingCircle.position.y
        let closestRange = self.radius + collidingCircle.radius
        return (xDistance * xDistance + yDistance * yDistance) <= (closestRange * closestRange)
    }

    func resolveForces() {
        var resultantForce = CGVector()
        for force in forces {
            resultantForce = resultantForce.addTo(vector: force)
        }
        resultantForce = resultantForce.addTo(vector: gravity)
        setVelocity(newVelocity: self.velocity.addTo(vector: resultantForce))
        forces.removeAll()
    }

    func setNotDynamic() {
        self.isDynamic = false
    }

    func setCollided() {
        self.hasCollided = true
    }

    func ignore() {
        self.canIgnore = true
    }

    func moveBackBy(distance: Double) {
        // have velocity and point
        let oppositeVelocity = velocity.negate()
        moveTo(position: oppositeVelocity.movePointBy(point: position, distance: distance))
    }

    func setDynamic() {
        self.isDynamic = true
    }

    func addCollisionWith(physicsBody: SLPhysicsBody) {
        self.collisionsWith.append(physicsBody)
    }

    func clearCollisionsWith() {
        self.collisionsWith.removeAll()
    }
}
