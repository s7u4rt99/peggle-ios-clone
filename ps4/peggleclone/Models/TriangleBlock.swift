//
//  TriangleBlock.swift
//  peggleclone
//
//  Created by Stuart Long on 25/2/22.
//

import Foundation

class TriangleBlock: PeggleObject {
    var base: Double
    var height: Double
    var vertexOne: Point
    var vertexTwo: Point
    var vertexThree: Point

    init(center: Point, base: Double = 50, height: Double = 50) {
        self.base = base
        self.height = height
        self.vertexOne = Point(xCoordinate: center.xCoordinate,
                               yCoordinate: center.yCoordinate - height / 2)
        self.vertexTwo = Point(xCoordinate: center.xCoordinate - base / 2,
                               yCoordinate: center.yCoordinate + height / 2)
        self.vertexThree = Point(xCoordinate: center.xCoordinate + base / 2,
                                 yCoordinate: center.yCoordinate + height / 2)
        super.init(center: center)
    }

    init(id: UUID, center: Point, base: Double = 50, height: Double = 50) {
        self.base = base
        self.height = height
        self.vertexOne = Point(xCoordinate: center.xCoordinate,
                               yCoordinate: center.yCoordinate - height / 2)
        self.vertexTwo = Point(xCoordinate: center.xCoordinate - base / 2,
                               yCoordinate: center.yCoordinate + height / 2)
        self.vertexThree = Point(xCoordinate: center.xCoordinate + base / 2,
                                 yCoordinate: center.yCoordinate + height / 2)
        super.init(id: id, center: center)
    }

    override func copy() -> TriangleBlock {
        TriangleBlock(center: self.center, base: self.base, height: self.height)
    }

    override func overlap(peggleObject: PeggleObject) -> Bool {
        if let peg = peggleObject as? Peg {
            return trianglePegOverlapCheck(peg: peg)
        } else if let triangle = peggleObject as? TriangleBlock {
            return triangleTriangleOverlapCheck(triangle: triangle)
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

    private func triangleTriangleOverlapCheck(triangle: TriangleBlock) -> Bool {
        return trianglePointOverlapCheck(triangle: self, point: triangle.vertexOne)
        || trianglePointOverlapCheck(triangle: self, point: triangle.vertexTwo)
        || trianglePointOverlapCheck(triangle: self, point: triangle.vertexThree)
        || trianglePointOverlapCheck(triangle: triangle, point: self.vertexOne)
        || trianglePointOverlapCheck(triangle: triangle, point: self.vertexTwo)
        || trianglePointOverlapCheck(triangle: triangle, point: self.vertexThree)
    }

    private func trianglePointOverlapCheck(triangle: TriangleBlock, point: Point) -> Bool {
        let areaOfSelf = 0.5 * base * height // abs((x2 - x1) * (y3 - y1) - (x3 - x1) * (y2 - y1) );
        let area1 = 0.5 * abs((triangle.vertexOne.xCoordinate - point.xCoordinate)
                              * (triangle.vertexTwo.yCoordinate - point.yCoordinate)
                              - (triangle.vertexTwo.xCoordinate - point.xCoordinate)
                              * (triangle.vertexOne.yCoordinate - point.yCoordinate))
        let area2 = 0.5 * abs((triangle.vertexTwo.xCoordinate - point.xCoordinate)
                              * (triangle.vertexThree.yCoordinate - point.yCoordinate)
                              - (triangle.vertexThree.xCoordinate - point.xCoordinate)
                              * (triangle.vertexTwo.yCoordinate - point.yCoordinate))
        let area3 = 0.5 * abs((triangle.vertexThree.xCoordinate - point.xCoordinate)
                              * (triangle.vertexOne.yCoordinate - point.yCoordinate)
                              - (triangle.vertexOne.xCoordinate - point.xCoordinate)
                              * (triangle.vertexThree.yCoordinate - point.yCoordinate))
        return area1 + area2 + area3 <= areaOfSelf
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
}
