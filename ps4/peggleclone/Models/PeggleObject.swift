//
//  PeggleObject.swift
//  peggleclone
//
//  Created by Stuart Long on 22/2/22.
//

import Foundation

class PeggleObject {
    var id: UUID
    var center: Point

    init() {
        self.id = UUID()
        self.center = Point()
    }
}
