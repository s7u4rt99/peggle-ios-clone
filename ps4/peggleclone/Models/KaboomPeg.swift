//
//  KaboomPeg.swift
//  peggleclone
//
//  Created by Stuart Long on 24/2/22.
//

import Foundation

class KaboomPeg: Peg {
    var activated = false
    var radiusOfExplosion: Double = 200.0

    init(center: Point, radius: Double = 25) {
        super.init(color: .greenPeg, center: center, radius: radius)
        self.shadow = .red
        self.shadowRadius = 30.0
    }

    init(id: UUID, center: Point, radius: Double = 25) {
        super.init(id: id, center: center, color: .greenPeg, radius: radius)
        self.shadow = .red
        self.shadowRadius = 30.0
    }

    override func glow() {
        self.color = .greenGlow
    }

    override func copy() -> Peg {
        KaboomPeg(center: self.center, radius: self.radius)
    }

    func setActivated() {
        self.activated = true
    }

    func setNotActivated() {
        self.activated = false
    }
}
