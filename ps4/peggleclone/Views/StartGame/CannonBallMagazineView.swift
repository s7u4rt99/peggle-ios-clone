//
//  CannonBallMagazineView.swift
//  peggleclone
//
//  Created by Stuart Long on 27/2/22.
//

import SwiftUI

struct CannonBallMagazineView: View {
    @EnvironmentObject var levelManager: LevelManager
    @ObservedObject var gameEngineManager: GameEngineManager

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                ForEach(0..<min(gameEngineManager.cannonBallAmmo, 5), id: \.self) { _ in
                    Image("ball")
                        .resizable()
                        .frame(width: levelManager.canvasDimension.width / 15,
                               height: levelManager.canvasDimension.width / 15)
                        .opacity(0.5)
                }
            }

            HStack {
                ForEach(0..<max(0, gameEngineManager.cannonBallAmmo - 5), id: \.self) { _ in
                    Image("ball")
                        .resizable()
                        .frame(width: levelManager.canvasDimension.width / 15,
                               height: levelManager.canvasDimension.width / 15)
                        .opacity(0.5)
                }
            }
        }
        .position(x: levelManager.canvasDimension.width * 3.5 / 4.5,
                  y: 75)
    }
}

struct CannonBallMagazineView_Previews: PreviewProvider {
    static var previews: some View {
        CannonBallMagazineView(gameEngineManager: GameEngineManager(canvasDimension: .null))
    }
}
