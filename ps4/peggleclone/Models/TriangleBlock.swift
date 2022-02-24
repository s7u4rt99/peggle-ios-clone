//
//  TriangleBlock.swift
//  peggleclone
//
//  Created by Stuart Long on 25/2/22.
//

import Foundation

class TriangleBlock: PeggleObject {
    // store vertices, center, type?
    var base: Double
    var height: Double

    init(center: Point, base: Double = 50, height: Double = 50) {
        self.base = base
        self.height = height
        super.init(center: center)
    }

    init(id: UUID, center: Point, base: Double = 50, height: Double = 50) {
        self.base = base
        self.height = height
        super.init(id: id, center: center)
    }

    override func copy() -> TriangleBlock {
        TriangleBlock(center: self.center, base: self.base, height: self.height)
    }

    // TODO: implement overlap
    override func overlap(peg: Peg) -> Bool {
        return false
    }
}
