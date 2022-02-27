//
//  TriangleBlock.swift
//  peggleclone
//
//  Created by Stuart Long on 25/2/22.
//

import Foundation

class TriangleBlock: PeggleObject {
    static var triangleHeightMinRatio = 0.06
    static var triangleBaseMinRatio = 0.06
    // TODO: review the max height and base
    var triangleBaseMin: Double
    var triangleHeightMin: Double
    var triangleHeightMax: Double
    var triangleBaseMax: Double
    var base: Double
    var height: Double
    var vertexOne: Point
    var vertexTwo: Point
    var vertexThree: Point

    init(center: Point, base: Double, height: Double) {
        self.base = base
        self.height = height
        self.vertexOne = Point(xCoordinate: center.xCoordinate,
                               yCoordinate: center.yCoordinate - height / 2)
        self.vertexTwo = Point(xCoordinate: center.xCoordinate - base / 2,
                               yCoordinate: center.yCoordinate + height / 2)
        self.vertexThree = Point(xCoordinate: center.xCoordinate + base / 2,
                                 yCoordinate: center.yCoordinate + height / 2)
        self.triangleBaseMin = base
        self.triangleHeightMin = height
        self.triangleBaseMax = base * 2
        self.triangleHeightMax = height * 2
        super.init(center: center)
    }

    init(center: Point, base: Double, height: Double, minBase: Double,
        maxBase: Double, minHeight: Double, maxHeight: Double) {
        self.base = base
        self.height = height
        self.vertexOne = Point(xCoordinate: center.xCoordinate,
                               yCoordinate: center.yCoordinate - height / 2)
        self.vertexTwo = Point(xCoordinate: center.xCoordinate - base / 2,
                               yCoordinate: center.yCoordinate + height / 2)
        self.vertexThree = Point(xCoordinate: center.xCoordinate + base / 2,
                                 yCoordinate: center.yCoordinate + height / 2)
        self.triangleBaseMin = minBase
        self.triangleHeightMin = minHeight
        self.triangleBaseMax = maxBase
        self.triangleHeightMax = maxHeight
        super.init(center: center)
    }

    init(id: UUID, center: Point, base: Double, height: Double) {
        self.base = base
        self.height = height
        self.vertexOne = Point(xCoordinate: center.xCoordinate,
                               yCoordinate: center.yCoordinate - height / 2)
        self.vertexTwo = Point(xCoordinate: center.xCoordinate - base / 2,
                               yCoordinate: center.yCoordinate + height / 2)
        self.vertexThree = Point(xCoordinate: center.xCoordinate + base / 2,
                                 yCoordinate: center.yCoordinate + height / 2)
        self.triangleBaseMin = base
        self.triangleHeightMin = height
        self.triangleBaseMax = base * 2
        self.triangleHeightMax = height * 2
        super.init(id: id, center: center)
    }

    init(id: UUID, center: Point, base: Double, height: Double,
         minBase: Double, maxBase: Double, minHeight: Double, maxHeight: Double) {
        self.base = base
        self.height = height
        self.vertexOne = Point(xCoordinate: center.xCoordinate,
                               yCoordinate: center.yCoordinate - height / 2)
        self.vertexTwo = Point(xCoordinate: center.xCoordinate - base / 2,
                               yCoordinate: center.yCoordinate + height / 2)
        self.vertexThree = Point(xCoordinate: center.xCoordinate + base / 2,
                                 yCoordinate: center.yCoordinate + height / 2)
        self.triangleBaseMin = minBase
        self.triangleHeightMin = minHeight
        self.triangleBaseMax = maxBase
        self.triangleHeightMax = maxHeight
        super.init(id: id, center: center)
    }

    override func copy() -> TriangleBlock {
        TriangleBlock(center: self.center, base: self.base, height: self.height,
                      minBase: self.triangleBaseMin, maxBase: self.triangleBaseMax,
                      minHeight: self.triangleHeightMin, maxHeight: self.triangleHeightMax)
    }

    override func overlap(peggleObject: PeggleObject) -> Bool {
        if let peg = peggleObject as? Peg {
            return trianglePegOverlapCheck(peg: peg)
        } else if let triangle = peggleObject as? TriangleBlock {
//            print("self \(self.base) \(self.height)")
//            print("triangle \(triangle.base) \(triangle.height)")
//            return triangleTriangleOverlapCheck(triangle: triangle)
            return trianglesIntersect(self, triangle)
        } else {
            return false
        }
    }

