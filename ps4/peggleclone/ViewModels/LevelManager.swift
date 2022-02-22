//
//  LevelManager.swift
//  peggleclone
//
//  Created by Stuart Long on 27/1/22.
//

import Foundation
import SwiftUI

class LevelManager: ObservableObject {

    @Published var levels: [Level]

    init() {
        self.levels = StorageManager.loadLevels()
    }

    func saveToFile() {
        StorageManager.saveLevels(levels: levels)
    }

    func createNewLevel() -> Level {
        let newLevel = Level(name: "NEW LEVEL \(levels.count + 1)", pegs: [])
        levels.append(newLevel)
        return newLevel
    }

    func save(levelToSave: Level, newName: String) {
        for index in 0..<levels.count where levels[index].id == levelToSave.id {
            levels[index].save(name: newName, pegs: levelToSave.pegs)
        }
        saveToFile()
    }

    func initialisePegManager() -> PegManager {
        if levels.isEmpty {
            return PegManager(level: createNewLevel())
        }
        return PegManager(level: levels[0])
    }
}
