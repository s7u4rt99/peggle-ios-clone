//
//  SpookyPeg.swift
//  peggleclone
//
//  Created by Stuart Long on 24/2/22.
//

import Foundation

class SpookyPeg: Peg {
    var activated = false

    init(center: Point, radius: Double = 25) {
        super.init(color: .greenPeg, center: center, radius: radius)
        self.shadow = .blue
        self.shadowRadius = 10.0
    }

    init(id: UUID, center: Point, radius: Double = 25) {
        super.init(id: id, center: center, color: .greenPeg, radius: radius)
        self.shadow = .blue
        self.shadowRadius = 10.0
    }

    override func glow() {
        self.color = .greenGlow
    }

    func setActivated() {
        self.activated = true
    }

    override func copy() -> Peg {
        SpookyPeg(center: self.center, radius: self.radius)
    }
}
