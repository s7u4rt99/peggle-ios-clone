//
//  LevelSelectorView.swift
//  peggleclone
//
//  Created by Stuart Long on 27/1/22.
//

import SwiftUI

// Level Selector -> For selecting levels in the edit level mode
struct LevelSelectorView: View {

    @ObservedObject var allLevelsManager: AllLevelsManager
    @ObservedObject var levelManager: LevelManager
    @Binding var load: Bool
    @Binding var levelName: String

    var body: some View {
        VStack(alignment: .leading) {

            Text("Select a level to load").font(.headline)

            ForEach(allLevelsManager.levels) { level in
                Button() {
                    levelManager.changeLevel(level: level)
                    levelName = levelManager.level.name
                } label: {
                    Text(level.name).foregroundColor(.red).padding()
                }
            }

            Button() {
                levelManager.changeLevel(level: allLevelsManager.createNewLevel())
                levelName = levelManager.level.name
                load.toggle()
            } label: {
                Text("+ New Level")
            }

        }.padding()
            .background(.white)
            .cornerRadius(15)
    }
}

struct LevelSelector_Previews: PreviewProvider {
    static var previews: some View {
        LevelSelectorView(allLevelsManager: AllLevelsManager(),
                          levelManager: LevelManager(level: Level(name: "default", pegs: [])),
                      load: .constant(true),
                      levelName: .constant("default"))
    }
}
