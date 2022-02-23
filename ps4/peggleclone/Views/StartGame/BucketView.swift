//
//  BucketView.swift
//  peggleclone
//
//  Created by Stuart Long on 23/2/22.
//

import SwiftUI

struct BucketView: View {
    var size: Double

    var body: some View {
        Image("bucket")
            .resizable()
            .frame(width: size, height: size)
    }
}

struct BucketView_Previews: PreviewProvider {
    static var previews: some View {
        CannonView()
    }
}
