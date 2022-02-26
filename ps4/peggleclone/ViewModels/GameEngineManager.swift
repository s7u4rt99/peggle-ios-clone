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
    @Published var cannonBallAmmo = 0
    private var gameEngine: SLGameEngine
    var positionOfCannon: Point

    init(canvasDimension: CGRect) {
        self.gameEngine = SLGameEngine(canvasDimensions: canvasDimension)
        self.isGameWon = false
        self.isGameLost = false
        self.positionOfCannon = Point(xCoordinate: canvasDimension.width / 2, yCoordinate: 50)
    }

    func loadLevel(levelManager: LevelManager) {
        gameEngine.loadLevel(gameDisplayDelegate: levelManager,
                             gameLogicDelegate: self,
                             level: levelManager.level,
                             bucket: levelManager.bucket)
        cannonBallAmmo = 10
    }

    func start() {
        gameEngine.createDisplayLink()
    }

    func fireCannonBall(directionOf: CGPoint) {
        if gameEngine.fireCannonBall(directionOf: Point(xCoordinate: directionOf.x, yCoordinate: directionOf.y)) {
            cannonBallAmmo -= 1
        }
    }

    func gameEnd() {
        gameEngine.gameEnd()
        cannonBallAmmo = 0
    }
}
