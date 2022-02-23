//
//  LevelPersistance.swift
//  peggleclone
//
//  Created by Stuart Long on 23/2/22.
//

import Foundation

struct LevelPersistance: Codable {
    var id: UUID
    var name: String
    var pegPersistances: [PegPersistance]

    init(level: Level) {
        self.id = level.id
        self.name = level.name
        self.pegPersistances = []
        initialisePegPersistanceArr(level.pegs)
    }

    mutating func initialisePegPersistanceArr(_ pegs: [Peg]) {
        for peg in pegs {
            pegPersistances.append(PegPersistance(peg))
        }
    }

    func convertToLevel() -> Level {
        var pegs: [Peg] = []
        for pegPersistance in pegPersistances {
            pegs.append(Peg(id: pegPersistance.id,
                            center: pegPersistance.center.convertToPoint(),
                            type: pegPersistance.type,
                            radius: pegPersistance.radius))
        }
        return Level(id: self.id, name: self.name, pegs: pegs)
    }
}
