//
//  Peg.swift
//  peggleclone
//
//  Created by Stuart Long on 25/1/22.
//

import Foundation
import SwiftUI

class Peg: PeggleObject {
    var type: PegType
    var radius: Double

    init(type: PegType, center: Point, radius: Double = 25) {
        self.type = type
        self.radius = radius
        super.init(center: center)
    }

    init(id: UUID, center: Point, type: PegType, radius: Double = 25) {
        self.type = type
        self.radius = radius
        super.init(id: id, center: center)
    }

    private enum CodingKeys: String, CodingKey {
        case type
        case radius
    }

    override func overlap(peg: Peg) -> Bool {
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

    override func copy() -> Peg {
        Peg(type: self.type, center: self.center, radius: self.radius)
    }
}
