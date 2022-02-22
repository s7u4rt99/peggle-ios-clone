//
//  CannonView.swift
//  peggleclone
//
//  Created by Stuart Long on 10/2/22.
//

import SwiftUI

struct CannonView: View {
    var body: some View {
        Image("cannon")
            .resizable()
            .frame(width: 150, height: 100)
            .position(CGPoint(x: 400, y: 50))
    }
}

struct CannonView_Previews: PreviewProvider {
    static var previews: some View {
        CannonView()
    }
}
