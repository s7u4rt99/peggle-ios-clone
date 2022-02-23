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
    var pegs: [Peg]

    init(name: String, pegs: [Peg]) {
        self.id = UUID()
        self.name = name
        self.pegs = pegs
    }

    init(id: UUID, name: String, pegs: [Peg]) {
        self.id = id
        self.name = name
        self.pegs = pegs
    }

    mutating func save(name: String, pegs: [Peg]) {
        self.pegs = pegs
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        if !trimmedName.isEmpty {
            self.name = trimmedName
        }
    }

    mutating func movePeg(peg: Peg, newLocation: Point) {
        for pegObject in pegs where pegObject.id == peg.id {
            pegObject.shiftTo(location: newLocation)
        }
    }

    mutating func deletePeg(peg: Peg) {
        if let index = pegs.firstIndex(of: peg) {
            pegs.remove(at: index)
        }
    }

    mutating func removeAllPegs() {
        pegs.removeAll()
    }

    mutating func addPeg(peg: Peg) {
        pegs.append(peg)
    }
}

extension Level: Equatable {
    static func == (lhs: Level, rhs: Level) -> Bool {
        let isEqual = lhs.id == rhs.id && lhs.name == rhs.name && lhs.pegs == rhs.pegs
        return isEqual
    }
}
