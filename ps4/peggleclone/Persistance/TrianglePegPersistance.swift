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
    var minBase: Double
    var minHeight: Double
    var maxBase: Double
    var maxHeight: Double

    init(triangle: TriangleBlock) {
        self.base = triangle.base
        self.height = triangle.height
        self.minHeight = triangle.triangleHeightMin
        self.minBase = triangle.triangleBaseMin
        self.maxHeight = triangle.triangleHeightMax
        self.maxBase = triangle.triangleBaseMax
        super.init(triangle)
    }

    init(id: UUID, center: PointPersistance, base: Double, height: Double,
         minBase: Double, minHeight: Double, maxBase: Double, maxHeight: Double) {
        self.base = base
        self.height = height
        self.minBase = minBase
        self.minHeight = minHeight
        self.maxBase = maxBase
        self.maxHeight = maxHeight
        super.init(id: id, center: center)
    }

    private enum CodingKeys: String, CodingKey {
        case base
        case height
        case minBase
        case minHeight
        case maxBase
        case maxHeight
        case id
        case center
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.base = try container.decode(Double.self, forKey: .base)
        self.height = try container.decode(Double.self, forKey: .height)
        self.minBase = try container.decode(Double.self, forKey: .minBase)
        self.minHeight = try container.decode(Double.self, forKey: .minHeight)
        self.maxBase = try container.decode(Double.self, forKey: .maxBase)
        self.maxHeight = try container.decode(Double.self, forKey: .maxHeight)
        let id = try container.decode(UUID.self, forKey: .id)
        let center = try container.decode(PointPersistance.self, forKey: .center)
        super.init(id: id, center: center)
    }

    override public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(base, forKey: .base)
        try container.encode(height, forKey: .height)
        try container.encode(minBase, forKey: .minBase)
        try container.encode(minHeight, forKey: .minHeight)
        try container.encode(maxBase, forKey: .maxBase)
        try container.encode(maxHeight, forKey: .maxHeight)
        try container.encode(id, forKey: .id)
        try container.encode(center, forKey: .center)
    }
}
