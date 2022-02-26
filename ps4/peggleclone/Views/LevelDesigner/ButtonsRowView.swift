//
//  ButtonsRowView.swift
//  peggleclone
//
//  Created by Stuart Long on 24/1/22.
//

import SwiftUI

struct ButtonsRowView: View {
    @EnvironmentObject var allLevelsManager: AllLevelsManager
    @EnvironmentObject var levelManager: LevelManager
    @Binding var load: Bool
    @Binding var levelName: String
    @Binding var gameState: GameState
    @Binding var isResize: Bool
    @ObservedObject var gameEngineManager: GameEngineManager

    var body: some View {
        HStack {
            Button("LOAD") {
                load.toggle()
            }
            .foregroundColor(.blue)
            .padding(.leading)

            Button("SAVE") {
                levelManager.save(name: levelName, allLevelsManager: allLevelsManager)
            }
            .foregroundColor(.blue)

            Button("RESET") {
                levelManager.deleteAll()
            }
            .foregroundColor(.blue)

            Button("RESIZE") {
                self.isResize.toggle()
            }
            .foregroundColor(isResize ? .orange: .blue)

            TextField(
                "Level Name",
                text: $levelName
            )
            .textFieldStyle(.roundedBorder)
            .padding()

            Button("START") {
                gameEngineManager.loadLevel(levelManager: levelManager)
                gameEngineManager.start()
                gameState = GameState.startFromLevelDesigner
            }
            .foregroundColor(.blue)
            .padding(.trailing)
        }
    }
}

struct ButtonsRow_Previews: PreviewProvider {

    @State var load: Bool

    static var previews: some View {
        ButtonsRowView(load: .constant(true),
                       levelName: .constant(""),
                       gameState: .constant(GameState.levelDesigner),
                       isResize: .constant(false),
                       gameEngineManager: GameEngineManager(canvasDimension: .infinite))
    }
}
