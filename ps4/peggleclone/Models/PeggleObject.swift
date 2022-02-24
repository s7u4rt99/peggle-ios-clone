//
//  PeggleObject.swift
//  peggleclone
//
//  Created by Stuart Long on 22/2/22.
//

import Foundation

class PeggleObject: Identifiable {
    var id: UUID
    var center: Point

    init(center: Point) {
        self.id = UUID()
        self.center = center
    }

    init(id: UUID, center: Point) {
        self.id = id
        self.center = center
    }

    func shiftTo(location: Point) {
        self.center = location
    }

    func copy() -> PeggleObject {
        PeggleObject(center: self.center)
    }

    func overlap(peg: Peg) -> Bool {
        fatalError("This method must be overridden")
    }
}

extension PeggleObject: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension PeggleObject: Equatable {
    static func == (lhs: PeggleObject, rhs: PeggleObject) -> Bool {
        lhs.id == rhs.id
    }
}
