//
//  AllLevelsManager.swift
//  peggleclone
//
//  Created by Stuart Long on 27/1/22.
//

import Foundation
import SwiftUI

class AllLevelsManager: ObservableObject {

    @Published var levels: [Level]

    init() {
        self.levels = StorageManager.loadLevels()
//        self.levels = []
    }

    func saveToFile() {
        StorageManager.saveLevels(levels: levels)
    }

    func createNewLevel() -> Level {
        let newLevel = Level(name: "NEW LEVEL \(levels.count + 1)", peggleObjects: [])
        levels.append(newLevel)
        return newLevel
    }

    func save(levelToSave: Level, newName: String) {
        for index in 0..<levels.count where levels[index].id == levelToSave.id {
            levels[index].save(name: newName, peggleObjects: levelToSave.peggleObjects)
        }
        saveToFile()
    }

    func initialiseLevelManager() -> LevelManager {
        if levels.isEmpty {
            return LevelManager(level: createNewLevel())
        }
        return LevelManager(level: levels[0])
    }
}
