//
//  LevelDesignerCanvasView.swift
//  peggleclone
//
//  Created by Stuart Long on 25/1/22.
//

import SwiftUI

struct LevelDesignerCanvasView: View {
    @EnvironmentObject var allLevelsManager: AllLevelsManager
    @EnvironmentObject var levelManager: LevelManager
    @ObservedObject var keyboardResponder: KeyboardResponder
    @State var lastScaleValue: CGFloat = 1.0
    @Binding var isResize: Bool

    private func buildView(peggleObject: PeggleObject, canvasDimensions: CGRect) -> AnyView {
        if let peg = peggleObject as? Peg {
            return AnyView(PegView(location: .constant(CGPoint(x: peg.center.xCoordinate, y: peg.center.yCoordinate)),
                                   pegType: peg.color,
                                   pegRadius: peg.radius,
                                   pegShadow: peg.shadow,
                                   pegShadowRadius: peg.shadowRadius)
                            .onTapGesture {
                                if keyboardResponder.currentHeight == 0 && levelManager.isDeleteSelected {
                                    levelManager.delete(peggleObject: peg)
                                }
                            }
                            .onLongPressGesture(minimumDuration: 1.5) {
                                if keyboardResponder.currentHeight == 0 {
                                    levelManager.delete(peggleObject: peg)
                                }
                            }
                            .gesture(DragGesture().onChanged({ value in
                                if keyboardResponder.currentHeight == 0 {
                                    if isResize {
                                        let locationOfFinger = value.location
                                        levelManager.resizeObject(peggleObject: peg, location: locationOfFinger)
                                    } else {
                                        let locationOfPeg = value.location
                                        levelManager.dragObject(peggleObject: peg,
                                                                newLocation: locationOfPeg,
                                                                canvasDimensions: canvasDimensions)
                                    }
                                }
                            }))
//                            .gesture(MagnificationGesture().onChanged { val in
//        //                                let delta = val / self.lastScaleValue
//        //                                self.lastScaleValue = val
//        //                                let newScale = self.scale * delta
//                                print("hello")
//                                print(val)
//                                levelManager.scale(peggleObject: peg, scale: val)
//                            //... anything else e.g. clamping the newScale
//                            }.onEnded { val in
//                              // without this the next gesture will be broken
//                              self.lastScaleValue = 1.0
//                            })
            )
        } else if let triangle = peggleObject as? TriangleBlock {
            return AnyView(
//                ZStack() {
                TriangleView(location: .constant(CGPoint(x: triangle.center.xCoordinate,
                                                         y: triangle.center.yCoordinate)),
                             triangleBase: triangle.base,
                             triangleHeight: triangle.height)
                            .onTapGesture {
                                if keyboardResponder.currentHeight == 0 && levelManager.isDeleteSelected {
                                    levelManager.delete(peggleObject: triangle)
                                }
                            }
                            .onLongPressGesture(minimumDuration: 1.5) {
                                if keyboardResponder.currentHeight == 0 {
                                    levelManager.delete(peggleObject: triangle)
                                }
                            }
                            .gesture(DragGesture().onChanged({ value in
                                if keyboardResponder.currentHeight == 0 {
                                    if isResize {
                                        
                                    } else {
                                        let locationOfTriangle = value.location
                                        levelManager.dragObject(peggleObject: triangle,
                                                                  newLocation: locationOfTriangle,
                                                                  canvasDimensions: canvasDimensions)
                                    }
                                }
                            }))
//                    .simultaneousGesture(MagnificationGesture().onChanged { val in
////                                let delta = val / self.lastScaleValue
////                                self.lastScaleValue = val
////                                let newScale = self.scale * delta
//                        print("hello")
//                        print(val)
//                        levelManager.scale(peggleObject: triangle, scale: val)
//                    //... anything else e.g. clamping the newScale
//                    })
//                    Circle()
//                        .fill(Color.black)
//                        .frame(width: 15, height: 15)
//                        .position(x: triangle.vertexOne.xCoordinate, y: triangle.vertexOne.yCoordinate)
//                    Circle()
//                        .fill(Color.black)
//                        .frame(width: 15, height: 15)
//                        .position(x: triangle.vertexTwo.xCoordinate, y: triangle.vertexTwo.yCoordinate)
//                    Circle()
//                        .fill(Color.black)
//                        .frame(width: 15, height: 15)
//                        .position(x: triangle.vertexThree.xCoordinate, y: triangle.vertexThree.yCoordinate)
//                }
                    )
        } else {
            return AnyView(EmptyView())
        }
    }
    var body: some View {

        GeometryReader { geometry in
            let canvasDimensions = geometry.frame(in: .global)

            ZStack {
                BackgroundView()
                    .gesture(
                        DragGesture(minimumDistance: 0)
                            .onEnded { value in
                                if keyboardResponder.currentHeight == 0 {
                                    let locationOfPeg = value.location
                                    levelManager.addSelected(center: locationOfPeg, canvasDimensions: canvasDimensions)
                                }
                            }
                    )
//                    .gesture(MagnificationGesture().onChanged { val in
////                                let delta = val / self.lastScaleValue
////                                self.lastScaleValue = val
////                                let newScale = self.scale * delta
//                        print("hello")
//                        print(val)
////                        levelManager.scale(peggleObject: triangle, scale: val)
//                    //... anything else e.g. clamping the newScale
//                    }.onEnded { val in
//                      // without this the next gesture will be broken
//                      self.lastScaleValue = 1.0
//                    })

                ForEach(levelManager.level.peggleObjects) { peggleObject in
                    buildView(peggleObject: peggleObject, canvasDimensions: canvasDimensions)
                }
                .offset(y: -keyboardResponder.currentHeight * 0.9)
            }
        }
    }
}

struct LevelCanvas_Previews: PreviewProvider {
    static var previews: some View {
        LevelDesignerCanvasView(keyboardResponder: KeyboardResponder(), isResize: .constant(false))
    }
}
