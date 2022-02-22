//
//  CGVector+Methods.swift
//  peggleclone
//
//  Created by Stuart Long on 9/2/22.
//

import Foundation
import SwiftUI

extension CGVector {

    var magnitude: Double {
        sqrt(self.dx * self.dx + self.dy * self.dy)
    }

    var isStationary: Bool {
        self.dx == 0 && self.dy == 0
    }

    func addTo(vector: CGVector, scale: Double = 1) -> CGVector {
        CGVector(dx: self.dx + (vector.dx * scale), dy: self.dy + (vector.dy * scale))
    }

    func addTo(point: CGPoint) -> CGPoint {
        CGPoint(x: self.dx + point.x, y: self.dy + point.y)
    }

    func applyTo(point: CGPoint, duration: TimeInterval) -> CGPoint {
        CGPoint(x: self.dx * duration + point.x, y: self.dy * duration + point.y)
    }

    func negate() -> CGVector {
        CGVector(dx: -self.dx, dy: -self.dy)
    }

    func dotProductWith(vector: CGVector) -> Double {
        self.dx * vector.dx + self.dy * vector.dy
    }

    func subtract(vector: CGVector) -> CGVector {
        CGVector(dx: self.dx - vector.dx, dy: self.dy - vector.dy)
    }

    func squareDistanceTo(vector: CGVector) -> Double {
        let horizontalDistance = self.dx - vector.dx
        let verticalDistance = self.dy - vector.dy
        return horizontalDistance * horizontalDistance + verticalDistance * verticalDistance
    }

    func normalize() -> CGVector {
        CGVector(dx: self.dx / magnitude, dy: self.dy / magnitude)
    }

    func multiplyWithScalar(scalar: Double) -> CGVector {
        CGVector(dx: self.dx * scalar, dy: self.dy * scalar)
    }

    func movePointBy(point: CGPoint, distance: Double) -> CGPoint {
        let unitVector = self.multiplyWithScalar(scalar: 1 / magnitude)
        let vectorToMovePointBy = unitVector.multiplyWithScalar(scalar: distance)
        return vectorToMovePointBy.addTo(point: point)
    }
}
