//
//  SLPhysicsBucket.swift
//  peggleclone
//
//  Created by Stuart Long on 23/2/22.
//

import Foundation

class SLPhysicsBucket: SLPhysicsBody {
    var mass: Double = 0.0
    var velocity: Vector = Vector(xDirection: 100, yDirection: 0)
    var position: Point
    var gravity: Vector = Vector()
    var isDynamic: Bool = true
    var forces: [Vector] = []
    var collisionsWith: [SLPhysicsBody] = []
    var height: Double
    var width: Double
    var hasCollided: Bool = false
    var canIgnore: Bool = false

    init(position: Point, height: Double, width: Double) {
        self.position = position
        self.height = height
        self.width = width
    }

    func moveTo(position: Point) {
        self.position = position
    }

    func setVelocity(newVelocity: Vector) {
        self.velocity = newVelocity
    }

    func intersectWithCircle(circleBody: SLPhysicsBody) -> Bool {
        // TODO: implement this
        return false
    }

    func resolveForces() {
        // do nothing
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
        // do nothing
    }

    func setDynamic() {
        self.isDynamic = true
    }

    func addCollisionWith(physicsBody: SLPhysicsBody) {
        // do nothing
    }

    func clearCollisionsWith() {
        // do nothing
    }
}
