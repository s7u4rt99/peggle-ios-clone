//
//  PegPersistance.swift
//  peggleclone
//
//  Created by Stuart Long on 23/2/22.
//

import Foundation

class PegPersistance: PeggleObjectPersistance {
    var type: PegType
    var radius: Double

    init(_ peg: Peg) {
        self.type = peg.type
        self.radius = peg.radius
        super.init(peg)
    }

    private enum CodingKeys: String, CodingKey {
        case type
        case radius
        case id
        case center
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.type = try container.decode(PegType.self, forKey: .type)
        self.radius = try container.decode(Double.self, forKey: .radius)
        let id = try container.decode(UUID.self, forKey: .id)
        let center = try container.decode(PointPersistance.self, forKey: .center)
        super.init(id: id, center: center)
    }

    override public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(type, forKey: .type)
        try container.encode(radius, forKey: .radius)
        try container.encode(id, forKey: .id)
        try container.encode(center, forKey: .center)
    }
}
