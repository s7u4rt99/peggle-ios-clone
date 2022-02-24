//
//  TriangleView.swift
//  peggleclone
//
//  Created by Stuart Long on 25/2/22.
//

import SwiftUI

struct TriangleView: View {
    @Binding var location: CGPoint
//    var pegType: PegColor
    var triangleBase: Double
    var triangleHeight: Double

    var body: some View {
        Image("peg-red-triangle")
            .resizable()
            .frame(width: triangleBase, height: triangleHeight)
            .position(location)
    }
}

struct TriangleView_Previews: PreviewProvider {
    static var previews: some View {
        TriangleView(location: .constant(CGPoint(x: 400, y: 400)), triangleBase: 50, triangleHeight: 50)
    }
}
