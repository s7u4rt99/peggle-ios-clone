//
//  TimerView.swift
//  peggleclone
//
//  Created by Stuart Long on 27/2/22.
//

import SwiftUI

struct TimerView: View {
    @EnvironmentObject var levelManager: LevelManager
    @ObservedObject var gameEngineManager: GameEngineManager

    var body: some View {
        Text(String(format: "%.0f", gameEngineManager.timer))
            .position(x: levelManager.canvasDimension.width * 1 / 4,
                      y: levelManager.canvasDimension.height / 15)
            .font(.system(size: 35))
            .foregroundColor(gameEngineManager.timer < 0.0 ? .red : .black)
    }
}

struct TimerView_Previews: PreviewProvider {
    static var previews: some View {
        TimerView(gameEngineManager: GameEngineManager(canvasDimension: .null))
    }
}
