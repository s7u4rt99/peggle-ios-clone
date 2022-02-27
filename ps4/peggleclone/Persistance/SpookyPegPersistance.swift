//
//  SpookyPegPersistance.swift
//  peggleclone
//
//  Created by Stuart Long on 24/2/22.
//

import Foundation

class SpookyPegPersistance: PegPersistance {
    init(_ spookyPeg: SpookyPeg) {
        super.init(spookyPeg)
        self.shadow = spookyPeg.shadow
        self.shadowRadius = spookyPeg.shadowRadius
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
        let color = try container.decode(PegState.self, forKey: .color)
        let radius = try container.decode(Double.self, forKey: .radius)
        let minRadius = try container.decode(Double.self, forKey: .minRadius)
        let maxRadius = try container.decode(Double.self, forKey: .maxRadius)
        let id = try container.decode(UUID.self, forKey: .id)
        let center = try container.decode(PointPersistance.self, forKey: .center)
        super.init(id: id, center: center, color: color, radius: radius, minRadius: minRadius, maxRadius: maxRadius)
        self.shadow = .blue
        self.shadowRadius = 10.0
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
