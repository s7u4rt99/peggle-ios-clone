//
//  PegPersistance.swift
//  peggleclone
//
//  Created by Stuart Long on 23/2/22.
//

import Foundation
import SwiftUI

class PegPersistance: PeggleObjectPersistance {
    var color: PegState
    var radius: Double
    var shadow: Color = .white
    var shadowRadius: Double = 0.0
    var minRadius: Double
    var maxRadius: Double

    init(_ peg: Peg) {
        self.color = peg.color
        self.radius = peg.radius
        self.minRadius = peg.pegMinRadius
        self.maxRadius = peg.pegMaxRadius
        super.init(peg)
    }

    init(id: UUID, center: PointPersistance, color: PegState, radius: Double, minRadius: Double, maxRadius: Double) {
        self.color = color
        self.radius = radius
        self.minRadius = minRadius
        self.maxRadius = maxRadius
        super.init(id: id, center: center)
    }

    private enum CodingKeys: String, CodingKey {
        case color
        case radius
        case minRadius
        case maxRadius
        case id
        case center
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.color = try container.decode(PegState.self, forKey: .color)
        self.radius = try container.decode(Double.self, forKey: .radius)
        self.minRadius = try container.decode(Double.self, forKey: .minRadius)
        self.maxRadius = try container.decode(Double.self, forKey: .maxRadius)
        self.shadow = .white
        self.shadowRadius = 0.0
        let id = try container.decode(UUID.self, forKey: .id)
        let center = try container.decode(PointPersistance.self, forKey: .center)
        super.init(id: id, center: center)
    }

    override public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(color, forKey: .color)
        try container.encode(radius, forKey: .radius)
        try container.encode(minRadius, forKey: .minRadius)
        try container.encode(maxRadius, forKey: .maxRadius)
        try container.encode(id, forKey: .id)
        try container.encode(center, forKey: .center)
    }
}
