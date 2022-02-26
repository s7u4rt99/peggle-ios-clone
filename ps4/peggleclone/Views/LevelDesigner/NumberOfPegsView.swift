//
//  NumberOfPegsView.swift
//  peggleclone
//
//  Created by Stuart Long on 27/2/22.
//

import SwiftUI

struct NumberOfPegsView: View {
    @EnvironmentObject var levelManager: LevelManager

    var body: some View {
        VStack {
            Text("Number of orange pegs: \(levelManager.level.numOfOrangePegs)")
            Text("Number of blue pegs: \(levelManager.level.numOfBluePegs)")
            Text("Number of special pegs: \(levelManager.level.numOfSpecialPegs)")
            Text("Number of blocks: \(levelManager.level.numOfBlocks)")
        }
        .position(x: levelManager.canvasDimension.width - 150, y: 57)
    }
}

struct NumberOfPegsView_Previews: PreviewProvider {
    static var previews: some View {
        NumberOfPegsView()
    }
}
