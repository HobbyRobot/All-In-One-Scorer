//
//  FLL_HR_ScorerApp.swift
//  FLL HR Scorer
//
//  Created by Matej Volkmer on 12.08.2022.
//

import SwiftUI

let store = UserDefaults.standard
let impactMed = UIImpactFeedbackGenerator(style: UIImpactFeedbackGenerator.FeedbackStyle.medium)

@main
struct FLL_HR_ScorerApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
