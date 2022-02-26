//
//  ButtonsRowView.swift
//  peggleclone
//
//  Created by Stuart Long on 24/1/22.
//

import SwiftUI

struct ButtonsRowView: View {
    @EnvironmentObject var allLevelsManager: AllLevelsManager
    @EnvironmentObject var levelManager: LevelManager
    @Binding var load: Bool
    @Binding var levelName: String
    @Binding var start: Bool
    @Binding var editLevels: Bool
    @Binding var isResize: Bool

    var body: some View {
        HStack {
            Button("LOAD") {
                load.toggle()
            }
            .foregroundColor(.blue)
            .padding(.leading)

            Button("SAVE") {
                levelManager.save(name: levelName, allLevelsManager: allLevelsManager)
            }
            .foregroundColor(.blue)

            Button("RESET") {
                levelManager.deleteAll()
            }
            .foregroundColor(.blue)

            Button("RESIZE") {
                self.isResize.toggle()
            }
            .foregroundColor(.blue)
            .background(isResize ? .pink : .white)

            TextField(
                "Level Name",
                text: $levelName
            )
            .textFieldStyle(.roundedBorder)
            .padding()

            Button("START") {
                start = true
                editLevels = false
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
                       levelName: .constant(""),
                       start: .constant(false),
                       editLevels: .constant(true),
                       isResize: .constant(false))
    }
}
