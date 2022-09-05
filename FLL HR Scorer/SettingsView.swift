//
//  SettingsView.swift
//  FLL HR Scorer
//
//  Created by Matej Volkmer on 21.08.2022.
//Section(header: Text("\(mission.id < 10 ? "M0" : "M")\(mission.id)")) {

import SwiftUI

struct SettingsView: View {
    let seasonsToChoose = ["Current"] // TODO: Add multiple seasons
    let runsToChoose = ["RUNS.json"] // TODO: Add multiple runs possibility
    
    // Timer vars
    @Binding var fontSize: CGFloat
    @Binding var userClock: [Int]
    
    // Official scorer vars
    @Binding var selectedSeasonOfficial: String // TODO: Add multiple seasons
    @Binding var defaultMissions: String
    @Binding var defaultOnStart: Bool
    @Binding var defaultOnReset: Bool
    
    // Custom scorer vars
    @Binding var selectedSeasonCustom: String // TODO: Add multiple seasons
    @Binding var selectedRuns: String
    @Binding var strings: [String]
    @Binding var timerSeconds: Int
    @Binding var addNotes: Bool
    @Binding var dateFormat: String
    @Binding var ouputScheme: String // TODO: Dodelat funkcne
     
    var body: some View {
        Form {
            // Timer
            Section(header: Text("Timer Settings")) {
                HStack {
                    Text("Notes font size")
                    Spacer()
                    Stepper("\(Int(fontSize))", onIncrement: {
                        if fontSize < 50 { fontSize += 2 }
                        store.set(fontSize, forKey: "timer-font-size")
                    }, onDecrement: {
                        if fontSize > 10 { fontSize -= 2 }
                        store.set(fontSize, forKey: "timer-font-size")
                    })
                    .frame(width: 160)
                }
                HStack {
                    Text("Minutes")
                    Spacer()
                    TextField("Enter timer minutes", text: $userClock[0].toString())
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(width: 200)
                        .keyboardType(.numberPad)
                }
                HStack {
                    Text("Seconds")
                    Spacer()
                    TextField("Enter timer seconds", text: $userClock[1].toString())
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(width: 200)
                        .keyboardType(.numberPad)
                }
            }
            
            // Official scorer
            Section(header: Text("Official scorer Settings"), footer: Text("Enter mission IDs separated by commas or dots")) {
                Picker("Season", selection: $selectedSeasonOfficial, content: {
                    ForEach(seasonsToChoose, id: \.self) { season in
                        Text(season)
                    }
                })
                Button("Add Season config") {
                    print("Add Season config")
                    // TODO: Add Season config
                }.disabled(true)
                Toggle("Default on start", isOn: $defaultOnStart)
                Toggle("Default on reset", isOn: $defaultOnReset)
                HStack {
                    Text("Default missions")
                    Spacer()
                    TextField("Enter IDs", text: $defaultMissions, onEditingChanged: { _ in
                        let filtered = defaultMissions.filter { "0123456789.,".contains($0) }
                        if filtered != defaultMissions {
                            defaultMissions = filtered
                        }
                    })
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(width: 150)
                    .keyboardType(.decimalPad)
                }
            }
            
            // Custom scorer
            Section(header: Text("Custom scorer Settings")) {
                Picker("Season", selection: $selectedSeasonCustom, content: {
                    ForEach(seasonsToChoose, id: \.self) { season in
                        Text(season)
                    }
                })
                Button("Add Season config") {
                    print("Add Season config")
                    // TODO: Add Season config
                }.disabled(true)
                Picker("Runs config", selection: $selectedRuns, content: {
                    ForEach(runsToChoose, id: \.self) { season in
                        Text(season)
                    }
                })
                Button("Add runs config") {
                    print("Add Season config")
                    // TODO: Add Runs config
                }.disabled(true)
                NavigationLink("Set aliases") {
                    List {
                        ForEach($strings, id: \.self) { s in
                            Section(header: Text("Enter alias")) {
                                TextField("", text: s)
                            }
                        }
                    }
                    .listStyle(GroupedListStyle())
                }
                HStack {
                    Text("Timer seconds")
                    Spacer()
                    TextField("Enter timer seconds", text: $timerSeconds.toString())
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(width: 100)
                        .keyboardType(.numberPad)
                }
                Toggle("Show notes at end", isOn: $addNotes)
                HStack {
                    Text("Date format")
                    Spacer()
                    TextField("mm.DD.yyyy", text: $dateFormat)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(width: 150)
                }
                HStack {
                    Text("Output scheme")
                    Spacer()
                    TextField("Scheme...", text: $ouputScheme)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(width: 150)
                }
            }
        }
        .pickerStyle(MenuPickerStyle())
        .onDisappear { applySettings() }
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            Button("Save") {
                applySettings()
            }
        }
    }
    
    func applySettings() {
        // Store timer vars
        store.set(userClock[0], forKey: "timer-clock-minutes")
        store.set(userClock[1], forKey: "timer-clock-seconds")
        
        // Store official scorer vars
        store.set(selectedSeasonOfficial, forKey: "official-selected-season")
        store.set(defaultMissions, forKey: "official-default-missions")
        store.set(defaultOnStart, forKey: "official-default-on-start")
        store.set(defaultOnReset, forKey: "official-default-on-reset")
        
        // Store custom scorer vars
        store.set(selectedSeasonCustom, forKey: "custom-selected-season")
        store.set(selectedRuns, forKey: "custom-selected-runs")
        store.set(timerSeconds, forKey: "custom-timer-seconds")
        store.set(addNotes, forKey: "custom-add-notes")
        store.set(dateFormat, forKey: "custom-date-format")
        store.set(ouputScheme, forKey: "custom-output-scheme")
        store.set(strings[0], forKey: "custom-run-end")
        store.set(strings[1], forKey: "custom-run-start")
        store.set(strings[2], forKey: "custom-attachment")
        store.set(strings[3], forKey: "custom-run")
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SettingsView(fontSize: .constant(30.0), userClock: .constant([2, 30]), selectedSeasonOfficial: .constant("Current"), defaultMissions: .constant(""), defaultOnStart: .constant(true), defaultOnReset: .constant(false), selectedSeasonCustom: .constant("Current"), selectedRuns: .constant("RUNS.json"), strings: .constant(["End", "Start", "Ex", "Ride"]), timerSeconds: .constant(150), addNotes: .constant(true), dateFormat: .constant("mm.DD.yyyy"), ouputScheme: .constant("neco"))
        }
    }
}

extension Binding where Value == Int {
    public func toString() -> Binding<String> {
            return Binding<String>(get: {
                String(self.wrappedValue)
            }, set: { i in
                self.wrappedValue = Int(i) ?? 0
            })
        }
}
