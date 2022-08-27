//
//  SettingsView.swift
//  FLL HR Scorer
//
//  Created by Matej Volkmer on 21.08.2022.
//

// TODO: dodelat user nastaveni

import SwiftUI

struct SettingsView: View {
    var body: some View {
        Group {
            Text("Settings")
        }
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
