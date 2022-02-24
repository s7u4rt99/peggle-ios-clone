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
                                    levelManager.addPeg(center: locationOfPeg, canvasDimensions: canvasDimensions)
                                }
                            }
                    )

                ForEach(levelManager.level.pegs) { peg in
//                    if let peg = peggleObject as? Peg {
                    PegView(location: .constant(CGPoint(x: peg.center.xCoordinate, y: peg.center.yCoordinate)),
                            pegType: peg.color,
                            pegRadius: peg.radius,
                            pegShadow: peg.shadow,
                            pegShadowRadius: peg.shadowRadius)
                        .onTapGesture {
                            if keyboardResponder.currentHeight == 0 && levelManager.isDeleteSelected {
                                levelManager.delete(peg: peg)
                            }
                        }
                        .onLongPressGesture(minimumDuration: 1.5) {
                            if keyboardResponder.currentHeight == 0 {
                                levelManager.delete(peg: peg)
                            }
                        }
                        .gesture(DragGesture().onChanged({ value in
                            if keyboardResponder.currentHeight == 0 {
                                let locationOfPeg = value.location
                                levelManager.dragPeg(peg: peg,
                                                   newLocation: locationOfPeg,
                                                   canvasDimensions: canvasDimensions)
                            }
                        }))
                        .offset(y: -keyboardResponder.currentHeight * 0.9)
//                    }
                }
            }
        }
    }
}

struct LevelCanvas_Previews: PreviewProvider {
    static var previews: some View {
        LevelDesignerCanvasView(keyboardResponder: KeyboardResponder())
    }
}
