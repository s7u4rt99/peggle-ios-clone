//
//  RemainingPegsView.swift
//  peggleclone
//
//  Created by Stuart Long on 27/2/22.
//

import SwiftUI

struct RemainingPegsView: View {
    @EnvironmentObject var levelManager: LevelManager

    var body: some View {
        VStack {
            Text("Orange pegs remaining: \(levelManager.level.numOfOrangePegs)")
            Text("Blue pegs remaining: \(levelManager.level.numOfBluePegs)")
            Text("Special pegs remaining: \(levelManager.level.numOfSpecialPegs)")
        }
        .position(x: levelManager.canvasDimension.width - 150, y: levelManager.canvasDimension.height * 0.95)
    }
}

struct RemainingPegsView_Previews: PreviewProvider {
    static var previews: some View {
        RemainingPegsView()
    }
}
