//
//  PeggleHomeView.swift
//  peggleclone
//
//  Created by Stuart Long on 13/2/22.
//

import SwiftUI

struct PeggleHomeView: View {
    @Binding var start: Bool
    @Binding var editLevels: Bool

    var body: some View {
        BackgroundView()
        VStack {
            Text("Peggle Clone").font(.system(size: 50))

            Button {
                start.toggle()
            } label: {
                Text("Start")
                    .foregroundColor(.white)
                    .padding(15)
                    .font(.system(size: 35))
            }

            Button {
                editLevels.toggle()
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
        PeggleHomeView(start: .constant(false), editLevels: .constant(false))
    }
}
