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
    @State private var timer = [0, 0, 0]
    @State private var buttonsDisabled = [false, true, true]
    @State private var running = false
    @State private var tempClock = 0
    @State private var fontSize: CGFloat = 30
    @State private var userClock = [2, 30]
    @State private var notes: NSMutableAttributedString = NSMutableAttributedString(string: "Enter some text")
    
    var body: some View {
        NavigationView {
            VStack(spacing: 50) {
                if m.isEmpty {
                    Text("No config file found")
                        .foregroundColor(.red)
                        .onAppear {
                            m = loadMissions(fileName: "FLL", fileType: "json") ?? [Mission]()
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
                    CustomScorerView(m: $m)
                }, label: {
                    HStack {
                        Spacer()
                        Text("Custom scorer")
                        Spacer()
                    }
                })
                
                NavigationLink(destination: {
                    TimerView(timer: $timer, buttonsDisabled: $buttonsDisabled, running: $running, tempClock: $tempClock, fontSize: $fontSize, userClock: $userClock, notes: $notes)
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
    
    func loadMissions(fileName: String, fileType: String) -> [Mission]? {
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
        
        return nil
    }
}
