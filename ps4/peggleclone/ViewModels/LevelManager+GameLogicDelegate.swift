//
//  LevelManager+GameLogicDelegate.swift
//  peggleclone
//
//  Created by Stuart Long on 23/2/22.
//

import Foundation

extension LevelManager: GameDisplayDelegate {
    func didMove(peggleObject: PeggleObject, newLocation: Point) {
        if let peg = peggleObject as? Peg {
            movePeg(peg: peg, newLocation: newLocation)
        } else if peggleObject is Bucket {
            moveBucket(newLocation: newLocation)
        }
    }

    func didRemove(peggleObject: PeggleObject) {
        delete(peggleObject: peggleObject)
    }

    func didAddCannonBall(cannonBall: Peg) {
        level.addPeggleObject(peggleObject: cannonBall)
    }

    func spookCannonBall(cannonBall: Peg) {
        level.spookCannonBall(cannonBall: cannonBall)
    }

    func renderExplosion(kaboomPeg: KaboomPeg) {
        level.renderExplosion(kaboomPeg: kaboomPeg)
    }

    func didAdd(peggleObject: PeggleObject) {
        level.addPeggleObject(peggleObject: peggleObject)
    }
}
