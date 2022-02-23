//
//  LevelDesignerView.swift
//  peggleclone
//
//  Created by Stuart Long on 30/1/22.
//

import SwiftUI

struct LevelDesignerView: View {
    @EnvironmentObject var allLevelsManager: AllLevelsManager
    @StateObject var levelManager: LevelManager
    @StateObject var keyboardResponder = KeyboardResponder()
    @State var levelName: String
    @State private var load = true
    @Binding var start: Bool
    @Binding var editLevels: Bool

    var body: some View {
        ZStack {
            VStack {
                LevelDesignerCanvasView(keyboardResponder: keyboardResponder)
                PegsRowView(keyboardResponder: keyboardResponder)
                ButtonsRowView(load: $load,
                               levelName: $levelName,
                               start: $start,
                               editLevels: $editLevels)
            }

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
        }
        .environmentObject(levelManager)
    }
}

struct LevelDesigner_Previews: PreviewProvider {
    static var previews: some View {
        LevelDesignerView(levelManager: LevelManager(level: Level(name: "default", pegs: [])),
                          levelName: "default",
                          start: .constant(false),
                          editLevels: .constant(true))
    }
}
