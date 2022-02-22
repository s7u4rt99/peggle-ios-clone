//
//  ContentView.swift
//  peggleclone
//
//  Created by Stuart Long on 24/1/22.
//

import SwiftUI

struct ContentView: View {

    @StateObject var levelManager = LevelManager()
    @StateObject var keyboardResponder = KeyboardResponder()
    @State var start = false
    @State var editLevels = false

    var body: some View {
        let pegManager = levelManager.initialisePegManager()
        GeometryReader { geometry in
            ZStack {
                if !start && !editLevels {
                    PeggleHomeView(start: $start, editLevels: $editLevels)
                }

                if start {
                    GameCanvasView(pegManager: pegManager,
                                   gameEngineManager: GameEngineManager(canvasDimension: geometry.frame(in: .global)))
                        .environmentObject(levelManager)
                }

                if editLevels {
                    LevelDesignerView(pegManager: pegManager,
                                      levelName: pegManager.level.name)
                        .environmentObject(levelManager)
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(levelManager: LevelManager())
    }
}
