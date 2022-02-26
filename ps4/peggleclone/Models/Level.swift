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

    init(name: String, peggleObjects: [PeggleObject]) {
        self.id = UUID()
        self.name = name
        self.peggleObjects = peggleObjects
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
    }

    mutating func save(name: String, peggleObjects: [PeggleObject]) {
        self.peggleObjects = peggleObjects
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        if !trimmedName.isEmpty {
            self.name = trimmedName
        }
    }

    mutating func move(peggleObject: PeggleObject, newLocation: Point) {
        for peggleObj in peggleObjects where peggleObj.id == peggleObject.id {
            peggleObj.shiftTo(location: newLocation)
        }
    }

    mutating func delete(peggleObject: PeggleObject) {
        if let index = peggleObjects.firstIndex(of: peggleObject) {
            peggleObjects.remove(at: index)
        }
    }

    mutating func removeAllPeggleObjects() {
        peggleObjects.removeAll()
    }

    mutating func addPeggleObject(peggleObject: PeggleObject) {
        peggleObjects.append(peggleObject)
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

//    func scale(peggleObject: PeggleObject, scale: Double) {
//        for peggleObj in peggleObjects where peggleObj.id == peggleObject.id {
//            peggleObj.scale(scale)
//        }
//    }
    func resizeObject(peggleObject: PeggleObject, location: Point) {
        for peggleObj in peggleObjects where peggleObj.id == peggleObject.id {
            peggleObj.resizeObject(location: location, peggleObjects: peggleObjects)
        }
    }
}

extension Level: Equatable {
    static func == (lhs: Level, rhs: Level) -> Bool {
        lhs.id == rhs.id && lhs.name == rhs.name
    }
}
