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

    func loadLevel(levelManager: LevelManager) {
        gameEngine.loadLevel(gameLogicDelegate: levelManager, level: levelManager.level, bucket: levelManager.bucket)
    }

    func start() {
        gameEngine.createDisplayLink()
    }

    func fireCannonBall(directionOf: CGPoint) {
        gameEngine.fireCannonBall(directionOf: Point(xCoordinate: directionOf.x, yCoordinate: directionOf.y))
    }
}
