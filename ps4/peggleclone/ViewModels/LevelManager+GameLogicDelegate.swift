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
        delete(peggleObject: peg)
    }

    func didAddCannonBall(cannonBall: Peg) {
        // add cannon ball at center
        level.addPeggleObject(peggleObject: cannonBall)
    }

    func gameWin() {
        self.isGameWon = true
        self.isGameLost = false
    }

    func gameLose() {
        self.isGameLost = true
        self.isGameWon = false
    }

    func spookCannonBall(cannonBall: Peg) {
        level.spookCannonBall(cannonBall: cannonBall)
    }

    func renderExplosion(kaboomPeg: KaboomPeg) {
        level.renderExplosion(kaboomPeg: kaboomPeg)
    }

    func didAddPoints(_ points: Int) {
        self.points += points
    }

    func resetPoints() {
        self.points = 0
    }
}
