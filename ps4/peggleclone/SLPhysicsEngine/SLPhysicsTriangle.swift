//
//  SLPhysicsTriangle.swift
//  peggleclone
//
//  Created by Stuart Long on 25/2/22.
//

import Foundation

class SLPhysicsTriangle: SLPhysicsBody {
    var mass: Double
    var velocity: Vector
    var position: Point
    var gravity: Vector
    var isDynamic: Bool
    var forces: [Vector] = []
    var collisionsWith: [SLPhysicsBody] = []
    var height: Double
    var width: Double
    var hasCollided = false
    var canIgnore = false
    var vertexOne: Point
    var vertexTwo: Point
    var vertexThree: Point
    var previousPosition: Point

    init(velocity: Vector,
         position: Point,
         gravity: Vector = Vector(xDirection: 0, yDirection: 9.81),
         height: Double,
         width: Double,
         isDynamic: Bool) {
        self.velocity = velocity
        self.position = position
        self.gravity = gravity
        self.isDynamic = isDynamic
        self.mass = 1 / 2 * height * width
        self.height = height
        self.width = width
        self.vertexOne = Point(xCoordinate: position.xCoordinate,
                               yCoordinate: position.yCoordinate - height / 2)
        self.vertexTwo = Point(xCoordinate: position.xCoordinate - width / 2,
                               yCoordinate: position.yCoordinate + height / 2)
        self.vertexThree = Point(xCoordinate: position.xCoordinate + width / 2,
                                 yCoordinate: position.yCoordinate + height / 2)
        self.previousPosition = position
    }

    init(position: Point, height: Double, width: Double, isDynamic: Bool) {
        self.velocity = Vector()
        self.position = position
        self.gravity = Vector(xDirection: 0, yDirection: 9.81)
        self.isDynamic = isDynamic
        self.mass = 1 / 2 * height * width
        self.height = height
        self.width = width
        self.vertexOne = Point(xCoordinate: position.xCoordinate,
                               yCoordinate: position.yCoordinate - height / 2)
        self.vertexTwo = Point(xCoordinate: position.xCoordinate - width / 2,
                               yCoordinate: position.yCoordinate + height / 2)
        self.vertexThree = Point(xCoordinate: position.xCoordinate + width / 2,
                                 yCoordinate: position.yCoordinate + height / 2)
        self.previousPosition = position
    }

    func moveTo(position: Point) {
        self.position = position
        self.previousPosition = position
    }

    func setVelocity(newVelocity: Vector) {
        self.velocity = newVelocity
    }

    func intersectWith(physicsBody: SLPhysicsBody) -> Bool {
        if let circle = physicsBody as? SLPhysicsCircle {
            if vertexWithinCircle(vertex: vertexOne, circle: circle)
                || vertexWithinCircle(vertex: vertexTwo, circle: circle)
                || vertexWithinCircle(vertex: vertexThree, circle: circle) {
                return true
            }

            if circleWithinTriangle(circle: circle) {
                return true
            }

            if circleIntersectEdge(circle: circle) {
                return true
            }
            return false
        }
        return false
    }

    private func vertexWithinCircle(vertex: Point, circle: SLPhysicsCircle) -> Bool {
        let c1x = circle.position.xCoordinate - vertex.xCoordinate
        let c1y = circle.position.yCoordinate - vertex.yCoordinate
        let radiusSqr = circle.radius * circle.radius
        let c1sqr = c1x * c1x + c1y * c1y - radiusSqr

        if c1sqr <= 0 {
          return true
        }
        return false
    }

    private func circleWithinTriangle(circle: SLPhysicsCircle) -> Bool {
        let e1x = vertexTwo.xCoordinate - vertexOne.xCoordinate
        let e1y = vertexTwo.yCoordinate - vertexOne.yCoordinate
        let c1x = circle.position.xCoordinate - vertexOne.xCoordinate
        let c1y = circle.position.yCoordinate - vertexOne.yCoordinate

        let e2x = vertexThree.xCoordinate - vertexTwo.xCoordinate
        let e2y = vertexThree.yCoordinate - vertexTwo.yCoordinate
        let c2x = circle.position.xCoordinate - vertexTwo.xCoordinate
        let c2y = circle.position.yCoordinate - vertexTwo.yCoordinate

        let e3x = vertexOne.xCoordinate - vertexThree.xCoordinate
        let e3y = vertexOne.yCoordinate - vertexThree.yCoordinate
        let c3x = circle.position.xCoordinate - vertexThree.xCoordinate
        let c3y = circle.position.yCoordinate - vertexThree.yCoordinate

        if e1y * c1x - e1x * c1y >= 0
            && e2y * c2x - e2x * c2y >= 0
            && e3y * c3x - e3x * c3y >= 0 {
             return true
        }

        return false
    }

    private func circleIntersectEdge(circle: SLPhysicsCircle) -> Bool {
        let radiusSqr = circle.radius * circle.radius

        let e1x = vertexTwo.xCoordinate - vertexOne.xCoordinate
        let e1y = vertexTwo.yCoordinate - vertexOne.yCoordinate
        let c1x = circle.position.xCoordinate - vertexOne.xCoordinate
        let c1y = circle.position.yCoordinate - vertexOne.yCoordinate
        let c1sqr = c1x * c1x + c1y * c1y - radiusSqr

        let e2x = vertexThree.xCoordinate - vertexTwo.xCoordinate
        let e2y = vertexThree.yCoordinate - vertexTwo.yCoordinate
        let c2x = circle.position.xCoordinate - vertexTwo.xCoordinate
        let c2y = circle.position.yCoordinate - vertexTwo.yCoordinate
        let c2sqr = c2x * c2x + c2y * c2y - radiusSqr

        let e3x = vertexOne.xCoordinate - vertexThree.xCoordinate
        let e3y = vertexOne.yCoordinate - vertexThree.yCoordinate
        let c3x = circle.position.xCoordinate - vertexThree.xCoordinate
        let c3y = circle.position.yCoordinate - vertexThree.yCoordinate
        let c3sqr = c3x * c3x + c3y * c3y - radiusSqr

        var kValue = c1x * e1x + c1y * e1y

        if kValue > 0 {
          let len = e1x * e1x + e1y * e1y

          if kValue < len {
              if c1sqr * len <= kValue * kValue {
                  return true
              }
          }
        }

        kValue = c2x * e2x + c2y * e2y

        if kValue > 0 {
          let len = e2x * e2x + e2y * e2y

          if kValue < len {
              if c2sqr * len <= kValue * kValue {
                  return true
              }
          }
        }

        kValue = c3x * e3x + c3y * e3y

        if kValue > 0 {
          let len = e3x * e3x + e3y * e3y

          if kValue < len {
              if c3sqr * len <= kValue * kValue {
                  return true
              }
          }
        }

        return false
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

    func unignore() {
        self.canIgnore = false
    }
}
