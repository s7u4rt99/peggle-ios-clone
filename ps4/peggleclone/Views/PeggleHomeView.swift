//
//  PeggleHomeView.swift
//  peggleclone
//
//  Created by Stuart Long on 13/2/22.
//

import SwiftUI

struct PeggleHomeView: View {
    @Binding var gameState: GameState

    var body: some View {
        BackgroundView()
        VStack {
            Text("Peggle Clone").font(.system(size: 50))

            Button {
                gameState = GameState.startFromMenu
            } label: {
                Text("Start")
                    .foregroundColor(.white)
                    .padding(15)
                    .font(.system(size: 35))
            }

            Button {
                gameState = GameState.levelDesigner
            } label: {
                Text("Edit Levels")
                    .foregroundColor(.white)
                    .padding(15)
                    .font(.system(size: 35))
            }
        }
    }
}

struct PeggleHome_Previews: PreviewProvider {
    static var previews: some View {
        PeggleHomeView(gameState: .constant(GameState.menu))
    }
}
