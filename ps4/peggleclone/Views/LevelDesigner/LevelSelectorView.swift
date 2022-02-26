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
    @State private var contentSize: CGSize = .zero

    var body: some View {
        VStack(alignment: .leading) {

            Text("Select a level to load").font(.headline)
            ScrollView {
                VStack {
                    ForEach(allLevelsManager.levels) { level in
                        Button() {
                            levelManager.changeLevel(level: level)
                            levelName = levelManager.level.name
                            load.toggle()
                        } label: {
                            if levelManager.level == level {
                                Text(level.name).foregroundColor(.orange).padding()
                            } else {
                                Text(level.name).foregroundColor(.red).padding()
                            }
                        }
                    }

                    Button() {
                        levelManager.changeLevel(level: allLevelsManager.createNewLevel())
                        levelName = levelManager.level.name
                        load.toggle()
                    } label: {
                        Text("+ New Level")
                    }
                }.overlay(
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

struct LevelSelector_Previews: PreviewProvider {
    static var previews: some View {
        LevelSelectorView(allLevelsManager: AllLevelsManager(),
                          levelManager: LevelManager(level: Level(name: "default", peggleObjects: []),
                                                     canvasDimension: .zero),
                          load: .constant(true),
                          levelName: .constant("default"))
    }
}
