//
//  CannonView.swift
//  peggleclone
//
//  Created by Stuart Long on 10/2/22.
//

import SwiftUI

struct CannonView: View {
    static let positionOfCannon = Point(xCoordinate: 400, yCoordinate: 50)

    var body: some View {
        Image("cannon-unfired")
            .resizable()
            .frame(width: 100, height: 100)
//            .position(CGPoint(x: CannonView.positionOfCannon.xCoordinate,
//                              y: CannonView.positionOfCannon.yCoordinate))
    }
}

struct CannonView_Previews: PreviewProvider {
    static var previews: some View {
        CannonView()
    }
}
