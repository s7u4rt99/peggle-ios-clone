//
//  LevelLoaderView.swift
//  peggleclone
//
//  Created by Stuart Long on 13/2/22.
//

import SwiftUI

struct LevelLoaderView: View {
    @ObservedObject var levelManager: LevelManager
    @ObservedObject var pegManager: PegManager
    @Binding var load: Bool
    var gameEngineManager: GameEngineManager

    var body: some View {
        VStack(alignment: .leading) {

            Text("Select a level to play").font(.headline)

            ForEach(levelManager.levels) { level in
                    Button() {
                        pegManager.changeLevel(level: level)
                        load = false
                        gameEngineManager.loadLevel(pegManager: pegManager)
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
        LevelLoaderView(levelManager: LevelManager(),
                        pegManager: PegManager(level: Level(name: "default", pegs: [])),
                        load: .constant(true),
                        gameEngineManager: GameEngineManager(canvasDimension: CGRect()))
    }
}
