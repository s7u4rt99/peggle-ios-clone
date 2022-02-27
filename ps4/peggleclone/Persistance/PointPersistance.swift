//
//  PointPersistance.swift
//  peggleclone
//
//  Created by Stuart Long on 23/2/22.
//

import Foundation

struct PointPersistance: Codable {
    var xCoordinate: Double
    var yCoordinate: Double

    init(xCoordinate: Double, yCoordinate: Double) {
        self.xCoordinate = xCoordinate
        self.yCoordinate = yCoordinate
    }

    func convertToPoint(xScale: Double, yScale: Double) -> Point {
        Point(xCoordinate: self.xCoordinate * xScale, yCoordinate: self.yCoordinate * yScale)
    }
}
