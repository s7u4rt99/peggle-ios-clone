//
//  Peg.swift
//  peggleclone
//
//  Created by Stuart Long on 25/1/22.
//

import Foundation
import SwiftUI

class Peg: Identifiable, Codable {
    var id: UUID
    var type: PegType
    var center: Point
    var radius: Double

    init(type: PegType, center: Point, radius: Double = 25) {
        self.id = UUID()
        self.type = type
        self.center = center
        self.radius = radius
    }

    func shiftTo(location: Point) {
        self.center = location
    }

    func overlap(peg: Peg) -> Bool {
        return distanceSquared(peg: peg) < self.radius * 2 * self.radius * 2
    }

    private func distanceSquared(peg: Peg) -> Double {
        let width = peg.center.xCoordinate - self.center.xCoordinate
        let height = peg.center.yCoordinate - self.center.yCoordinate

        return width * width + height * height
    }

    func glow() {
        if type == PegType.bluePeg {
            self.type = PegType.blueGlow
        } else if type == PegType.orangePeg {
            self.type = PegType.orangeGlow
        }
    }
}

extension Peg: Equatable {
    static func == (lhs: Peg, rhs: Peg) -> Bool {
        let isEqual = lhs.id == rhs.id && lhs.type == rhs.type && lhs.center == rhs.center && lhs.radius == rhs.radius
        return isEqual
    }
}

extension Peg: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
