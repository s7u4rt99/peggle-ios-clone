//
//  LevelManager+GameLogicDelegate.swift
//  peggleclone
//
//  Created by Stuart Long on 23/2/22.
//

import Foundation

extension LevelManager: GameLogicDelegate {
    func didMove(peg: Peg, newLocation: Point) {
        movePeg(peg: peg, newLocation: newLocation)
    }

    func didRemove(peg: Peg) {
        delete(peg: peg)
    }

    func didAddCannonBall(cannonBall: Peg) {
        // add cannon ball at center
        level.addPeg(peg: cannonBall)
    }
}
