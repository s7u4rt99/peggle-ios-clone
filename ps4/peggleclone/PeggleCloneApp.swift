//
//  PeggleCloneApp.swift
//  peggleclone
//
//  Created by Stuart Long on 24/1/22.
//

import SwiftUI

@main
struct PeggleCloneApp: App {
    @StateObject var allLevelsManager = AllLevelsManager()

    var body: some Scene {
        WindowGroup {
            GeometryReader { geometry in
                ContentView(levelManager: allLevelsManager
                                .initialiseLevelManager(canvasDimension: geometry.frame(in: .global)),
                            gameEngineManager: GameEngineManager(canvasDimension: geometry.frame(in: .global)))
                    .environmentObject(allLevelsManager)
            }
        }
    }
}
