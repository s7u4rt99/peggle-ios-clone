//
//  SpookyPeg.swift
//  peggleclone
//
//  Created by Stuart Long on 24/2/22.
//

import Foundation

class SpookyPeg: Peg {
    var activated = false

    init(center: Point, radius: Double) {
        super.init(color: .greenPeg, center: center, radius: radius)
        self.shadow = .blue
        self.shadowRadius = 30.0
    }

    init(center: Point, radius: Double, minRadius: Double, maxRadius: Double) {
        super.init(color: .greenPeg, center: center, radius: radius, minRadius: minRadius, maxRadius: maxRadius)
        self.shadow = .blue
        self.shadowRadius = 30.0
    }

    init(id: UUID, center: Point, radius: Double, minRadius: Double, maxRadius: Double) {
        super.init(id: id, center: center, color: .greenPeg, radius: radius,
                   minRadius: minRadius, maxRadius: maxRadius)
        self.shadow = .blue
        self.shadowRadius = 30.0
    }

    override func glow() {
        self.color = .greenGlow
    }

    func setActivated() {
        self.activated = true
    }

    func setNotActivated() {
        self.activated = false
    }

    override func copy() -> Peg {
        SpookyPeg(center: self.center, radius: self.radius, minRadius: self.pegMinRadius, maxRadius: self.pegMaxRadius)
    }
}
