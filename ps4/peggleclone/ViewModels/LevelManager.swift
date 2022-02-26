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
    @Published var bucket: Bucket
    var selectedPeg: PegState?
    var isDeleteSelected = false
    var isTriangleBlockSelected = false
    var canvasDimension: CGRect

    init() {
        self.level = Level()
        self.canvasDimension = .zero
        self.bucket = Bucket(size: 150, center: Point(xCoordinate: 400,
                                                      yCoordinate: 50))
    }

    init(level: Level, canvasDimension: CGRect) {
        self.level = level
        self.canvasDimension = canvasDimension
        self.bucket = Bucket(size: 150, center: Point(xCoordinate: canvasDimension.width / 2,
                                                      yCoordinate: canvasDimension.height))
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

    func select(peg: PegState) {
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
        if let selectedPeg = selectedPeg, safeToPlaceObjectAt(center: center, canvasDimensions: canvasDimensions) {
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
        } else if isTriangleBlockSelected, safeToPlaceObjectAt(center: center, canvasDimensions: canvasDimensions) {
            level.addPeggleObject(peggleObject: TriangleBlock(center: Point(xCoordinate: center.x,
                                                                            yCoordinate: center.y)))
        }
    }

    private func safeToPlaceObjectAt(center: CGPoint, canvasDimensions: CGRect) -> Bool {
        if !isWithinScreen(point: center, radius: Peg.pegMinRadius, canvasDimensions: canvasDimensions) {
            return false
        }

        // arbituary peg to check if overlaps with any other pegs
        var object: PeggleObject?

        if let pegObject = selectedPeg {
            object = Peg(color: pegObject, center: Point(xCoordinate: center.x, yCoordinate: center.y))
        } else if isTriangleBlockSelected {
            object = TriangleBlock(center: Point(xCoordinate: center.x, yCoordinate: center.y))
        }

        guard let object = object else {
            return true
        }

        for peggleObject in level.peggleObjects {
            if peggleObject.overlap(peggleObject: object) {
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

    func dragObject(peggleObject: PeggleObject, newLocation: CGPoint, canvasDimensions: CGRect) {
        if safeToDragObjectTo(peggleObject: peggleObject, location: newLocation, canvasDimensions: canvasDimensions) {
            level.move(peggleObject: peggleObject,
                       newLocation: Point(xCoordinate: newLocation.x, yCoordinate: newLocation.y))
        }
    }

    private func safeToDragObjectTo(peggleObject: PeggleObject, location: CGPoint, canvasDimensions: CGRect) -> Bool {
        let peggleCenter = peggleObject.center
        var peggleObj: PeggleObject?

        if let peg = peggleObject as? Peg {
            if !isWithinScreen(point: location, radius: peg.radius, canvasDimensions: canvasDimensions) {
                return false
            }

            peggleObj = Peg(color: peg.color,
                            center: Point(xCoordinate: location.x, yCoordinate: location.y),
                            radius: peg.radius)
        } else if let triangle = peggleObject as? TriangleBlock {
            if !isWithinScreen(point: location, radius: triangle.base, canvasDimensions: canvasDimensions) {
                return false
            }

            peggleObj = TriangleBlock(center: Point(xCoordinate: location.x, yCoordinate: location.y),
                                      base: triangle.base,
                                      height: triangle.height)
        }

        guard let peggleObj = peggleObj else {
            return true
        }

        for peggleObject in level.peggleObjects {
            if peggleObject.center != peggleCenter && peggleObject.overlap(peggleObject: peggleObj) {
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
//
//    func scale(peggleObject: PeggleObject, scale: Double) {
//        objectWillChange.send()
//        level.scale(peggleObject: peggleObject, scale: scale)
//    }
    func resizeObject(peggleObject: PeggleObject, location: CGPoint) {
        let point = Point(xCoordinate: location.x, yCoordinate: location.y)
        objectWillChange.send()
        level.resizeObject(peggleObject: peggleObject, location: point)
    }
}
