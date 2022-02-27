//
//  GameLogicDelegate.swift
//  peggleclone
//
//  Created by Stuart Long on 27/2/22.
//

import Foundation

protocol GameLogicDelegate: AnyObject {
    func gameWin()
    func gameLose()
    func timerUp()
    func didAddPoints(_ points: Int)
    func resetPoints()
    func moveTimer(_ duration: TimeInterval)
    func addCannonball()
    func hasTimerEnded() -> Bool
}
