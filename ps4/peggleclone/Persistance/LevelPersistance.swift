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
    var normalPegPersistances: [PegPersistance] = []
    var spookyPegPersistances: [SpookyPegPersitance] = []
    var kaboomPegPersistances: [KaboomPegPersistance] = []

    init(level: Level) {
        self.id = level.id
        self.name = level.name
        initialisePegPersistanceArr(level.peggleObjects)
    }

    mutating func initialisePegPersistanceArr(_ peggleObjects: [PeggleObject]) {
        for peggleObject in peggleObjects {
            if let kaboomPeg = peggleObject as? KaboomPeg {
                kaboomPegPersistances.append(KaboomPegPersistance(kaboomPeg))
            } else if let spookyPeg = peggleObject as? SpookyPeg {
                spookyPegPersistances.append(SpookyPegPersitance(spookyPeg))
            } else if let peg = peggleObject as? Peg {
                normalPegPersistances.append(PegPersistance(peg))
            }
        }
    }

    func convertToLevel() -> Level {
        var peggleObjects: [PeggleObject] = []
        for pegPersistance in normalPegPersistances {
            peggleObjects.append(Peg(id: pegPersistance.id,
                            center: pegPersistance.center.convertToPoint(),
                            color: pegPersistance.color,
                            radius: pegPersistance.radius))
        }

        for spookyPegPersistance in spookyPegPersistances {
            peggleObjects.append(SpookyPeg(id: spookyPegPersistance.id,
                                           center: spookyPegPersistance.center.convertToPoint(),
                                           radius: spookyPegPersistance.radius))
        }

        for kaboomPegPersistance in kaboomPegPersistances {
            peggleObjects.append(KaboomPeg(id: kaboomPegPersistance.id,
                                           center: kaboomPegPersistance.center.convertToPoint(),
                                           radius: kaboomPegPersistance.radius))
        }

        return Level(id: self.id, name: self.name, peggleObjects: peggleObjects)
    }
}
