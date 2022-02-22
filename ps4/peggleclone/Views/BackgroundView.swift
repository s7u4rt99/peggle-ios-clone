//
//  BackgroundView.swift
//  peggleclone
//
//  Created by Stuart Long on 24/1/22.
//

import SwiftUI

struct BackgroundView: View {
    @ObservedObject var keyboardResponder = KeyboardResponder()

    var body: some View {
        GeometryReader { _ in
            Image("background")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .ignoresSafeArea()
                .offset(y: -keyboardResponder.currentHeight * 0.9)

        }
    }
}

struct Background_Previews: PreviewProvider {
    static var previews: some View {
        BackgroundView()
    }
}