    override func shiftTo(location: Point) {
        self.center = location
        self.vertexOne = Point(xCoordinate: center.xCoordinate,
                               yCoordinate: center.yCoordinate - height / 2)
        self.vertexTwo = Point(xCoordinate: center.xCoordinate - base / 2,
                               yCoordinate: center.yCoordinate + height / 2)
        self.vertexThree = Point(xCoordinate: center.xCoordinate + base / 2,
                                 yCoordinate: center.yCoordinate + height / 2)
    }

    func cross(_ triangleOne: TriangleBlock, _ triangleTwo: TriangleBlock) -> Bool {
        let pointA = triangleOne.vertexOne
        let pointB = triangleOne.vertexTwo
        let pointC = triangleOne.vertexThree
        let pointX = triangleTwo.vertexOne
        let pointY = triangleTwo.vertexTwo
        let pointZ = triangleTwo.vertexThree
        let xDistAZ = pointA.xCoordinate - pointZ.xCoordinate
        let yDistAZ = pointA.yCoordinate - pointZ.yCoordinate
        let xDistBZ = pointB.xCoordinate - pointZ.xCoordinate
        let yDistBZ = pointB.yCoordinate - pointZ.yCoordinate
        let xDistCZ = pointC.xCoordinate - pointZ.xCoordinate
        let yDistCZ = pointC.yCoordinate - pointZ.yCoordinate
        let xDistZY = pointZ.xCoordinate - pointY.xCoordinate
        let yDistYZ = pointY.yCoordinate - pointZ.yCoordinate
        let temp = yDistYZ * (pointX.xCoordinate - pointZ.xCoordinate)
                + xDistZY * (pointX.yCoordinate - pointZ.yCoordinate)
        let sizeA = yDistYZ * xDistAZ + xDistZY * yDistAZ
        let sizeB = yDistYZ * xDistBZ + xDistZY * yDistBZ
        let sizeC = yDistYZ * xDistCZ + xDistZY * yDistCZ
        let tempA = (pointZ.yCoordinate - pointX.yCoordinate) * xDistAZ
                + (pointX.xCoordinate - pointZ.xCoordinate) * yDistAZ
        let tempB = (pointZ.yCoordinate - pointX.yCoordinate) * xDistBZ
                + (pointX.xCoordinate - pointZ.xCoordinate) * yDistBZ
        let tempC = (pointZ.yCoordinate - pointX.yCoordinate) * xDistCZ
                + (pointX.xCoordinate - pointZ.xCoordinate) * yDistCZ
        if temp < 0 {
            return ((sizeA >= 0 && sizeB >= 0 && sizeC >= 0) ||
                         (tempA >= 0 && tempB >= 0 && tempC >= 0) ||
                         (sizeA+tempA <= temp && sizeB+tempB <= temp && sizeC+tempC <= temp))
        }
        return ((sizeA <= 0 && sizeB <= 0 && sizeC <= 0) ||
              (tempA <= 0 && tempB <= 0 && tempC <= 0) ||
              (sizeA+tempA >= temp && sizeB+tempB >= temp && sizeC+tempC >= temp))
    }

    func trianglesIntersect(_ triangleOne: TriangleBlock, _ triangleTwo: TriangleBlock) -> Bool {
      return !(cross(triangleOne, triangleTwo) ||
               cross(triangleTwo, triangleOne))
    }

    private func vertexWithinPeg(vertex: Point, peg: Peg) -> Bool {
        let c1x = peg.center.xCoordinate - vertex.xCoordinate
        let c1y = peg.center.yCoordinate - vertex.yCoordinate
        let radiusSqr = peg.radius * peg.radius
        let c1sqr = c1x * c1x + c1y * c1y - radiusSqr

        if c1sqr <= 0 {
          return true
        }
        return false
    }

    private func pegWithinTriangle(peg: Peg) -> Bool {
        let e1x = vertexTwo.xCoordinate - vertexOne.xCoordinate
        let e1y = vertexTwo.yCoordinate - vertexOne.yCoordinate
        let c1x = peg.center.xCoordinate - vertexOne.xCoordinate
        let c1y = peg.center.yCoordinate - vertexOne.yCoordinate

        let e2x = vertexThree.xCoordinate - vertexTwo.xCoordinate
        let e2y = vertexThree.yCoordinate - vertexTwo.yCoordinate
        let c2x = peg.center.xCoordinate - vertexTwo.xCoordinate
        let c2y = peg.center.yCoordinate - vertexTwo.yCoordinate

        let e3x = vertexOne.xCoordinate - vertexThree.xCoordinate
        let e3y = vertexOne.yCoordinate - vertexThree.yCoordinate
        let c3x = peg.center.xCoordinate - vertexThree.xCoordinate
        let c3y = peg.center.yCoordinate - vertexThree.yCoordinate

        if e1y * c1x - e1x * c1y >= 0
            && e2y * c2x - e2x * c2y >= 0
            && e3y * c3x - e3x * c3y >= 0 {
             return true
        }

        return false
    }

