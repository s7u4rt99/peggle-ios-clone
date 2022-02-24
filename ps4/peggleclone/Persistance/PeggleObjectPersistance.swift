//
//  PeggleObjectPersistance.swift
//  peggleclone
//
//  Created by Stuart Long on 23/2/22.
//

import Foundation

class PeggleObjectPersistance: Codable {
    var id: UUID
    var center: PointPersistance

    init(_ peggleObject: PeggleObject) {
        self.id = peggleObject.id
        self.center = PointPersistance(xCoordinate: peggleObject.center.xCoordinate,
                                       yCoordinate: peggleObject.center.yCoordinate)
    }

    init(id: UUID, center: PointPersistance) {
        self.id = id
        self.center = center
    }

    private enum CodingKeys: String, CodingKey {
        case id
        case center
        case typeOfObject
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(UUID.self, forKey: .id)
        self.center = try container.decode(PointPersistance.self, forKey: .center)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(center, forKey: .center)
    }
}

extension PeggleObjectPersistance {
    enum PeggleObjectPersistanceType: String, Codable {
        case peg
        case cannonBall
        case unknown
    }
}
