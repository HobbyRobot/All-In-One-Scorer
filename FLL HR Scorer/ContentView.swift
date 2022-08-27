//
//  ContentView.swift
//  FLL HR Scorer
//
//  Created by Matej Volkmer on 12.08.2022.
//

import SwiftUI

struct ContentView: View {
    // Official scorer vars
    @State var m = [Mission]()
    @State var userSelection = [[Int]]()
    @State var sumPoints = 0
    @State var scores = [[Int]]()
    
    // Timer vars
    @State var fontSize: CGFloat = 30
    @State var userClock = [2, 30]
    @State var notes: NSMutableAttributedString = NSMutableAttributedString(string: "Enter some text...")
    
    // Custom scorer vars
    @State var latestScore = 0
    @State var latestTime = 0
    @State var savedData = ""
    
    var body: some View {
        NavigationView {
            VStack(spacing: 50) {
                if m.isEmpty {
                    Text("No config file found")
                        .foregroundColor(.red)
                        .onAppear {
                            m = loadMissions(fileName: "FLL", fileType: "json")
                        }
                }
                
                Spacer()
                
                NavigationLink(destination: {
                    OfficialScorerView(m: $m, userSelection: $userSelection, sumPoints: $sumPoints, scores: $scores)
                }, label: {
                    HStack {
                        Spacer()
                        Text("Official scorer")
                        Spacer()
                    }
                })
                
                NavigationLink(destination: {
                    CustomScorerView(m: $m, latestScore: $latestScore, latestTime: $latestTime, savedData: $savedData)
                }, label: {
                    HStack {
                        Spacer()
                        Text("Custom scorer")
                        Spacer()
                    }
                })
                
                NavigationLink(destination: {
                    TimerView(fontSize: $fontSize, userClock: $userClock, notes: $notes)
                }, label: {
                    HStack {
                        Spacer()
                        Text("Timer")
                        Spacer()
                    }
                })
                
                NavigationLink(destination: {
                    SettingsView()
                }, label: {
                    HStack {
                        Spacer()
                        Text("Settings")
                        Spacer()
                    }
                })
                
                NavigationLink(destination: {
                    StatsView()
                }, label: {
                    HStack {
                        Spacer()
                        Text("Statistics")
                        Spacer()
                    }
                })
                                
                Spacer()
                
                Text("by HobbyRobot team")
            }
            .frame(width: 200)
            .buttonStyle(BorderedButtonStyle())
            .navigationTitle("All-in-one FLL scorer")
//            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    func loadMissions(fileName: String, fileType: String) -> [Mission] {
        do {
            if let bundlePath = Bundle.main.path(forResource: fileName, ofType: fileType),
               let jsonData = try String(contentsOfFile: bundlePath).data(using: .utf8) {
                let missions = try JSONDecoder().decode([Mission].self, from: jsonData)
                
                for (i, m) in missions.enumerated() {
                    userSelection.append([Int]())
                    
                    for _ in m.score {
                        userSelection[i].append(0)
                    }
                }
                
                return missions
            }
        } catch {
            print(error.localizedDescription)
        }
        
        return [Mission]()
    }
}
