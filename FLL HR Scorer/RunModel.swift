//
//  RunModel.swift
//  FLL HR Scorer
//
//  Created by Matej Volkmer on 27.08.2022.
//

import SwiftUI

struct Run: Codable, Identifiable {
    var id: Int
    var name: String
    var color: String
    var missionIDs: [Int]
    var scoreIDs: [Int]
}
