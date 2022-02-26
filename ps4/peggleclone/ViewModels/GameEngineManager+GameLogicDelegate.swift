//
//  GameEngineManager+GameLogicDelegate.swift
//  peggleclone
//
//  Created by Stuart Long on 27/2/22.
//

import Foundation

extension GameEngineManager: GameLogicDelegate {
    func gameWin() {
        self.isGameWon = true
        self.isGameLost = false
    }

    func gameLose() {
        self.isGameLost = true
        self.isGameWon = false
    }

    func didAddPoints(_ points: Int) {
        self.points += points
    }

    func resetPoints() {
        self.points = 0
        self.isGameWon = false
        self.isGameLost = false
    }
}
