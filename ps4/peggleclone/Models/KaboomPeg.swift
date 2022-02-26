//
//  KaboomPeg.swift
//  peggleclone
//
//  Created by Stuart Long on 24/2/22.
//

import Foundation

class KaboomPeg: Peg {
    var activated = false
    var radiusOfExplosion: Double = 100.0
    var explosionState = 1
    var radiusOfPeg: Double

    init(center: Point, radius: Double = 25) {
        self.radiusOfPeg = radius
        super.init(color: .greenPeg, center: center, radius: radius)
        self.shadow = .red
        self.shadowRadius = 30.0
    }

    init(id: UUID, center: Point, radius: Double = 25) {
        self.radiusOfPeg = radius
        super.init(id: id, center: center, color: .greenPeg, radius: radius)
        self.shadow = .red
        self.shadowRadius = 30.0
    }

    override func glow() {
        renderExplosion()
        //        self.color = .greenGlow
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

    func renderExplosion() {
        if color == .greenPeg {
            color = .explosion1
            self.radius = radiusOfExplosion * 1.50
        } else if color == .explosion20 {
            self.radius = radiusOfPeg
            color = .greenGlow
        } else if color != .greenGlow {
            explosionState += 1
            guard let newColor = PegState(rawValue: "explosion-\(explosionState)") else {
                color = .greenGlow
                return
            }
            color = newColor
        }
    }
}
