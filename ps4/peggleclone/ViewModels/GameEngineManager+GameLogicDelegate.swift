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
        self.isTimerUp = false
    }

    func gameLose() {
        self.isGameLost = true
        self.isGameWon = false
        self.isTimerUp = false
    }

    func timerUp() {
        self.isTimerUp = true
    }

    func didAddPoints(_ points: Int) {
        self.points += points
    }

    func resetPoints() {
        self.points = 0
        self.isGameWon = false
        self.isGameLost = false
    }

    func moveTimer(_ duration: TimeInterval) {
        self.timer -= duration
        if self.timer <= 0.0 {
            self.timer = 0.0
        }
    }

    func addCannonball() {
        self.cannonBallAmmo += 1
    }

    func hasTimerEnded() -> Bool {
        let result = self.timer <= 0.0
//        print(result)
        return result
    }
}
