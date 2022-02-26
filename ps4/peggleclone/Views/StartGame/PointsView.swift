//
//  PointsView.swift
//  peggleclone
//
//  Created by Stuart Long on 26/2/22.
//

import SwiftUI

struct PointsView: View {
    @EnvironmentObject var levelManager: LevelManager
    @ObservedObject var gameEngineManager: GameEngineManager

    var body: some View {
        Text("Points: \(gameEngineManager.points)")
            .foregroundColor(.black)
            .position(x: 100, y: levelManager.canvasDimension.height * 0.95)
            .font(.system(size: 25))
    }
}

struct PointsView_Previews: PreviewProvider {
    static var previews: some View {
        PointsView(gameEngineManager: GameEngineManager(canvasDimension: .zero))
    }
}
