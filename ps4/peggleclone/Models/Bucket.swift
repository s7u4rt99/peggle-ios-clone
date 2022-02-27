//
//  Bucket.swift
//  peggleclone
//
//  Created by Stuart Long on 23/2/22.
//

import Foundation

class Bucket: PeggleObject {
    var size: Double

    init(size: Double, center: Point) {
        self.size = size
        super.init(center: center)
    }

    override func overlap(peggleObject: PeggleObject) -> Bool {
        return false
    }
}
