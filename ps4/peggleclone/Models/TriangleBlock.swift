//
//  TriangleBlock.swift
//  peggleclone
//
//  Created by Stuart Long on 25/2/22.
//

import Foundation

class TriangleBlock: PeggleObject {
    // store vertices, center, type?
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
    //        TEST 1: Vertex within circle
            let c1x = peg.center.xCoordinate - vertexOne.xCoordinate
            let c1y = peg.center.yCoordinate - vertexOne.yCoordinate
            let radiusSqr = peg.radius * peg.radius
            let c1sqr = c1x * c1x + c1y * c1y - radiusSqr

            if c1sqr <= 0 {
              return true
            }

            let c2x = peg.center.xCoordinate - vertexTwo.xCoordinate
            let c2y = peg.center.yCoordinate - vertexTwo.yCoordinate
            let c2sqr = c2x * c2x + c2y * c2y - radiusSqr

            if c2sqr <= 0 {
              return true
            }

            let c3x = peg.center.xCoordinate - vertexThree.xCoordinate
            let c3y = peg.center.yCoordinate - vertexThree.yCoordinate

             let c3sqr = c3x * c3x + c3y * c3y - radiusSqr

            if c3sqr <= 0 {
              return true
            }
    //        ;
    //        ; TEST 2: Circle centre within triangle
    //        ;
    //
    //        ;
    //        ; Calculate edges
    //        ;
            let e1x = vertexTwo.xCoordinate - vertexOne.xCoordinate
            let e1y = vertexTwo.yCoordinate - vertexOne.yCoordinate

            let e2x = vertexThree.xCoordinate - vertexTwo.xCoordinate // v3x - v2x
            let e2y = vertexThree.yCoordinate - vertexTwo.yCoordinate // v3y - v2y

            let e3x = vertexOne.xCoordinate - vertexThree.xCoordinate // v1x - v3x
            let e3y = vertexOne.yCoordinate - vertexThree.yCoordinate // v1y - v3y
    //
    //        if signed((e1y*c1x - e1x*c1y) | (e2y*c2x - e2x*c2y) | (e3y*c3x - e3x*c3y)) >= 0 {
    //             return true
    //        }
            if e1y * c1x - e1x * c1y >= 0
                && e2y * c2x - e2x * c2y >= 0
                && e3y * c3x - e3x * c3y >= 0 {
                 return true
            }

    //        ;
    //        ; TEST 3: Circle intersects edge
    //        ;
            var kValue = c1x * e1x + c1y * e1y

            if kValue > 0 {
              let len = e1x * e1x + e1y * e1y     // ; squared len

              if kValue < len {
                  if c1sqr * len <= kValue * kValue {
                      return true
                  }
              }
            }

    //        ; Second edge
            kValue = c2x * e2x + c2y * e2y

            if kValue > 0 {
              let len = e2x * e2x + e2y * e2y

              if kValue < len {
                  if c2sqr * len <= kValue * kValue {
                      return true
                  }
              }
            }

    //        ; Third edge
            kValue = c3x * e3x + c3y * e3y

            if kValue > 0 {
              let len = e3x * e3x + e3y * e3y

              if kValue < len {
                  if c3sqr * len <= kValue * kValue {
                      return true
                  }
              }
            }

    //        ; We're done, no intersection
            return false
        } else {
        // TODO: implemenation of trinagle triangle intersect
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
}
