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
        } else if let circle = firstBody as? SLPhysicsCircle,
                  let triangle = secondBody as? SLPhysicsTriangle {
            resolveTriangleCircleCollision(triangle: triangle, circle: circle)
        } else if let triangle = firstBody as? SLPhysicsTriangle,
                  let circle = secondBody as? SLPhysicsCircle {
            resolveTriangleCircleCollision(triangle: triangle, circle: circle)
        }
    }

    private func resolveTriangleCircleCollision(triangle: SLPhysicsTriangle, circle: SLPhysicsCircle) {
        var restitution = 0.85
        if circleIntersectTriangleVertices(triangle: triangle, circle: circle) {
            restitution = 0.95
            circle.setVelocity(newVelocity: circle.velocity.negate().multiplyWithScalar(scalar: restitution))
        } else if circleIntersectEdge(circle: circle, vertexOne: triangle.vertexOne, vertexTwo: triangle.vertexTwo) {
            // rebound counter clockwise
            let resultant = Vector(xDirection: -circle.velocity.yDirection,
                                   yDirection: circle.velocity.xDirection)
            circle.setVelocity(newVelocity: resultant.multiplyWithScalar(scalar: restitution))
        } else if circleIntersectEdge(circle: circle, vertexOne: triangle.vertexTwo, vertexTwo: triangle.vertexThree) {
            // rebound clockwise
            let resultant = Vector(xDirection: circle.velocity.yDirection,
                                   yDirection: -circle.velocity.xDirection)
            circle.setVelocity(newVelocity: resultant.multiplyWithScalar(scalar: restitution))
        } else if circleIntersectEdge(circle: circle, vertexOne: triangle.vertexThree, vertexTwo: triangle.vertexOne) {
            // rebound clockwise
            let resultant = Vector(xDirection: circle.velocity.yDirection,
                                   yDirection: -circle.velocity.xDirection)
            circle.setVelocity(newVelocity: resultant.multiplyWithScalar(scalar: restitution))
        }
    }

    private func circleIntersectTriangleVertices(
        triangle: SLPhysicsTriangle, circle: SLPhysicsCircle) -> Bool {
            circle.containsPoint(triangle.vertexOne)
            || circle.containsPoint(triangle.vertexTwo)
            || circle.containsPoint(triangle.vertexThree)
    }

    private func circleIntersectEdge(circle: SLPhysicsCircle, vertexOne: Point, vertexTwo: Point) -> Bool {
        let radiusSqr = circle.radius * circle.radius

        let e1x = vertexTwo.xCoordinate - vertexOne.xCoordinate
        let e1y = vertexTwo.yCoordinate - vertexOne.yCoordinate
        let c1x = circle.position.xCoordinate - vertexOne.xCoordinate
        let c1y = circle.position.yCoordinate - vertexOne.yCoordinate
        let c1sqr = c1x * c1x + c1y * c1y - radiusSqr

        let kValue = c1x * e1x + c1y * e1y

        if kValue > 0 {
          let len = e1x * e1x + e1y * e1y

          if kValue < len {
              if c1sqr * len <= kValue * kValue {
                  return true
              }
          }
        }
        return false
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
        let distance = 2 * max(firstCircle.radius, secondCircle.radius)
        let collisionNormalVector = Vector(xDirection: collisionVector.xDirection / (distance),
                                           yDirection: collisionVector.yDirection / (distance))
        let relativeVelocity = firstCircle.velocity.subtract(vector: secondCircle.velocity)
        let tempSpeed = (relativeVelocity.xDirection * collisionVector.xDirection +
                         relativeVelocity.yDirection * collisionVector.yDirection)
        let speedAfterScale = Double(tempSpeed) * speedScale
        let speedAfterRestitution = speedAfterScale * restitution
        if speedAfterRestitution >= 0 {
            firstCircle.forces.append(collisionNormalVector
                                        .multiplyWithScalar(scalar: -1 * speedAfterRestitution))
            secondCircle.forces.append(collisionNormalVector
                                        .multiplyWithScalar(scalar: speedAfterRestitution))
        }
    }

    private func distanceBetween(firstPoint: Point, secondPoint: Point) -> Double {
        let xDist = firstPoint.xCoordinate - secondPoint.xCoordinate
        let yDist = firstPoint.yCoordinate - secondPoint.yCoordinate
        return Double(sqrt(xDist * xDist + yDist * yDist))
    }
}
