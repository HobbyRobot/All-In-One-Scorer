//
//  TestImage.swift
//  FLL HR Scorer
//
//  Created by Matej Volkmer on 01.09.2022.
//

import SwiftUI

struct TestImage: View {
    var body: some View {
        VStack {
            Image("M2")
                .resizable()
                .scaledToFit()
    //            .frame(height: 222)
                .border(.gray, width: 1)
        }
    }
}

struct TestImage_Previews: PreviewProvider {
    static var previews: some View {
        TestImage()
    }
}
