//
//  GameEngineManager.swift
//  peggleclone
//
//  Created by Stuart Long on 11/2/22.
//

import Foundation
import SwiftUI

class GameEngineManager: ObservableObject {
    @Published var isGameWon: Bool
    @Published var isGameLost: Bool
    @Published var points: Int = 0
    private var gameEngine: SLGameEngine

    init(canvasDimension: CGRect) {
        gameEngine = SLGameEngine(canvasDimensions: canvasDimension)
        self.isGameWon = false
        self.isGameLost = false
    }

    func loadLevel(levelManager: LevelManager) {
        gameEngine.loadLevel(gameDisplayDelegate: levelManager,
                             gameLogicDelegate: self,
                             level: levelManager.level,
                             bucket: levelManager.bucket)
    }

    func start() {
        gameEngine.createDisplayLink()
    }

    func fireCannonBall(directionOf: CGPoint) {
        gameEngine.fireCannonBall(directionOf: Point(xCoordinate: directionOf.x, yCoordinate: directionOf.y))
    }

    func gameEnd() {
        gameEngine.gameEnd()
    }
}
