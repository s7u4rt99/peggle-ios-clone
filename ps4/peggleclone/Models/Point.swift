//
//  Point.swift
//  peggleclone
//
//  Created by Stuart Long on 22/2/22.
//

import Foundation

struct Point: Equatable {
    var xCoordinate: Double
    var yCoordinate: Double

    init() {
        self.xCoordinate = 0
        self.yCoordinate = 0
    }

    init(xCoordinate: Double, yCoordinate: Double) {
        self.xCoordinate = xCoordinate
        self.yCoordinate = yCoordinate
    }

    func distanceFrom(point: Point) -> Double {
        let xDist = xCoordinate - point.xCoordinate
        let yDist = yCoordinate - point.yCoordinate

        return sqrt(xDist * xDist + yDist * yDist)
    }

    func vectorTo(point: Point) -> Vector {
        Vector(xDirection: point.xCoordinate - xCoordinate, yDirection: point.yCoordinate - yCoordinate)
    }
}
