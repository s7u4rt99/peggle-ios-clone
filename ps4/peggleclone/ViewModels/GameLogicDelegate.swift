//
//  GameLogicDelegate.swift
//  peggleclone
//
//  Created by Stuart Long on 23/2/22.
//

import Foundation

protocol GameLogicDelegate: AnyObject {
    func didMove(peg: Peg, newLocation: Point)
    func didRemove(peg: Peg)
    func didAddCannonBall(cannonBall: Peg)
}
