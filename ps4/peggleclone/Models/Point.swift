//
//  Point.swift
//  peggleclone
//
//  Created by Stuart Long on 22/2/22.
//

import Foundation

struct Point: Codable, Equatable {
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
}
