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
    func didAddPoints(_ points: Int)
    func resetPoints()
}
