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
    @State var scores = [[Int]]()
    @State var sumPoints = 0
    @State var selectedSeasonOfficial = store.string(forKey: "official-selected-season") ?? "Current Season" // _Settings
    @State var defaultMissions = store.string(forKey: "official-default-missions") ?? "" // _Settings
    @State var defaultOnStart = store.bool(forKey: "official-default-on-start") // _Settings
    @State var defaultOnReset = store.bool(forKey: "official-default-on-reset") // _Settings
    
    // Timer vars
    @State var fontSize: CGFloat = CGFloat(store.float(forKey: "timer-font-size")) // _Settings
    @State var userClock = [store.integer(forKey: "timer-clock-minutes"), store.integer(forKey: "timer-clock-seconds")] // _Settings
    @State var notes: NSMutableAttributedString = NSMutableAttributedString(string: "Enter some text...")
    
    // Custom scorer vars
    @State var latestScore = 0
    @State var latestTime = 0
    @State var savedData = ""
    @State var selectedSeasonCustom = store.string(forKey: "custom-selected-season") ?? "Current Season" // _Settings
    @State var selectedRuns = store.string(forKey: "custom-selected-runs") ?? "RUNS.json" // _Settings
    @State var strings = [ // _Settings
        store.string(forKey: "custom-run-end") ?? "End",
        store.string(forKey: "custom-run-start") ?? "Start",
        store.string(forKey: "custom-attachment") ?? "Ex",
        store.string(forKey: "custom-run") ?? "Run"]
    @State var timerSeconds = store.string(forKey: "custom-timer-seconds") ?? "150" // _Settings
    @State var addNotes = store.bool(forKey: "custom-add-notes") // _Settings
    @State var dateFormat = store.string(forKey: "custom-date-format") ?? "dd.MM.yyyy" // _Settings
    @State var outputScheme = store.string(forKey: "custom-output-scheme") ?? "neco" // _Settings
    
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
                    OfficialScorerView(m: $m, userSelection: $userSelection, sumPoints: $sumPoints, scores: $scores, selectedSeasonOfficial: $selectedSeasonOfficial, defaultMissions: $defaultMissions, defaultOnStart: $defaultOnStart, defaultOnReset: $defaultOnReset)
                }, label: {
                    HStack {
                        Spacer()
                        Text("Official scorer")
                        Spacer()
                    }
                })
                
                NavigationLink(destination: {
                    CustomScorerView(m: $m, latestScore: $latestScore, latestTime: $latestTime, savedData: $savedData, strings: $strings, timerSeconds: $timerSeconds, addNotes: $addNotes, dateFormat: $dateFormat, ouputScheme: $outputScheme)
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
                    SettingsView(fontSize: $fontSize, userClock: $userClock, selectedSeasonOfficial: $selectedSeasonOfficial, defaultMissions: $defaultMissions, defaultOnStart: $defaultOnStart, defaultOnReset: $defaultOnReset, selectedSeasonCustom: $selectedSeasonCustom, selectedRuns: $selectedRuns, strings: $strings, timerSeconds: $timerSeconds, addNotes: $addNotes, dateFormat: $dateFormat, ouputScheme: $outputScheme)
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
