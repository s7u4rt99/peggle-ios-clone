//
//  GameLogicDelegate.swift
//  peggleclone
//
//  Created by Stuart Long on 23/2/22.
//

import Foundation

protocol GameDisplayDelegate: AnyObject {
    func didMove(peggleObject: PeggleObject, newLocation: Point)
    func didRemove(peggleObject: PeggleObject)
    func didAddCannonBall(cannonBall: Peg)
    func spookCannonBall(cannonBall: Peg)
    func renderExplosion(kaboomPeg: KaboomPeg)
    func didAdd(peggleObject: PeggleObject)
}
