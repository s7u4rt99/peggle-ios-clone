//
//  CannonView.swift
//  peggleclone
//
//  Created by Stuart Long on 10/2/22.
//

import SwiftUI

struct CannonView: View {
    var body: some View {
        Image("cannon-unfired")
            .resizable()
            .frame(width: 100, height: 100)
    }
}

struct CannonView_Previews: PreviewProvider {
    static var previews: some View {
        CannonView()
    }
}
