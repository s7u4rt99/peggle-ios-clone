//
//  Peg.swift
//  peggleclone
//
//  Created by Stuart Long on 25/1/22.
//

import Foundation
import SwiftUI

class Peg: PeggleObject {
    static let pegMinRadius = 25.0
    static let pegMaxRadius = 50.0
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
            print("self.radius \(self.radius)")
            print("peg.radius \(peg.radius)")
            return distanceSquared(peg: peg) <= (self.radius + peg.radius) * (self.radius + peg.radius)
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

//    override func scale(_ scale: Double) {
//        self.radius = radius + 50// radius * (1 + scale)
//    }
    override func resizeObject(location: Point, peggleObjects: [PeggleObject]) -> Double {
        var distance = center.distanceFrom(point: location)
        if distance < Peg.pegMinRadius {
            distance = Peg.pegMinRadius
        } else if distance > Peg.pegMaxRadius {
            distance = Peg.pegMaxRadius
        }
        for peggleObject in peggleObjects where peggleObject.id != self.id {
            if peggleObject.overlap(peggleObject: Peg(color: self.color, center: self.center, radius: distance)) {
                return -1
            }
        }
        self.radius = distance
        return distance
    }

    // TODO: refactor into own cannonball class
    override func spooked() {
        self.shadowRadius = 30.0
        self.shadow = .blue
    }
}
