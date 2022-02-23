//
//  PegsRowView.swift
//  peggleclone
//
//  Created by Stuart Long on 24/1/22.
//

import SwiftUI

struct PegsRowView: View {

    @EnvironmentObject var levelManager: LevelManager
    @ObservedObject var keyboardResponder: KeyboardResponder
    @State var blueOpacity: Double = 0.3
    @State var orangeOpacity: Double = 0.3
    @State var deleteOpacity: Double = 0.3

    var body: some View {
        HStack {
            Button {
                if blueOpacity == 0.3 {
                    blueOpacity = 1
                    orangeOpacity = 0.3
                    deleteOpacity = 0.3
                    levelManager.select(peg: PegType.bluePeg)
                } else {
                    blueOpacity = 0.3
                    levelManager.unselectPeg()
                }
            } label: {
                Image("peg-blue")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .opacity(blueOpacity)
                    .padding(.leading)
            }

            Button {
                if orangeOpacity == 0.3 {
                    orangeOpacity = 1
                    blueOpacity = 0.3
                    deleteOpacity = 0.3
                    levelManager.select(peg: PegType.orangePeg)
                } else {
                    orangeOpacity = 0.3
                    levelManager.unselectPeg()
                }
            } label: {
                Image("peg-orange")
                    .resizable()
                    .opacity(orangeOpacity)
                    .frame(width: 100, height: 100)
            }

            Spacer()

            Button {
                if deleteOpacity == 0.3 {
                    deleteOpacity = 1
                    blueOpacity = 0.3
                    orangeOpacity = 0.3
                    levelManager.selectDelete()
                } else {
                    deleteOpacity = 0.3
                    levelManager.unselectDelete()
                }
            } label: {
                Image("delete")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .opacity(deleteOpacity)
                    .padding(.trailing)
            }
        }
    }
}

struct PegsRow_Previews: PreviewProvider {
    static var previews: some View {
        PegsRowView(keyboardResponder: KeyboardResponder())
    }
}
