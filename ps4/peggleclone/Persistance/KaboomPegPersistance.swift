//
//  KaboomPegPersistance.swift
//  peggleclone
//
//  Created by Stuart Long on 24/2/22.
//

import Foundation

class KaboomPegPersistance: PegPersistance {
    init(_ kaboomPeg: KaboomPeg) {
        super.init(kaboomPeg)
        self.shadow = kaboomPeg.shadow
        self.shadowRadius = kaboomPeg.shadowRadius
    }

    private enum CodingKeys: String, CodingKey {
        case color
        case radius
        case id
        case center
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let color = try container.decode(PegColor.self, forKey: .color)
        let radius = try container.decode(Double.self, forKey: .radius)
        let id = try container.decode(UUID.self, forKey: .id)
        let center = try container.decode(PointPersistance.self, forKey: .center)
        super.init(id: id, center: center, color: color, radius: radius)
        self.shadow = .red
        self.shadowRadius = 10.0
    }

    override public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(color, forKey: .color)
        try container.encode(radius, forKey: .radius)
        try container.encode(id, forKey: .id)
        try container.encode(center, forKey: .center)
    }
}
