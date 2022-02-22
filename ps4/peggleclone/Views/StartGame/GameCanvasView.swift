//
//  GameCanvasView.swift
//  peggleclone
//
//  Created by Stuart Long on 9/2/22.
//

import SwiftUI

struct GameCanvasView: View {
    @EnvironmentObject var levelManager: LevelManager
    @StateObject var pegManager: PegManager
    @State private var load = true
    var gameEngineManager: GameEngineManager

    var body: some View {
        ZStack {
            BackgroundView()
                .gesture(
                    DragGesture(minimumDistance: 0)
                        .onEnded { value in
                            gameEngineManager.fireCannonBall(directionOf: value.location)
                        })

//            CannonView()

            ForEach(pegManager.level.pegs) { peg in
                PegView(location: .constant(peg.center),
                        pegType: peg.type,
                        pegRadius: peg.radius)
                    .onTapGesture {
                        gameEngineManager.fireCannonBall(directionOf: peg.center)
                    }
                    .transition(AnyTransition.opacity.animation(.easeInOut(duration: 0.2)))
            }

            if load {
                GeometryReader { geometry in
                    LevelLoaderView(levelManager: levelManager,
                                    pegManager: pegManager,
                                    load: $load,
                                    gameEngineManager: gameEngineManager)
                        .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
                }.background(
                    Color.black.opacity(0.65)
                        .edgesIgnoringSafeArea(.all)
                )
            }
        }
    }
}

struct GameCanvasView_Previews: PreviewProvider {
    static var previews: some View {
        GameCanvasView(pegManager: PegManager(level: Level(name: "default", pegs: [])),
                       gameEngineManager: GameEngineManager(canvasDimension: CGRect()))
    }
}
