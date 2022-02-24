//
//  LevelManager.swift
//  peggleclone
//
//  Created by Stuart Long on 25/1/22.
//

import Foundation
import SwiftUI

class LevelManager: ObservableObject, Identifiable {

    @Published var level: Level
    @Published var isGameWon: Bool
    @Published var isGameLost: Bool
    @Published var bucket = Bucket(size: 150, center: Point(xCoordinate: 400, yCoordinate: 1160))
    var selectedPeg: PegColor?
    var isDeleteSelected = false
    var isTriangleBlockSelected = false

    init(level: Level) {
        self.level = level
        self.isGameWon = level.peggleObjects.isEmpty
        self.isGameLost = false
        copyPegs()
    }

    private func copyPegs() {
        var copiedPeggleObjects: [PeggleObject] = []
        for peggleObject in self.level.peggleObjects {
            copiedPeggleObjects.append(peggleObject.copy())
        }
        self.level.peggleObjects = copiedPeggleObjects
    }

    func delete(peggleObject: PeggleObject) {
        level.delete(peggleObject: peggleObject)
    }

    func deleteAll() {
        level.removeAllPeggleObjects()
    }

    func select(peg: PegColor) {
        selectedPeg = peg
        unselectDelete()
        unselectTriangle()
    }

    func selectDelete() {
        isDeleteSelected = true
        unselectPeg()
        unselectTriangle()
    }

    func selectTriangle() {
        isTriangleBlockSelected = true
        unselectPeg()
        unselectDelete()
    }

    func addSelected(center: CGPoint, canvasDimensions: CGRect) {
        if let selectedPeg = selectedPeg, safeToPlacePegAt(center: center, canvasDimensions: canvasDimensions) {
            if selectedPeg == .spookyPeg {
                level.addPeggleObject(peggleObject: SpookyPeg(center:
                                                                Point(xCoordinate: center.x, yCoordinate: center.y)))
            } else if selectedPeg == .kaboomPeg {
                level.addPeggleObject(peggleObject: KaboomPeg(center:
                                                                Point(xCoordinate: center.x, yCoordinate: center.y)))
            } else {
                level.addPeggleObject(peggleObject: Peg(color: selectedPeg, center:
                                                            Point(xCoordinate: center.x, yCoordinate: center.y)))
            }
        } else if isTriangleBlockSelected, safeToPlaceTriangleAt(center: center, canvasDimensions: canvasDimensions) {
            level.addPeggleObject(peggleObject: TriangleBlock(center: Point(xCoordinate: center.x,
                                                                            yCoordinate: center.y)))
        }
    }

    // TODO: fix the overlap method to account for triangles
    func safeToPlacePegAt(center: CGPoint, canvasDimensions: CGRect) -> Bool {
        if !isWithinScreen(point: center, radius: 25, canvasDimensions: canvasDimensions) {
            return false
        }

        // arbituary peg to check if overlaps with any other pegs
        let pegObject = Peg(color: PegColor.bluePeg, center: Point(xCoordinate: center.x, yCoordinate: center.y))

        for peggleObject in level.peggleObjects {
            if peggleObject.overlap(peg: pegObject) {
                return false
            }
        }
        return true
    }

    // TODO: implement safeToPlaceTriangleAt
    private func safeToPlaceTriangleAt(center: CGPoint, canvasDimensions: CGRect) -> Bool {
        return true
    }

    private func isWithinScreen(point: CGPoint, radius: Double, canvasDimensions: CGRect) -> Bool {
        let withinScreen = point.x >= radius &&
                        point.x <= (canvasDimensions.size.width - radius) &&
                        point.y >= radius &&
                        point.y <= (canvasDimensions.size.height - radius)
        return withinScreen
    }

    // TODO: see if can use safeToPlacePegAt
    func dragPeg(peg pegToMove: Peg, newLocation: CGPoint, canvasDimensions: CGRect) {
        if safeToDragPegTo(peg: pegToMove, location: newLocation, canvasDimensions: canvasDimensions) {
            level.move(peggleObject: pegToMove,
                          newLocation: Point(xCoordinate: newLocation.x, yCoordinate: newLocation.y))
        }
    }

    func dragTriangle(triangle: TriangleBlock, newLocation: CGPoint, canvasDimensions: CGRect) {
        if safeToDragTriangleTo(triangle: triangle, location: newLocation, canvasDimensions: canvasDimensions) {
            level.move(peggleObject: triangle,
                          newLocation: Point(xCoordinate: newLocation.x, yCoordinate: newLocation.y))
        }
    }

    // TODO: implement this, see if can reuse safeToPlaceTriangleAt
    func safeToDragTriangleTo(triangle: TriangleBlock, location: CGPoint, canvasDimensions: CGRect) -> Bool {
        return true
    }

    // TODO: see if can use safeToPlacePegAt
    func safeToDragPegTo(peg pegToDrag: Peg, location: CGPoint, canvasDimensions: CGRect) -> Bool {
        if !isWithinScreen(point: location, radius: pegToDrag.radius, canvasDimensions: canvasDimensions) {
            return false
        }

        let pegObject = Peg(color: pegToDrag.color, center: Point(xCoordinate: location.x, yCoordinate: location.y))

        for peggleObject in level.peggleObjects {
            if peggleObject != pegToDrag && peggleObject.overlap(peg: pegObject) {
                return false
            }
        }
        return true
    }

    func save(name: String, allLevelsManager: AllLevelsManager) {
        allLevelsManager.save(levelToSave: self.level, newName: name)
    }

    func changeLevel(level: Level) {
        self.level = level
        self.isGameWon = level.peggleObjects.isEmpty
        self.isGameLost = false
        copyPegs()
    }

    func unselectPeg() {
        self.selectedPeg = nil
    }

    func unselectDelete() {
        self.isDeleteSelected = false
    }
    func unselectTriangle() {
        self.isTriangleBlockSelected = false
    }

    func unselectAllButtons() {
        unselectPeg()
        unselectDelete()
        unselectTriangle()
    }

    func movePeg(peg: Peg, newLocation: Point) {
        self.level.move(peggleObject: peg, newLocation: newLocation)
    }

    func moveBucket(newLocation: Point) {
        objectWillChange.send()
        bucket.shiftTo(location: newLocation)
    }
}
