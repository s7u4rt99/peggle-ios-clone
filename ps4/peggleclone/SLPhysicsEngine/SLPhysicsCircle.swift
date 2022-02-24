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
    var velocity: Vector
    var position: Point
    var gravity: Vector
    var isDynamic: Bool
    var forces: [Vector] = []
    var collisionsWith: [SLPhysicsBody] = []
    var radius: Double
    var hasCollided = false
    var canIgnore = false

    init(velocity: Vector,
         position: Point,
         gravity: Vector = Vector(xDirection: 0, yDirection: 9.81),
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

    init(position: Point, isDynamic: Bool, radius: Double) {
        self.velocity = Vector()
        self.position = position
        self.gravity = Vector(xDirection: 0, yDirection: 9.81)
        self.isDynamic = isDynamic
        self.radius = radius
        self.mass = Double.pi * radius * radius
        self.height = radius * 2
        self.width = radius * 2
    }

    func moveTo(position: Point) {
        self.position = position
    }

    func setVelocity(newVelocity: Vector) {
        self.velocity = newVelocity
    }

    func intersectWith(physicsBody: SLPhysicsBody) -> Bool {
        if let collidingCircle = physicsBody as? SLPhysicsCircle {
            return isColliding(collidingCircle: collidingCircle)
        } else if let collidingBucket = physicsBody as? SLPhysicsBucket {
            return collidingBucket.intersectWith(physicsBody: self)
        }
        fatalError("Argument is not a circle or bucket")
    }

    private func isColliding(collidingCircle: SLPhysicsCircle) -> Bool {
        let xDistance = self.position.xCoordinate - collidingCircle.position.xCoordinate
        let yDistance = self.position.yCoordinate - collidingCircle.position.yCoordinate
        let closestRange = self.radius + collidingCircle.radius
        return (xDistance * xDistance + yDistance * yDistance) <= (closestRange * closestRange)
    }

    func resolveForces() {
        var resultantForce = Vector()
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

    func addForceToVelocity(force: Vector) {
        setVelocity(newVelocity: force.addTo(vector: self.velocity))
    }
}
