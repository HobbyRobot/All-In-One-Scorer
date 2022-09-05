//
//  OfficialScorerView.swift
//  FLL HR Scorer
//
//  Created by Matej Volkmer on 19.08.2022.
//

import SwiftUI

struct OfficialScorerView: View {
    @Binding var m: [Mission]
    @Binding var userSelection: [[Int]]
    @Binding var sumPoints: Int
    @Binding var scores: [[Int]]
    @Binding var selectedSeasonOfficial: String // TODO: Add multiple seasons
    @Binding var defaultMissions: String
    @Binding var defaultOnStart: Bool
    @Binding var defaultOnReset: Bool
    
    var body: some View {
        Form {
            ForEach(Array(zip(m.indices, m)), id: \.0) { i, mission in
                Section(header: Text("\(mission.id < 10 ? "M0" : "M")\(mission.id)")) {
                    HStack {
                        Text(mission.name)
                        Spacer()
                        Text("\(scores.isEmpty ? 0 : scores[i].sumArr())")
                    }

                    Text(mission.description)

                    Image("M\(mission.id)")
                        .resizable()
                        .scaledToFill()
                        .frame(height: 240)
                        .clipped()
                        .border(.gray, width: 1)

                    ForEach(Array(zip(mission.score.indices, mission.score)), id: \.0) { j, score in
                        if score.points.count == 1 {
                            // Yes or No
                            VStack {
                                Toggle(score.desc ,isOn: $userSelection[i][j].bool(points: score.points.first!))
                                    .onChange(of: userSelection) { _ in
                                        scores[i][j] = userSelection[i][j]
                                    }

                                if score.tags.first != nil {
                                    Text(score.tags.first!).foregroundColor(.red)
                                }
                            }
                        } else if score.points.count > 5 && score.tags.first!.isInt {
                            HStack {
                                Stepper(label: { Text(score.desc) }, onIncrement: {
                                    if userSelection[i][j] < score.points.count-1 {
                                        userSelection[i][j] += 1
                                        scores[i][j] = userSelection[i][j] * score.points[score.tags.count-1]
                                    }
                                }, onDecrement: {
                                    if userSelection[i][j] > 0 {
                                        userSelection[i][j] -= 1
                                        scores[i][j] = userSelection[i][j] * score.points[score.tags.count-1]
                                    }
                                })
                                Text("\(userSelection[i][j])")
                            }
                        } else {
                            // Number or choose
                            VStack(alignment: .leading) {
                                Text(score.desc)
                                Picker("", selection: $userSelection[i][j]) {
                                    ForEach(0..<score.points.count, id: \.self) { k in
                                        Text(score.tags[k])
                                    }
                                }
                                .onChange(of: userSelection[i][j]) { sel in
                                    var newScore = 0

                                    if score.tags[min(sel, score.tags.count-1)].isInt {
                                        newScore = sel * score.points[min(sel, score.tags.count-1)]
                                    } else {
                                        newScore = score.points[min(sel, score.tags.count-1)]
                                    }

                                    scores[i][j] = newScore
                                }
                                .ifMod(score.tags.count < 8) { view in
                                    view.pickerStyle(SegmentedPickerStyle())
                                }
                            }
                        }
                    }
                }
            }
        }
        .navigationBarTitle("Official scorer")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            if scores.isEmpty {
                scores = userSelection
                
                if defaultOnStart {
                    for ii in defaultMissions.components(separatedBy: [",", "."]) {
                        if let i = Int(ii) {
                            userSelection[i][0] = m[i].score[0].points.last!
                            scores[i][0] = m[i].score[0].points.last!
                        }
                    }
                }
            }
        }
        .toolbar {
            ToolbarItemGroup(placement: .bottomBar) {
                HStack {
                    Text("Total score: ")
                    Text("\(scores.joined().reduce(0, +))")
                    Spacer()
                    Button("Save") {
                        print(scores.joined().reduce(0, +))
                        // TODO: Dodelat ukladani skore
                    }
                    .buttonStyle(BorderedButtonStyle())
                }
            }
            
            ToolbarItemGroup(placement: .navigation) {
                HStack {
                    Button("Reset") {
                        for i in 0..<userSelection.count {
                            for j in 0..<userSelection[i].count {
                                userSelection[i][j] = 0
                                scores[i][j] = 0
                            }
                        }
                        
                        if defaultOnReset {
                            for ii in defaultMissions.components(separatedBy: [",", "."]) {
                                if let i = Int(ii) {
                                    userSelection[i][0] = m[i].score[0].points.last!
                                    scores[i][0] = m[i].score[0].points.last!
                                }
                            }
                        }
                    }

                    Button("Max") {
                        for i in 0..<userSelection.count {
                            for j in 0..<userSelection[i].count {
                                if m[i].score[j].points.count == 1 {
                                    userSelection[i][j] = m[i].score[j].points.first!
                                    scores[i][j] = m[i].score[j].points.first!
                                } else {
                                    userSelection[i][j] = m[i].score[j].points.count-1
                                    scores[i][j] = m[i].score[j].points.count-1
                                }

                                let sel = m[i].score[j].points.count-1

                                if m[i].score[j].tags.isEmpty {

                                } else if m[i].score[j].tags.last!.isInt {
                                    scores[i][j] = sel * m[i].score[j].points.last!
                                } else {
                                    scores[i][j] = m[i].score[j].points.last!
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

extension View {
    @ViewBuilder func `ifMod`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}

extension Binding where Value == Int {
    public func bool(points: Int) -> Binding<Bool> {
            return Binding<Bool>(get: {
                self.wrappedValue > 0 ? true : false
            }, set: { i in
                self.wrappedValue = i == true ? points : 0
            })
        }
}
