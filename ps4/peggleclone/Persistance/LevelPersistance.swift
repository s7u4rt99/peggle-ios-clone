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
    var trianglePegPersistances: [TrianglePegPersistance] = []
    var width: Double
    var height: Double

    init(level: Level, width: Double, height: Double) {
        self.id = level.id
        self.name = level.name
        self.width = width
        self.height = height
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
            } else if let triangle = peggleObject as? TriangleBlock {
                trianglePegPersistances.append(TrianglePegPersistance(triangle: triangle))
            }
        }
    }

    func convertToLevel(width: Double, height: Double) -> Level {
        var peggleObjects: [PeggleObject] = []
        let widthRatio = width / self.width
        let heightRatio = height / self.height
        for pegPersistance in normalPegPersistances {
            peggleObjects.append(Peg(id: pegPersistance.id,
                            center: pegPersistance.center.convertToPoint(xScale: widthRatio, yScale: heightRatio),
                            color: pegPersistance.color,
                                     radius: pegPersistance.radius * widthRatio,
                                     minRadius: pegPersistance.minRadius * widthRatio,
                                     maxRadius: pegPersistance.maxRadius * widthRatio))
        }

        for spookyPegPersistance in spookyPegPersistances {
            peggleObjects.append(SpookyPeg(id: spookyPegPersistance.id,
                                           center: spookyPegPersistance.center
                                            .convertToPoint(xScale: widthRatio, yScale: heightRatio),
                                           radius: spookyPegPersistance.radius * widthRatio,
                                           minRadius: spookyPegPersistance.minRadius * widthRatio,
                                           maxRadius: spookyPegPersistance.maxRadius * widthRatio))
        }

        for kaboomPegPersistance in kaboomPegPersistances {
            peggleObjects.append(KaboomPeg(id: kaboomPegPersistance.id,
                                           center: kaboomPegPersistance.center
                                            .convertToPoint(xScale: widthRatio, yScale: heightRatio),
                                           radius: kaboomPegPersistance.radius * widthRatio,
                                           minRadius: kaboomPegPersistance.minRadius * widthRatio,
                                           maxRadius: kaboomPegPersistance.maxRadius * widthRatio))
        }

        for trianglePegPersistance in trianglePegPersistances {
            peggleObjects.append(TriangleBlock(id: trianglePegPersistance.id,
                                               center: trianglePegPersistance.center
                                                .convertToPoint(xScale: widthRatio, yScale: heightRatio),
                                               base: trianglePegPersistance.base * widthRatio,
                                               height: trianglePegPersistance.height * widthRatio,
                                               minBase: trianglePegPersistance.minBase * widthRatio,
                                               maxBase: trianglePegPersistance.maxBase * widthRatio,
                                               minHeight: trianglePegPersistance.minHeight * heightRatio,
                                               maxHeight: trianglePegPersistance.maxHeight * heightRatio))
        }

        return Level(id: self.id, name: self.name, peggleObjects: peggleObjects)
    }
}
