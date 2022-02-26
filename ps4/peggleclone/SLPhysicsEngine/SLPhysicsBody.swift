//
//  SLPhysicsObject.swift
//  peggleclone
//
//  Created by Stuart Long on 9/2/22.
//

import Foundation
import SwiftUI

protocol SLPhysicsBody {
    var mass: Double { get }
    var velocity: Vector { get set }
    var position: Point { get set }
    var gravity: Vector { get set }
    var isDynamic: Bool { get set }
    var forces: [Vector] { get set }
    var collisionsWith: [SLPhysicsBody] { get set }
    var height: Double { get set }
    var width: Double { get set }
    var hasCollided: Bool { get set }
    var canIgnore: Bool { get set }
    var previousPosition: Point { get set }

    func moveTo(position: Point)

    func setVelocity(newVelocity: Vector)

    func intersectWith(physicsBody: SLPhysicsBody) -> Bool

    func resolveForces()

    func setNotDynamic()

    func setCollided()

    func ignore()

    func moveBackBy(distance: Double)

    func setDynamic()

    func addCollisionWith(physicsBody: SLPhysicsBody)

    func clearCollisionsWith()

    func addForceToVelocity(force: Vector)
}
