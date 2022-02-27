//
//  GameCanvasView.swift
//  peggleclone
//
//  Created by Stuart Long on 9/2/22.
//

import SwiftUI

struct GameCanvasView: View {
    @EnvironmentObject var allLevelsManager: AllLevelsManager
    @EnvironmentObject var levelManager: LevelManager
    @Binding var gameState: GameState
    @State private var rotation = 0.0
    @ObservedObject var gameEngineManager: GameEngineManager

    func buildView(peggleObject: PeggleObject) -> AnyView {
        if let peg = peggleObject as? Peg {
            return AnyView(PegView(location: .constant(toCGPoint(point: peg.center)),
                                   pegType: peg.color,
                                   pegRadius: peg.radius,
                                   pegShadow: peg.shadow,
                                   pegShadowRadius: peg.shadowRadius)
                        .onTapGesture {
                            gameEngineManager.fireCannonBall(directionOf: getFireDirection())
                        }
                        .gesture(
                            DragGesture().onChanged({ value in
                                setRotation(value.location)
                            }))
                        .transition(AnyTransition.opacity.animation(.easeInOut(duration: 0.2))))
        } else if let triangle = peggleObject as? TriangleBlock {
            return AnyView(TriangleView(location: .constant(toCGPoint(point: triangle.center)),
                                        triangleBase: triangle.base,
                                        triangleHeight: triangle.height)
                            .onTapGesture {
                                gameEngineManager.fireCannonBall(directionOf: getFireDirection())
                            }
                            .gesture(
                                DragGesture().onChanged({ value in
                                    setRotation(value.location)
                                })))
        } else {
            return AnyView(EmptyView())
        }
    }

    var body: some View {
        ZStack {
            BackgroundView()
                .gesture(
                    DragGesture().onChanged({ value in
                        setRotation(value.location)
                    }))
                .gesture(
                    DragGesture(minimumDistance: 0)
                        .onEnded { _ in
                            gameEngineManager.fireCannonBall(directionOf: getFireDirection())
                        })

            ForEach(levelManager.level.peggleObjects) { peggleObject in
                buildView(peggleObject: peggleObject)
            }
            .transition(AnyTransition.opacity.animation(.easeInOut(duration: 0.2)))

            BucketView(size: levelManager.bucket.size)
                .position(x: levelManager.bucket.center.xCoordinate, y: levelManager.bucket.center.yCoordinate)

            CannonView()
                .rotationEffect(.radians(rotation))
                .position(x: gameEngineManager.positionOfCannon.xCoordinate,
                          y: gameEngineManager.positionOfCannon.yCoordinate)

            PointsView(gameEngineManager: gameEngineManager)

            RemainingPegsView()

            CannonBallMagazineView(gameEngineManager: gameEngineManager)

            TimerView(gameEngineManager: gameEngineManager)

            if gameState == GameState.startFromMenu {
                GeometryReader { geometry in
                    LevelLoaderView(allLevelsManager: allLevelsManager,
                                    levelManager: levelManager,
                                    gameEngineManager: gameEngineManager,
                                    gameState: $gameState)
                        .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
                }.background(
                    Color.black.opacity(0.65)
                        .edgesIgnoringSafeArea(.all)
                )
            }

            Button("Exit") {
                gameState = GameState.menu
                goToHome()
            }
            .foregroundColor(gameState == GameState.startFromMenu ? .white : .black)
            .position(x: 50, y: 35)
        }
        .alert("Congratulations, you completed the level! You earned \(gameEngineManager.points) points!",
               isPresented: .constant(gameEngineManager.isGameWon)) {
            Button("Home") {
                goToHome()
            }
        }
        .alert("You lose, you ran out of cannon balls :( You earned \(gameEngineManager.points) points!",
               isPresented: .constant(gameEngineManager.isGameLost)) {
            Button("Home") {
                goToHome()
            }
        }
       .alert("Timer's up! You lose :( You earned \(gameEngineManager.points) points!",
              isPresented: .constant(gameEngineManager.isTimerUp &&
                                     !(gameEngineManager.isGameWon || gameEngineManager.isGameLost))) {
           Button("Home") {
               goToHome()
           }
       }
    }

    private func goToHome() {
        gameState = GameState.menu
        gameEngineManager.gameEnd()
        levelManager.changeLevel(level: allLevelsManager.getLevelById(levelManager.level.id))
    }

    private func toCGPoint(point: Point) -> CGPoint {
        return CGPoint(x: point.xCoordinate, y: point.yCoordinate)
    }

    private func setRotation(_ aim: CGPoint) {
        let centerHorizontalAxis = Vector(
            xDirection: 0,
            yDirection: gameEngineManager.positionOfCannon.yCoordinate * 2)
        let directionOfAim = Vector(
            xDirection: aim.x - gameEngineManager.positionOfCannon.xCoordinate,
            yDirection: aim.y - gameEngineManager.positionOfCannon.yCoordinate)
        let angleOfRotation = calculateRotation(centerHorizontalAxis,
                                                directionOfAim)
        rotation = angleOfRotation
    }

    private func calculateRotation(_ firstVector: Vector, _ secondVector: Vector) -> Double {
        let output = -atan2(
            firstVector.yDirection*secondVector.xDirection - firstVector.xDirection*secondVector.yDirection,
            firstVector.xDirection*secondVector.xDirection + firstVector.yDirection*secondVector.yDirection)
        if output > Double.pi / 2 {
            return Double.pi / 2
        } else if output < -Double.pi / 2 {
            return -Double.pi / 2
        } else {
            return output
        }
    }

    private func getFireDirection() -> CGPoint {
        let centerHorizontalAxis = Vector(
            xDirection: 0,
            yDirection: gameEngineManager.positionOfCannon.yCoordinate * 2)

        let directionOfFire = Vector(
            xDirection: centerHorizontalAxis.xDirection * cos(rotation)
            - centerHorizontalAxis.yDirection * sin(rotation),
            yDirection: centerHorizontalAxis.xDirection * sin(rotation)
            + centerHorizontalAxis.yDirection * cos(rotation))
            .multiplyWithScalar(scalar: 50)

        return toCGPoint(point: directionOfFire.movePointBy(point: gameEngineManager.positionOfCannon, distance: 250))
    }
}

struct GameCanvasView_Previews: PreviewProvider {
    static var previews: some View {
        GameCanvasView(gameState: .constant(GameState.startFromMenu),
                       gameEngineManager: GameEngineManager(canvasDimension: CGRect()))
    }
}
