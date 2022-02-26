//
//  ContentView.swift
//  peggleclone
//
//  Created by Stuart Long on 24/1/22.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var allLevelsManager: AllLevelsManager
    @StateObject var levelManager: LevelManager
    @StateObject var keyboardResponder = KeyboardResponder()
    @State var gameState = GameState.menu
    @State var gameEngineManager: GameEngineManager

    var body: some View {
        ZStack {
            if gameState == GameState.menu {
                PeggleHomeView(gameState: $gameState)
            }

            if gameState == GameState.levelDesigner {
                LevelDesignerView(levelName: levelManager.level.name,
                                  gameState: $gameState,
                                  gameEngineManager: gameEngineManager)
                    .environmentObject(levelManager)
            }

            if gameState == GameState.startFromMenu ||
                gameState == GameState.startFromLevelDesigner {
                GameCanvasView(gameState: $gameState,
                               gameEngineManager: gameEngineManager)
                    .environmentObject(levelManager)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(levelManager: LevelManager(),
                    gameEngineManager: GameEngineManager(canvasDimension: .infinite))
    }
}
