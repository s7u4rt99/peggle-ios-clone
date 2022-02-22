//
//  LevelDesignerCanvasView.swift
//  peggleclone
//
//  Created by Stuart Long on 25/1/22.
//

import SwiftUI

struct LevelDesignerCanvasView: View {
    @EnvironmentObject var levelManager: LevelManager
    @EnvironmentObject var pegManager: PegManager
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
                                    pegManager.addPeg(center: locationOfPeg, canvasDimensions: canvasDimensions)
                                }
                            }
                    )

                ForEach(pegManager.level.pegs) { peg in
                    PegView(location: .constant(peg.center), pegType: peg.type, pegRadius: peg.radius)
                        .onTapGesture {
                            if keyboardResponder.currentHeight == 0 && pegManager.isDeleteSelected {
                                pegManager.delete(peg: peg)
                            }
                        }
                        .onLongPressGesture(minimumDuration: 1.5) {
                            if keyboardResponder.currentHeight == 0 {
                                pegManager.delete(peg: peg)
                            }
                        }
                        .gesture(DragGesture().onChanged({ value in
                            if keyboardResponder.currentHeight == 0 {
                                let locationOfPeg = value.location
                                pegManager.dragPeg(peg: peg,
                                                   newLocation: locationOfPeg,
                                                   canvasDimensions: canvasDimensions)
                            }
                        }))
                        .offset(y: -keyboardResponder.currentHeight * 0.9)
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
