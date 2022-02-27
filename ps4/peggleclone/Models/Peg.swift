//
//  Peg.swift
//  peggleclone
//
//  Created by Stuart Long on 25/1/22.
//

import Foundation
import SwiftUI

class Peg: PeggleObject {
    // TODO: change
    static let pegMinRadiusRatio = 0.03
    static let pegMaxRadiusRatio = 0.06
    var pegMinRadius: Double
    var pegMaxRadius: Double
    var color: PegState
    var radius: Double
    var shadow: Color = .white
    var shadowRadius: Double = 0.0
    var points: Int

    init(color: PegState, center: Point, radius: Double) {
        self.color = color
        self.radius = radius
        if self.color == .orangePeg {
            self.points = 100
        } else {
            self.points = 10
        }
        self.pegMinRadius = radius
        self.pegMaxRadius = 2 * radius
        super.init(center: center)
    }

    init(color: PegState, center: Point, radius: Double, minRadius: Double, maxRadius: Double) {
        self.color = color
        self.radius = radius
        if self.color == .orangePeg {
            self.points = 100
        } else {
            self.points = 10
        }
        self.pegMinRadius = minRadius
        self.pegMaxRadius = maxRadius
        super.init(center: center)
    }

    init(id: UUID, center: Point, color: PegState, radius: Double) {
        self.color = color
        self.radius = radius
        if self.color == .orangePeg {
            self.points = 100
        } else {
            self.points = 10
        }
        self.pegMinRadius = radius
        self.pegMaxRadius = 2 * radius
        super.init(id: id, center: center)
    }

    init(id: UUID, center: Point, color: PegState, radius: Double, minRadius: Double, maxRadius: Double) {
        self.color = color
        self.radius = radius
        if self.color == .orangePeg {
            self.points = 100
        } else {
            self.points = 10
        }
        self.pegMinRadius = minRadius
        self.pegMaxRadius = maxRadius
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
        if color == PegState.bluePeg {
            self.color = PegState.blueGlow
        } else if color == PegState.orangePeg {
            self.color = PegState.orangeGlow
        }
    }

    override func copy() -> Peg {
        Peg(color: self.color, center: self.center, radius: self.radius, minRadius: self.pegMinRadius, maxRadius: self.pegMaxRadius)
    }

//    override func scale(_ scale: Double) {
//        self.radius = radius + 50// radius * (1 + scale)
//    }
    override func resizeObject(location: Point, peggleObjects: [PeggleObject], width: Double, height: Double) {
        var distance = center.distanceFrom(point: location)
        if distance < pegMinRadius {
            distance = pegMinRadius
        } else if distance > pegMaxRadius {
            distance = pegMaxRadius
        }
        for peggleObject in peggleObjects where peggleObject.id != self.id {
            if peggleObject.overlap(peggleObject: Peg(color: self.color, center: self.center, radius: distance)) {
                return
            }
        }
        if withinScreen(peg: Peg(color: self.color, center: self.center, radius: distance),
                        width: width, height: height) {
            self.radius = distance
        }
    }

    private func withinScreen(peg: Peg, width: Double, height: Double) -> Bool {
        peg.center.xCoordinate >= peg.radius
        && peg.center.xCoordinate <= (width - peg.radius)
        && peg.center.yCoordinate >= peg.radius
        && peg.center.yCoordinate <= (height - peg.radius)
    }

    // TODO: refactor into own cannonball class
    override func spooked() {
        self.shadowRadius = 30.0
        self.shadow = .blue
    }
}
