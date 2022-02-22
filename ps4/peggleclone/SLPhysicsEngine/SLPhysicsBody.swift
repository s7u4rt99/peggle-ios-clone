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
    var velocity: CGVector { get set }
    var position: CGPoint { get set }
    var gravity: CGVector { get set }
    var isDynamic: Bool { get set }
    var forces: [CGVector] { get set }
    var collisionsWith: [SLPhysicsBody] { get set }
    var height: Double { get set }
    var width: Double { get set }
    var hasCollided: Bool { get set }
    var canIgnore: Bool { get set }

    func moveTo(position: CGPoint)

    func setVelocity(newVelocity: CGVector)

    func intersectWithCircle(circleBody: SLPhysicsBody) -> Bool

    func resolveForces()

    func setNotDynamic()

    func setCollided()

    func ignore()

    func moveBackBy(distance: Double)

    func setDynamic()

    func addCollisionWith(physicsBody: SLPhysicsBody)

    func clearCollisionsWith()
}
