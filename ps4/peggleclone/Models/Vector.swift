//
//  Vector.swift
//  peggleclone
//
//  Created by Stuart Long on 22/2/22.
//

import Foundation

struct Vector {
    var xDirection: Double
    var yDirection: Double
    
    init() {
        self.xDirection = 0
        self.yDirection = 0
    }

    init(xDirection: Double, yDirection: Double) {
        self.xDirection = xDirection
        self.yDirection = yDirection
    }

    var magnitude: Double {
        sqrt(self.xDirection * self.xDirection + self.yDirection * self.yDirection)
    }

    var isStationary: Bool {
        self.xDirection == 0 && self.yDirection == 0
    }

    func addTo(vector: Vector, scale: Double = 1) -> Vector {
        Vector(xDirection: self.xDirection + (vector.xDirection * scale),
               yDirection: self.yDirection + (vector.yDirection * scale))
    }

    func addTo(point: Point) -> Point {
        Point(xCoordinate: self.xDirection + point.xCoordinate,
              yCoordinate: self.yDirection + point.yCoordinate)
    }

    func applyTo(point: Point, duration: TimeInterval) -> Point {
        Point(xCoordinate: self.xDirection * duration + point.xCoordinate,
              yCoordinate: self.yDirection * duration + point.yCoordinate)
    }

    func negate() -> Vector {
        Vector(xDirection: -self.xDirection, yDirection: -self.yDirection)
    }

    func dotProductWith(vector: Vector) -> Double {
        self.xDirection * vector.xDirection + self.yDirection * vector.yDirection
    }

    func subtract(vector: Vector) -> Vector {
        Vector(xDirection: self.xDirection - vector.xDirection,
               yDirection: self.yDirection - vector.yDirection)
    }

    func squareDistanceTo(vector: Vector) -> Double {
        let horizontalDistance = self.xDirection - vector.xDirection
        let verticalDistance = self.yDirection - vector.yDirection
        return horizontalDistance * horizontalDistance + verticalDistance * verticalDistance
    }

    func normalize() -> Vector {
        Vector(xDirection: self.xDirection / magnitude, yDirection: self.yDirection / magnitude)
    }

    func multiplyWithScalar(scalar: Double) -> Vector {
        Vector(xDirection: self.xDirection * scalar, yDirection: self.yDirection * scalar)
    }

    func movePointBy(point: Point, distance: Double) -> Point {
        let unitVector = self.multiplyWithScalar(scalar: 1 / magnitude)
        let vectorToMovePointBy = unitVector.multiplyWithScalar(scalar: distance)
        return vectorToMovePointBy.addTo(point: point)
    }
}
