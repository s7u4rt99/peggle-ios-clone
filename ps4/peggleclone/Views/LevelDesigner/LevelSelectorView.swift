//
//  LevelSelectorView.swift
//  peggleclone
//
//  Created by Stuart Long on 27/1/22.
//

import SwiftUI

// Level Selector -> For selecting levels in the edit level mode
struct LevelSelectorView: View {

    @ObservedObject var levelManager: LevelManager
    @ObservedObject var pegManager: PegManager
    @Binding var load: Bool
    @Binding var levelName: String

    var body: some View {
        VStack(alignment: .leading) {

            Text("Select a level to load").font(.headline)

            ForEach(levelManager.levels) { level in
                    Button() {
                        pegManager.changeLevel(level: level)
                        levelName = pegManager.level.name
                    } label: {
                        Text(level.name).foregroundColor(.red).padding()
                    }
            }

            Button() {
                pegManager.changeLevel(level: levelManager.createNewLevel())
                levelName = pegManager.level.name
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
        LevelSelectorView(levelManager: LevelManager(),
                      pegManager: PegManager(level: Level(name: "default", pegs: [])),
                      load: .constant(true),
                      levelName: .constant("default"))
    }
}
