//
//  LevelManager+GameLogicDelegate.swift
//  peggleclone
//
//  Created by Stuart Long on 23/2/22.
//

import Foundation

extension LevelManager: GameLogicDelegate {
    func didMove(peggleObject: PeggleObject, newLocation: Point) {
        if let peg = peggleObject as? Peg {
            movePeg(peg: peg, newLocation: newLocation)
        } else if peggleObject is Bucket {
//            print("bucket at \(newLocation)")
            moveBucket(newLocation: newLocation)
        }
    }

    func didRemove(peg: Peg) {
        delete(peg: peg)
    }

    func didAddCannonBall(cannonBall: Peg) {
        // add cannon ball at center
        level.addPeg(peg: cannonBall)
    }

    func gameWin() {
        self.isGameWon = true
        self.isGameLost = false
    }

    func gameLose() {
        self.isGameLost = true
        self.isGameWon = false
    }
}
