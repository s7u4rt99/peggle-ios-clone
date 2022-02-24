//
//  TrianglePegPersistance.swift
//  peggleclone
//
//  Created by Stuart Long on 25/2/22.
//

import Foundation

class TrianglePegPersistance: PeggleObjectPersistance {
    var base: Double
    var height: Double

    init(triangle: TriangleBlock) {
        self.base = triangle.base
        self.height = triangle.height
        super.init(triangle)
    }

    init(id: UUID, center: PointPersistance, base: Double, height: Double) {
        self.base = base
        self.height = height
        super.init(id: id, center: center)
    }

    private enum CodingKeys: String, CodingKey {
        case base
        case height
        case id
        case center
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.base = try container.decode(Double.self, forKey: .base)
        self.height = try container.decode(Double.self, forKey: .height)
        let id = try container.decode(UUID.self, forKey: .id)
        let center = try container.decode(PointPersistance.self, forKey: .center)
        super.init(id: id, center: center)
    }

    override public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(base, forKey: .base)
        try container.encode(height, forKey: .height)
        try container.encode(id, forKey: .id)
        try container.encode(center, forKey: .center)
    }
}
