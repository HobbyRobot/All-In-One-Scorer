//
//  MissionModel.swift
//  FLL HR Scorer
//
//  Created by Matej Volkmer on 16.08.2022.
//

import SwiftUI

struct Mission: Codable, Identifiable {
    var id: Int
    var name: String
    var description: String
    var score: [Score]
}

struct Score: Codable, Identifiable {
    var id: Int
    var desc: String
    var tags: [String]
    var points: [Int]
}
