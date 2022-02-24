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

    func intersectWith(physicsBody: SLPhysicsBody) -> Bool {
        // 2 points for each line
        let leftTop = Point(xCoordinate: position.xCoordinate - width / 2,
                            yCoordinate: position.yCoordinate + height / 2)
        let leftBottom = Point(xCoordinate: position.xCoordinate - width / 2,
                               yCoordinate: position.yCoordinate - height / 2)
        let rightTop = Point(xCoordinate: position.xCoordinate + width / 2,
                             yCoordinate: position.yCoordinate + height / 2)
        let rightBottom = Point(xCoordinate: position.xCoordinate + width / 2,
                                yCoordinate: position.yCoordinate - height / 2)

        if let circleBody = physicsBody as? SLPhysicsCircle {
            return lineIntersectWithCircle(lineTop: leftTop, lineBottom: leftBottom, circle: circleBody)
            || lineIntersectWithCircle(lineTop: rightTop, lineBottom: rightBottom, circle: circleBody)
        }
        fatalError("Shape not implemented yet")
    }

    private func lineIntersectWithCircle(lineTop: Point, lineBottom: Point, circle: SLPhysicsCircle) -> Bool {
        let circleCenter = circle.position
        let centerToTop = Vector(xDirection: lineTop.xCoordinate - circleCenter.xCoordinate,
                                 yDirection: lineTop.yCoordinate - circleCenter.yCoordinate)
        let centerToBottom = Vector(xDirection: lineBottom.xCoordinate - circleCenter.xCoordinate,
                                    yDirection: lineBottom.yCoordinate - circleCenter.yCoordinate)
        let topToBottom = Vector(xDirection: lineBottom.xCoordinate - lineTop.xCoordinate,
                                 yDirection: lineBottom.yCoordinate - lineTop.yCoordinate)
        let bottomToTop = Vector(xDirection: lineTop.xCoordinate - lineBottom.xCoordinate,
                                 yDirection: lineTop.yCoordinate - lineBottom.yCoordinate)

        if centerToTop.dotProductWith(vector: bottomToTop) > 0 &&
            centerToBottom.dotProductWith(vector: topToBottom) > 0 {
            let crossProduct = abs(centerToTop.xDirection * centerToBottom.yDirection
                                   - centerToTop.yDirection * centerToBottom.xDirection)
            let areaOfTriangle = crossProduct / 2
            let shortestDistance = 2 * areaOfTriangle / topToBottom.magnitude
//            if shortestDistance <= circle.radius {
//                print(true)
//            }
            return shortestDistance <= circle.radius
        } else {
//            let shortestDistance = min(centerToTop.magnitude, centerToBottom.magnitude)
//            if centerToTop.magnitude <= circle.radius || centerToBottom.magnitude <= circle.radius {
//                print(true)
//            }
            return centerToTop.magnitude <= circle.radius || centerToBottom.magnitude <= circle.radius
        }
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

    func addForceToVelocity(force: Vector) {
        // do nothing
    }
}
