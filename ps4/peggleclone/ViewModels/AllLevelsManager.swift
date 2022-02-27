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
    private var defaultLevels: [String] = ["Default level 1", "Default level 2", "Default level 3"]
    private var defaultLevelsId: [UUID] = []

    init() {
        self.levels = []
    }

    func saveToFile(canvasDimensions: CGRect) {
        StorageManager.saveLevels(levels: levels, canvasDimensions: canvasDimensions)
    }

    func createNewLevel() -> Level {
        let newLevel = Level(name: "NEW LEVEL \(levels.count + 1)", peggleObjects: [])
        levels.append(newLevel)
        return newLevel
    }

    func save(levelToSave: Level, newName: String, canvasDimensions: CGRect) {
        for index in 0..<levels.count where levels[index].id == levelToSave.id {
            if defaultLevelsId.contains(levels[index].id) {
                createNewLevel()
                levels[levels.count - 1].save(name: newName, peggleObjects: levelToSave.peggleObjects, levels: levels)
            } else {
                levels[index].save(name: newName, peggleObjects: levelToSave.peggleObjects, levels: levels)
            }
        }
        saveToFile(canvasDimensions: canvasDimensions)
    }

    func initialiseLevelManager(canvasDimension: CGRect) -> LevelManager {
        self.levels = StorageManager.loadLevels(canvasDimensions: canvasDimension)
        for level in levels {
            if defaultLevels.contains(level.name) {
                defaultLevelsId.append(level.id)
            }
        }

        if levels.isEmpty {
            return LevelManager(level: createNewLevel(), canvasDimension: canvasDimension)
        }
        return LevelManager(level: levels[0], canvasDimension: canvasDimension)
    }

    func getLevelById(_ id: UUID) -> Level {
        for level in levels where level.id == id {
            return level
        }
        return levels[0]
    }
}
