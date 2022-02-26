//
//  LevelLoaderView.swift
//  peggleclone
//
//  Created by Stuart Long on 13/2/22.
//

import SwiftUI

struct LevelLoaderView: View {
    @ObservedObject var allLevelsManager: AllLevelsManager
    @ObservedObject var levelManager: LevelManager
    @ObservedObject var gameEngineManager: GameEngineManager
    @Binding var gameState: GameState
    @State private var contentSize: CGSize = .zero

    var body: some View {
        VStack(alignment: .leading) {

            Text("Select a level to play").font(.headline)
            ScrollView {
                ForEach(allLevelsManager.levels) { level in
                    Button() {
                        levelManager.changeLevel(level: level)
                        gameState = .startFromLevelDesigner
                        gameEngineManager.loadLevel(levelManager: levelManager)
                        gameEngineManager.start()
                    } label: {
                        if levelManager.level == level {
                            Text(level.name).foregroundColor(.orange).padding()
                        } else {
                            Text(level.name).foregroundColor(.red).padding()
                        }
                    }
                }
                .overlay(
                    GeometryReader { geo in
                        Color.clear.onAppear {
                            contentSize = geo.size
                        }
                    }
                )
            }.frame(maxHeight: contentSize.height)
        }.padding()
            .background(.white)
            .cornerRadius(15)
    }
}

struct LevelLoaderView_Previews: PreviewProvider {
    static var previews: some View {
        LevelLoaderView(allLevelsManager: AllLevelsManager(),
                        levelManager: LevelManager(level: Level(name: "default", peggleObjects: []),
                                                   canvasDimension: .zero),
                        gameEngineManager: GameEngineManager(canvasDimension: CGRect()),
                        gameState: .constant(GameState.startFromMenu))
    }
}
