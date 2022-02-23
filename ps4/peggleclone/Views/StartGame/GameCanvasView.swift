//
//  GameCanvasView.swift
//  peggleclone
//
//  Created by Stuart Long on 9/2/22.
//

import SwiftUI

struct GameCanvasView: View {
    @EnvironmentObject var allLevelsManager: AllLevelsManager
    @StateObject var levelManager: LevelManager
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

            ForEach(levelManager.level.pegs) { peg in
//                if let peg = peggleObject as? Peg {
                PegView(location: .constant(toCGPoint(point: peg.center)),
                        pegType: peg.type,
                        pegRadius: peg.radius)
                    .onTapGesture {
                        gameEngineManager.fireCannonBall(directionOf: toCGPoint(point: peg.center))
                    }
                    .transition(AnyTransition.opacity.animation(.easeInOut(duration: 0.2)))
                    .onAppear(perform: {
                        print("hello \(peg)")
                    })
//                }
            }

            if load {
                GeometryReader { geometry in
                    LevelLoaderView(allLevelsManager: allLevelsManager,
                                    levelManager: levelManager,
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

    func toCGPoint(point: Point) -> CGPoint {
        return CGPoint(x: point.xCoordinate, y: point.yCoordinate)
    }
}

struct GameCanvasView_Previews: PreviewProvider {
    static var previews: some View {
        GameCanvasView(levelManager: LevelManager(level: Level(name: "default", pegs: [])),
                       gameEngineManager: GameEngineManager(canvasDimension: CGRect()))
    }
}
