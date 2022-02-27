//
//  LevelDesignerView.swift
//  peggleclone
//
//  Created by Stuart Long on 30/1/22.
//

import SwiftUI

struct LevelDesignerView: View {
    @EnvironmentObject var allLevelsManager: AllLevelsManager
    @EnvironmentObject var levelManager: LevelManager
    @StateObject var keyboardResponder = KeyboardResponder()
    @State var levelName: String
    @State private var load = true
    @State var isResize = false
    @Binding var gameState: GameState
    @ObservedObject var gameEngineManager: GameEngineManager

    var body: some View {
        ZStack {
            VStack {
                LevelDesignerCanvasView(keyboardResponder: keyboardResponder, isResize: $isResize)
                PegsRowView(keyboardResponder: keyboardResponder)
                ButtonsRowView(load: $load,
                               levelName: $levelName,
                               gameState: $gameState,
                               isResize: $isResize,
                               gameEngineManager: gameEngineManager)
            }

            NumberOfPegsView()

            if load {
                GeometryReader { geometry in
                    LevelSelectorView(allLevelsManager: allLevelsManager,
                                      levelManager: levelManager,
                                      load: $load,
                                      levelName: $levelName)
                        .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
                }.background(
                    Color.black.opacity(0.65)
                        .edgesIgnoringSafeArea(.all)
                        .onTapGesture {
                            withAnimation {
                                load.toggle()
                            }
                        }
                )
            }

            Button("Exit") {
                gameState = GameState.menu
            }
            .foregroundColor(load ? .white: .black)
            .position(x: 50, y: 35)
        }
        .environmentObject(levelManager)
    }
}

struct LevelDesigner_Previews: PreviewProvider {
    static var previews: some View {
        LevelDesignerView(levelName: "default",
                          gameState: .constant(GameState.levelDesigner),
                          gameEngineManager: GameEngineManager(canvasDimension: .infinite))
    }
}
