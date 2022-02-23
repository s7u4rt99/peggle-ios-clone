//
//  ContentView.swift
//  peggleclone
//
//  Created by Stuart Long on 24/1/22.
//

import SwiftUI

struct ContentView: View {

    @StateObject var allLevelsManager = AllLevelsManager()
    @StateObject var keyboardResponder = KeyboardResponder()
    @State var start = false
    @State var editLevels = false

    var body: some View {
        let levelManager = allLevelsManager.initialiseLevelManager()
        GeometryReader { geometry in
            ZStack {
                if !start && !editLevels {
                    PeggleHomeView(start: $start, editLevels: $editLevels)
                }

                if editLevels {
                    LevelDesignerView(levelManager: levelManager,
                                      levelName: levelManager.level.name,
                                      start: $start,
                                      editLevels: $editLevels)
                        .environmentObject(allLevelsManager)
                }

                if start {
                    GameCanvasView(levelManager: levelManager,
                                   gameEngineManager: GameEngineManager(canvasDimension: geometry.frame(in: .global)))
                        .environmentObject(allLevelsManager)
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(allLevelsManager: AllLevelsManager())
    }
}
