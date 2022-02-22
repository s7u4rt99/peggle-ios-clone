//
//  ButtonsRowView.swift
//  peggleclone
//
//  Created by Stuart Long on 24/1/22.
//

import SwiftUI

struct ButtonsRowView: View {
    @EnvironmentObject var levelManager: LevelManager
    @EnvironmentObject var pegManager: PegManager
    @Binding var load: Bool
    @Binding var levelName: String

    var body: some View {
        HStack {
            Button("LOAD") {
                load.toggle()
            }
            .foregroundColor(.blue)
            .padding(.leading)

            Button("SAVE") {
                pegManager.save(name: levelName, levelManager: levelManager)
            }
            .foregroundColor(.blue)

            Button("RESET") {
                pegManager.deleteAll()
            }
            .foregroundColor(.blue)

            TextField(
                "Level Name",
                text: $levelName
            )
            .textFieldStyle(.roundedBorder)
            .padding()

            Button("START") {

            }
            .foregroundColor(.blue)
            .padding(.trailing)
        }
    }
}

struct ButtonsRow_Previews: PreviewProvider {

    @State var load: Bool

    static var previews: some View {
        ButtonsRowView(load: .constant(true),
                   levelName: .constant(""))
    }
}
