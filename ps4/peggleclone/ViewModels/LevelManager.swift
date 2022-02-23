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
    var selectedPeg: PegType?
    var isDeleteSelected = false

    init(level: Level) {
        self.level = level
        copyPegs()
    }

    private func copyPegs() {
        var copiedPegs: [Peg] = []
        for peg in self.level.pegs {
            copiedPegs.append(peg.copy())
        }
        self.level.pegs = copiedPegs
    }

    func delete(peg: Peg) {
        level.deletePeg(peg: peg)
    }

    func deleteAll() {
        level.removeAllPegs()
    }

    func select(peg: PegType) {
        selectedPeg = peg
        isDeleteSelected = false
    }

    func selectDelete() {
        selectedPeg = nil
        isDeleteSelected = true
    }

    func addPeg(center: CGPoint, canvasDimensions: CGRect) {
        if let selectedPeg = selectedPeg, safeToPlacePegAt(center: center, canvasDimensions: canvasDimensions) {
            level.addPeg(peg: Peg(type: selectedPeg, center: Point(xCoordinate: center.x, yCoordinate: center.y)))
        }
    }

    func safeToPlacePegAt(center: CGPoint, canvasDimensions: CGRect) -> Bool {
        if !isWithinScreen(point: center, radius: 25, canvasDimensions: canvasDimensions) {
            return false
        }

        // arbituary peg to check if overlaps with any other pegs
        let pegObject = Peg(type: PegType.bluePeg, center: Point(xCoordinate: center.x, yCoordinate: center.y))

        for peg in level.pegs {
            if peg.overlap(peg: pegObject) {
                return false
            }
        }
        return true
    }

    private func isWithinScreen(point: CGPoint, radius: Double, canvasDimensions: CGRect) -> Bool {
        let withinScreen = point.x >= radius &&
                        point.x <= (canvasDimensions.size.width - radius) &&
                        point.y >= radius &&
                        point.y <= (canvasDimensions.size.height - radius)
        return withinScreen
    }

    func dragPeg(peg pegToMove: Peg, newLocation: CGPoint, canvasDimensions: CGRect) {
        if safeToDragPegTo(peg: pegToMove, location: newLocation, canvasDimensions: canvasDimensions) {
            level.movePeg(peg: pegToMove,
                          newLocation: Point(xCoordinate: newLocation.x, yCoordinate: newLocation.y))
        }
    }

    func safeToDragPegTo(peg pegToDrag: Peg, location: CGPoint, canvasDimensions: CGRect) -> Bool {
        if !isWithinScreen(point: location, radius: pegToDrag.radius, canvasDimensions: canvasDimensions) {
            return false
        }

        let pegObject = Peg(type: pegToDrag.type, center: Point(xCoordinate: location.x, yCoordinate: location.y))

        for peg in level.pegs {
            if peg != pegToDrag && peg.overlap(peg: pegObject) {
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
        copyPegs()
    }

    func unselectPeg() {
        self.selectedPeg = nil
    }

    func unselectDelete() {
        self.isDeleteSelected = false
    }

    func unselectAllButtons() {
        unselectPeg()
        unselectDelete()
    }

    func movePeg(peg: Peg, newLocation: Point) {
        self.level.movePeg(peg: peg, newLocation: newLocation)
    }

    func addCannonBall(cannonBall: Peg) {
        // add cannon ball at center
        level.addPeg(peg: cannonBall)
    }
}
