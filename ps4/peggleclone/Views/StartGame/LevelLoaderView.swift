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
    @Binding var load: Bool
    var gameEngineManager: GameEngineManager

    var body: some View {
        VStack(alignment: .leading) {

            Text("Select a level to play").font(.headline)

            ForEach(allLevelsManager.levels) { level in
                    Button() {
                        levelManager.changeLevel(level: level)
                        load = false
                        gameEngineManager.loadLevel(levelManager: levelManager)
                        gameEngineManager.start()
                    } label: {
                        Text(level.name).foregroundColor(.red).padding()
                    }
            }
        }.padding()
            .background(.white)
            .cornerRadius(15)
    }
}

struct LevelLoaderView_Previews: PreviewProvider {
    static var previews: some View {
        LevelLoaderView(allLevelsManager: AllLevelsManager(),
                        levelManager: LevelManager(level: Level(name: "default", peggleObjects: [])),
                        load: .constant(true),
                        gameEngineManager: GameEngineManager(canvasDimension: CGRect()))
    }
}
