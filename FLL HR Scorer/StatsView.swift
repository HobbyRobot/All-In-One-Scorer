//
//  StatsView.swift
//  FLL HR Scorer
//
//  Created by Matej Volkmer on 24.08.2022.
//

import SwiftUI

struct StatsView: View {
    var body: some View {
        Group {
            Text("Statistics")
        }
        .navigationTitle("Statistics")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct StatsView_Previews: PreviewProvider {
    static var previews: some View {
        StatsView()
    }
}
