//
//  StorageManager.swift
//  peggleclone
//
//  Created by Stuart Long on 29/1/22.
//

import Foundation

class StorageManager {

    static let sourceURL = FileManager()
        .urls(for: .documentDirectory, in: .userDomainMask)
        .first?.appendingPathComponent("Source.json")
    static let seedURL = Bundle.main.url(forResource: "Seed", withExtension: "json")

    static func loadLevels() -> [Level] {
        guard var url = sourceURL else {
            fatalError("Source URL is invalid")
        }

        guard let seedUrl = seedURL else {
            fatalError("Seed URL does not exist")
        }

        if !FileManager().fileExists(atPath: url.path) {
            url = seedUrl
        }

        let decoder = JSONDecoder()
        guard let data = try? Data(contentsOf: url) else {
            fatalError("Unable to decode data")
        }

        print(url)
        guard let persistanceLevels = try? decoder.decode([LevelPersistance].self, from: data) else {
            fatalError("Failed to decode JSON from data")
        }

        var levels: [Level] = []

        for persistanceLevel in persistanceLevels {
            levels.append(persistanceLevel.convertToLevel())
        }
//        print(levels)
//        for level in levels {
//            for peg in level.pegs {
//                if let peg1 = peg as? Peg {
//                    print(true)
//                print("peg \(peg.radius), \(peg.center)")
//                } else {
//                    print(false)
//                }
//            }
//        }
        return levels
    }

    static func saveLevels(levels: [Level]) {
        let encoder = JSONEncoder()

        var persistanceLevels: [LevelPersistance] = []

        for level in levels {
            persistanceLevels.append(LevelPersistance(level: level))
        }

        guard let levelJSONData = try? encoder.encode(persistanceLevels) else {
            fatalError("Could not encode data")
        }

        guard let levelJSON = String(data: levelJSONData, encoding: .utf8) else {
            fatalError("Could not convert JSON to String")
        }

        guard let sourceUrl = sourceURL else {
            fatalError("Source URL is invalid")
        }

        do {
            try levelJSON.write(to: sourceUrl, atomically: true, encoding: .utf8)
            } catch {
            print("Could not save file to directory: \(error.localizedDescription)")
        }

    }
}
