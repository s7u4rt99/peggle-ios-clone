//
//  PegView.swift
//  peggleclone
//
//  Created by Stuart Long on 25/1/22.
//

import SwiftUI

struct PegView: View {

    @Binding var location: CGPoint
    var pegType: PegType
    var pegRadius: Double

    var body: some View {
        Image(pegType.rawValue)
            .resizable()
            .frame(width: pegRadius * 2, height: pegRadius * 2)
            .position(location)
    }
}

struct Peg_Previews: PreviewProvider {
    static var previews: some View {
        PegView(location: .constant(CGPoint(x: 100, y: 100)), pegType: PegType.orangePeg,
            pegRadius: 25)
    }
}
