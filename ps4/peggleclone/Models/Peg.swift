//
//  Peg.swift
//  peggleclone
//
//  Created by Stuart Long on 25/1/22.
//

import Foundation
import SwiftUI

class Peg: PeggleObject {
    var color: PegColor
    var radius: Double
    var shadow: Color = .white
    var shadowRadius: Double = 0.0

    init(color: PegColor, center: Point, radius: Double = 25) {
        self.color = color
        self.radius = radius
        super.init(center: center)
    }

    init(id: UUID, center: Point, color: PegColor, radius: Double = 25) {
        self.color = color
        self.radius = radius
        super.init(id: id, center: center)
    }

    override func overlap(peggleObject: PeggleObject) -> Bool {
        if let peg = peggleObject as? Peg {
            return distanceSquared(peg: peg) < self.radius * 2 * self.radius * 2
        } else if let triangle = peggleObject as? TriangleBlock {
            return triangle.overlap(peggleObject: self)
        } else {
            return false
        }
    }

    private func distanceSquared(peg: Peg) -> Double {
        let width = peg.center.xCoordinate - self.center.xCoordinate
        let height = peg.center.yCoordinate - self.center.yCoordinate

        return width * width + height * height
    }

    func glow() {
        if color == PegColor.bluePeg {
            self.color = PegColor.blueGlow
        } else if color == PegColor.orangePeg {
            self.color = PegColor.orangeGlow
        }
    }

    override func copy() -> Peg {
        Peg(color: self.color, center: self.center, radius: self.radius)
    }

    // TODO: refactor into own cannonball class
    override func spooked() {
        self.shadowRadius = 30.0
        self.shadow = .blue
    }
}