    private func pegIntersectEdge(peg: Peg) -> Bool {
        let radiusSqr = peg.radius * peg.radius

        let e1x = vertexTwo.xCoordinate - vertexOne.xCoordinate
        let e1y = vertexTwo.yCoordinate - vertexOne.yCoordinate
        let c1x = peg.center.xCoordinate - vertexOne.xCoordinate
        let c1y = peg.center.yCoordinate - vertexOne.yCoordinate
        let c1sqr = c1x * c1x + c1y * c1y - radiusSqr

        let e2x = vertexThree.xCoordinate - vertexTwo.xCoordinate
        let e2y = vertexThree.yCoordinate - vertexTwo.yCoordinate
        let c2x = peg.center.xCoordinate - vertexTwo.xCoordinate
        let c2y = peg.center.yCoordinate - vertexTwo.yCoordinate
        let c2sqr = c2x * c2x + c2y * c2y - radiusSqr

        let e3x = vertexOne.xCoordinate - vertexThree.xCoordinate
        let e3y = vertexOne.yCoordinate - vertexThree.yCoordinate
        let c3x = peg.center.xCoordinate - vertexThree.xCoordinate
        let c3y = peg.center.yCoordinate - vertexThree.yCoordinate
        let c3sqr = c3x * c3x + c3y * c3y - radiusSqr

        var kValue = c1x * e1x + c1y * e1y

        if kValue > 0 {
          let len = e1x * e1x + e1y * e1y

          if kValue < len {
              if c1sqr * len <= kValue * kValue {
                  return true
              }
          }
        }

        kValue = c2x * e2x + c2y * e2y

        if kValue > 0 {
          let len = e2x * e2x + e2y * e2y

          if kValue < len {
              if c2sqr * len <= kValue * kValue {
                  return true
              }
          }
        }

        kValue = c3x * e3x + c3y * e3y

        if kValue > 0 {
          let len = e3x * e3x + e3y * e3y

          if kValue < len {
              if c3sqr * len <= kValue * kValue {
                  return true
              }
          }
        }

        return false

    }

    private func trianglePegOverlapCheck(peg: Peg) -> Bool {
        if vertexWithinPeg(vertex: vertexOne, peg: peg)
            || vertexWithinPeg(vertex: vertexTwo, peg: peg)
            || vertexWithinPeg(vertex: vertexThree, peg: peg) {
            return true
        }

        if pegWithinTriangle(peg: peg) {
            return true
        }

        if pegIntersectEdge(peg: peg) {
            return true
        }
        return false
    }

    override func resizeObject(location: Point, peggleObjects: [PeggleObject], width: Double, height: Double) {
        var distance = center.distanceFrom(point: location)
        if distance < triangleBaseMin / 2 {
            distance = triangleBaseMin / 2
        } else if distance > triangleBaseMax / 2 {
            distance = triangleBaseMax / 2
        }
        for peggleObject in peggleObjects where peggleObject.id != self.id {
            if peggleObject.overlap(peggleObject: TriangleBlock(center: self.center,
                                                                base: distance * 2,
                                                                height: distance * 2)) {
                return
            }
        }
        if withinScreen(triangle: TriangleBlock(center: self.center,
                                                base: distance * 2,
                                                height: distance * 2),
                        width: width,
                        height: height) {
            self.base = distance * 2
            self.height = distance * 2
            self.vertexOne = Point(xCoordinate: center.xCoordinate,
                                   yCoordinate: center.yCoordinate - self.height / 2)
            self.vertexTwo = Point(xCoordinate: center.xCoordinate - self.base / 2,
                                   yCoordinate: center.yCoordinate + self.height / 2)
            self.vertexThree = Point(xCoordinate: center.xCoordinate + self.base / 2,
                                     yCoordinate: center.yCoordinate + self.height / 2)
        }
    }

    private func withinScreen(triangle: TriangleBlock, width: Double, height: Double) -> Bool {
        triangle.center.xCoordinate >= triangle.base / 2
        && triangle.center.xCoordinate <= (width - triangle.base / 2)
        && triangle.center.yCoordinate >= triangle.height / 2
        && triangle.center.yCoordinate <= (height - triangle.height / 2)
    }
}
