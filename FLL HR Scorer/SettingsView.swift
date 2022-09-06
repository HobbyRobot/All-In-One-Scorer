//
//  SettingsView.swift
//  FLL HR Scorer
//
//  Created by Matej Volkmer on 21.08.2022.
//Section(header: Text("\(mission.id < 10 ? "M0" : "M")\(mission.id)")) {

import SwiftUI

let seasonsToChoose = ["Current season"] // TODO: Add multiple seasons
let runsToChoose = ["RUNS.json"] // TODO: Add multiple runs possibility
let screensToChoose: [Screens?] = [nil, .Timer, .Official, .Custom]

struct SettingsView: View {
    @FocusState private var fieldIsFocused: Bool
    @Binding var selectedScreen: Screens?
    
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
    @Binding var timerSeconds: String
    @Binding var addNotes: Bool
    @Binding var dateFormat: String
    @Binding var outputScheme: String // TODO: Dodelat funkcne
     
    var body: some View {
        Form {
            Section(header: Text("Default Screen")) {
                Picker("Default screen", selection: $selectedScreen, content: {
                    ForEach(screensToChoose, id: \.self) { season in
                        Text(season?.rawValue ?? "None")
                    }
                })
            }
            
            // Timer
            Section(header: Text("Timer Settings")) {
                HStack {
                    Text("Notes font size")
                    Spacer()
                    Stepper("\(Int(fontSize))", onIncrement: {
                        if fontSize < 50 { fontSize += 2 }
                    }, onDecrement: {
                        if fontSize > 10 { fontSize -= 2 }
                    })
                    .frame(width: 160)
                }
                HStack {
                    Text("Minutes")
                    Spacer()
                    Stepper("\(Int(userClock[0]))", onIncrement: {
                        if userClock[0] < 59 { userClock[0] += 1 }
                    }, onDecrement: {
                        if userClock[0] > 0 { userClock[0] -= 1
                            if userClock[0] == 0 && userClock[1] == 0 {
                                userClock[1] = 1
                            }
                        }
                    })
                    .frame(width: 160)
                }
                HStack {
                    Text("Seconds")
                    Spacer()
                    Stepper("\(Int(userClock[1]))", onIncrement: {
                        if userClock[1] < 59 { userClock[1] += 1 }
                    }, onDecrement: {
                        if userClock[1] > 0 { userClock[1] -= 1
                            if userClock[0] == 0 && userClock[1] == 0 {
                                userClock[1] = 1
                            }
                        }
                    })
                    .frame(width: 160)
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
                    // TODO: Add season config
                }.disabled(true)
                Toggle("Default on start", isOn: $defaultOnStart)
                Toggle("Default on reset", isOn: $defaultOnReset)
                HStack {
                    Text("Default missions")
                    Spacer()
                    TextField("Enter IDs", text: $defaultMissions)
                        .onChange(of: defaultMissions) { newValue in
                            var filtered = defaultMissions.filter { "0123456789.,".contains($0) }
                            while filtered.count > 20 {
                                _ = filtered.removeLast()
                            }
                            defaultMissions = filtered
                        }
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(width: 150)
                        .keyboardType(.decimalPad)
                        .focused($fieldIsFocused)
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
                        Section(header: Text("Enter alias")) {
                            TextField("", text: $strings[0])
                        }
                        Section(header: Text("Enter alias")) {
                            TextField("", text: $strings[1])
                        }
                        Section(header: Text("Enter alias")) {
                            TextField("", text: $strings[2])
                        }
                        Section(header: Text("Enter alias")) {
                            TextField("", text: $strings[3])
                        }
                    }
                    .listStyle(GroupedListStyle())
                }
                HStack {
                    Text("Timer seconds")
                    Spacer()
                    TextField("Enter timer seconds", text: $timerSeconds)
                        .onChange(of: timerSeconds) { newValue in
                            let filtered = newValue.filter { "0123456789".contains($0) }
                            if Int(filtered) ?? 0 > 500 {
                                timerSeconds = "499"
                            } else if filtered == "0" {
                                timerSeconds = "1"
                            } else {
                                timerSeconds = filtered
                            }
                        }
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(width: 100)
                        .keyboardType(.numberPad)
                        .focused($fieldIsFocused)
                }
                Toggle("Show notes at end", isOn: $addNotes)
                HStack {
                    Text("Date format")
                    Spacer()
                    TextField("mm.DD.yyyy", text: $dateFormat)
                        .onChange(of: dateFormat) { newValue in
                            var temp = newValue
                            while temp.count > 15 {
                                _ = temp.removeLast()
                            }
                            dateFormat = temp
                        }
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(width: 150)
                }
                HStack {
                    Text("Output scheme")
                    Spacer()
                    TextField("Scheme...", text: $outputScheme)
                        .onChange(of: outputScheme) { newValue in
                            var temp = newValue
                            while temp.count > 40 {
                                _ = temp.removeLast()
                            }
                            outputScheme = temp
                        }
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(width: 150)
                }
            }
            
//            Color.clear.frame(height: 300) // TODO: tohle dodelat
        }
        .autocapitalization(.sentences)
        .disableAutocorrection(true)
        .pickerStyle(MenuPickerStyle())
        .onDisappear { applySettings() }
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            Button("Save") {
                applySettings()
            }
            
            Button("Set default") {
                setDefault()
                applySettings()
            }
        }
        .onTapGesture(count: 2) {
            if fieldIsFocused {
                fieldIsFocused = false
            }
        }
        .onAppear {
            if fontSize < 10 {
                setDefault()
                applySettings()
            }
        }
    }
    
    func setDefault() {
        selectedScreen = nil
        fontSize = 30
        userClock[0] = 2
        userClock[1] = 30
        selectedSeasonOfficial = seasonsToChoose[0]
        defaultMissions = "0.16"
        defaultOnStart = true
        defaultOnReset = true
        selectedSeasonCustom = seasonsToChoose[0]
        selectedRuns = runsToChoose[0]
        timerSeconds = "150"
        addNotes = true
        dateFormat = "mm.DD.yyyy"
        outputScheme = "neco"
        strings[0] = "End"
        strings[1] = "Start"
        strings[2] = "Ex"
        strings[3] = "Run"
    }
    
    func applySettings() {
        store.set(selectedScreen?.rawValue ?? "None", forKey: "selected-screen")
        
        // Store timer vars
        store.set(fontSize, forKey: "timer-font-size")
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
        store.set(outputScheme, forKey: "custom-output-scheme")
        store.set(strings[0], forKey: "custom-run-end")
        store.set(strings[1], forKey: "custom-run-start")
        store.set(strings[2], forKey: "custom-attachment")
        store.set(strings[3], forKey: "custom-run")
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SettingsView(selectedScreen: .constant(nil), fontSize: .constant(30.0), userClock: .constant([2, 30]), selectedSeasonOfficial: .constant("Current Season"), defaultMissions: .constant(""), defaultOnStart: .constant(true), defaultOnReset: .constant(false), selectedSeasonCustom: .constant("Current Season"), selectedRuns: .constant("RUNS.json"), strings: .constant(["End", "Start", "Ex", "Ride"]), timerSeconds: .constant("150"), addNotes: .constant(true), dateFormat: .constant("mm.DD.yyyy"), outputScheme: .constant("neco"))
        }
    }
}

extension View {
  func endTextEditing() {
    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder),
                                    to: nil, from: nil, for: nil)
  }
}

enum Screens: String {
    case Timer
    case Official
    case Custom
}
