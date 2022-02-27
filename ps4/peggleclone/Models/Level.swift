//
//  Level.swift
//  peggleclone
//
//  Created by Stuart Long on 27/1/22.
//

import Foundation

struct Level: Identifiable {
    var id: UUID
    var name: String
    var peggleObjects: [PeggleObject]
    var numOfOrangePegs = 0
    var numOfBluePegs = 0
    var numOfSpecialPegs = 0
    var numOfBlocks = 0

    init(name: String, peggleObjects: [PeggleObject]) {
        self.id = UUID()
        self.name = name
        self.peggleObjects = peggleObjects
        countDifferentPegs()
    }

    init() {
        self.id = UUID()
        self.name = "empty"
        self.peggleObjects = []
    }

    init(id: UUID, name: String, peggleObjects: [PeggleObject]) {
        self.id = id
        self.name = name
        self.peggleObjects = peggleObjects
        countDifferentPegs()
    }

    mutating func countDifferentPegs() {
        numOfOrangePegs = 0
        numOfBluePegs = 0
        numOfBlocks = 0
        numOfSpecialPegs = 0

        for peggleObject in peggleObjects {
            handleAdd(peggleObject: peggleObject)
        }
    }

    mutating func save(name: String, peggleObjects: [PeggleObject], levels: [Level]) {
        self.peggleObjects = peggleObjects
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        if !trimmedName.isEmpty {
            var nameToSave = trimmedName
            var count = 1
            while containsSameName(name: nameToSave, levels: levels) {
                nameToSave = "\(trimmedName) (\(count))"
                count += 1
            }
            self.name = nameToSave
        }
        countDifferentPegs()
    }

    private func containsSameName(name: String, levels: [Level]) -> Bool {
        for level in levels {
            if level.name.trimmingCharacters(in: .whitespacesAndNewlines) == name && level.id != self.id {
                return true
            }
        }
        return false
    }

    mutating func move(peggleObject: PeggleObject, newLocation: Point) {
        for peggleObj in peggleObjects where peggleObj.id == peggleObject.id {
            peggleObj.shiftTo(location: newLocation)
        }
    }

    mutating func delete(peggleObject: PeggleObject) {
        if let index = peggleObjects.firstIndex(of: peggleObject) {
            peggleObjects.remove(at: index)
            handleDelete(peggleObject: peggleObject)
        }
    }

    mutating func handleDelete(peggleObject: PeggleObject) {
        if peggleObject is TriangleBlock {
            numOfBlocks -= 1
        } else if let peg = peggleObject as? Peg {
            if peg is SpookyPeg || peg is KaboomPeg {
                numOfSpecialPegs -= 1
            } else if peg.color == PegState.orangePeg || peg.color == PegState.orangeGlow {
                numOfOrangePegs -= 1
            } else if peg.color == PegState.bluePeg || peg.color == PegState.blueGlow {
                numOfBluePegs -= 1
            }
        }
    }

    mutating func removeAllPeggleObjects() {
        peggleObjects.removeAll()
        numOfBlocks = 0
        numOfBluePegs = 0
        numOfSpecialPegs = 0
        numOfOrangePegs = 0
    }

    mutating func addPeggleObject(peggleObject: PeggleObject) {
        peggleObjects.append(peggleObject)
        handleAdd(peggleObject: peggleObject)
    }

    mutating func handleAdd(peggleObject: PeggleObject) {
        if peggleObject is TriangleBlock {
            numOfBlocks += 1
        } else if let peg = peggleObject as? Peg {
            if peg is SpookyPeg || peg is KaboomPeg {
                numOfSpecialPegs += 1
            } else if peg.color == PegState.orangePeg {
                numOfOrangePegs += 1
            } else if peg.color == PegState.bluePeg {
                numOfBluePegs += 1
            }
        }
    }

    func spookCannonBall(cannonBall: Peg) {
        for peggleObj in peggleObjects where peggleObj.id == cannonBall.id {
            peggleObj.spooked()
        }
    }

    func renderExplosion(kaboomPeg: KaboomPeg) {
        for peggleObj in peggleObjects where peggleObj.id == kaboomPeg.id {
            if let kaboomPegObj = peggleObj as? KaboomPeg {
                kaboomPegObj.renderExplosion()
            }
        }
    }

    func resizeObject(peggleObject: PeggleObject, location: Point, width: Double, height: Double) {
        for peggleObj in peggleObjects where peggleObj.id == peggleObject.id {
            peggleObj.resizeObject(location: location, peggleObjects: peggleObjects, width: width, height: height)
        }
    }
}

extension Level: Equatable {
    static func == (lhs: Level, rhs: Level) -> Bool {
        lhs.id == rhs.id && lhs.name == rhs.name
    }
}
