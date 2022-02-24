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
}

extension Level: Equatable {
    static func == (lhs: Level, rhs: Level) -> Bool {
        let isEqual = lhs.id == rhs.id && lhs.name == rhs.name && lhs.peggleObjects == rhs.peggleObjects
        return isEqual
    }
}
