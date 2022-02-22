//
//  LevelDesignerView.swift
//  peggleclone
//
//  Created by Stuart Long on 30/1/22.
//

import SwiftUI

struct LevelDesignerView: View {
    @EnvironmentObject var levelManager: LevelManager
    @StateObject var pegManager: PegManager
    @StateObject var keyboardResponder = KeyboardResponder()
    @State var levelName: String
    @State private var load = true

    var body: some View {
        ZStack {
            VStack {
                LevelDesignerCanvasView(keyboardResponder: keyboardResponder)
                PegsRowView(keyboardResponder: keyboardResponder)
                ButtonsRowView(load: $load, levelName: $levelName)
            }

            if load {
                GeometryReader { geometry in
                    LevelSelectorView(levelManager: levelManager,
                                  pegManager: pegManager,
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
        }
        .environmentObject(pegManager)
    }
}

struct LevelDesigner_Previews: PreviewProvider {
    static var previews: some View {
        LevelDesignerView(pegManager: PegManager(level: Level(name: "default", pegs: [])),
                      levelName: "default")
    }
}
