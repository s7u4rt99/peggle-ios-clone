//
//  GameEngineManager.swift
//  peggleclone
//
//  Created by Stuart Long on 11/2/22.
//

import Foundation
import SwiftUI

class GameEngineManager: ObservableObject {
    private var gameEngine: SLGameEngine

    init(canvasDimension: CGRect) {
        gameEngine = SLGameEngine(canvasDimensions: canvasDimension)
    }

    func loadLevel(pegManager: PegManager) {
        gameEngine.loadLevel(pegManager: pegManager)
    }

    func start() {
        gameEngine.createDisplayLink()
    }

    func fireCannonBall(directionOf: CGPoint) {
        gameEngine.fireCannonBall(directionOf: Point(xCoordinate: directionOf.x, yCoordinate: directionOf.y))
    }
}
