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

        guard let levels = try? decoder.decode([Level].self, from: data) else {
            fatalError("Failed to decode JSON from data")
        }
        print(url)

        return levels
    }

    static func saveLevels(levels: [Level]) {
        let encoder = JSONEncoder()
        guard let levelJSONData = try? encoder.encode(levels) else {
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
