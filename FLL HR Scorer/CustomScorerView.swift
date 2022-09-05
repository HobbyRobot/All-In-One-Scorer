//
//  CustomScorerView.swift
//  FLL HR Scorer
//
//  Created by Matej Volkmer on 19.08.2022.
//

import SwiftUI

var timeOut = 100
var timer = Timer.publish(every: 0.01, on: .main, in: .common).autoconnect()

struct CustomScorerView: View {
    @State var sumPoints = 0
    @State var variation = 1
    @State var lastPoints = [0]
    @State var timeRemaining = 0
    @State var currentRun = 0
    @State var currentMission = 0
    @State var currentId = 0
    @State var state = 0
    @State var runs = [Run]()
    @State var runRunning = false
    @State var runsScores = [0]
    @State var times = [0]
    @State var notes = ""
    @State var maxScores = [Int]()
    @State var showShare = false
    
    @Binding var m: [Mission]
    @Binding var latestScore: Int
    @Binding var latestTime: Int
    @Binding var savedData: String
    @Binding var strings: [String]
    @Binding var timerSeconds: String
    @Binding var addNotes: Bool
    @Binding var dateFormat: String
    @Binding var ouputScheme: String
    
    var body: some View {
        if runs.isEmpty {
            Text("Load runs failed")
                .onAppear {
                    runs = loadRuns(fileName: "RUNS", fileType: "json")
                    for _ in runs {
                        runsScores.append(0)
                    }
                    maxScores = getMaxScores()
                }
                .navigationTitle("Scorer")
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarHidden(false)
        } else if state == 0 {
            VStack(spacing: 20) {
                Text("Last time: \(String(format: "%.2f", (Float(latestTime) / 100.0))) s")
                Text("Last score: \(latestScore) p")
                
                Button("Start") {
                    impactMed.impactOccurred()
                    
                    state = 1
                    runRunning = true
                    timeRemaining = (Int(timerSeconds) ?? 1) * 100
                    times.append(timeRemaining)
                }
                .buttonStyle(BorderedButtonStyle())
                .onAppear {
                    sumPoints = 0
                    variation = 1
                    lastPoints = [0]
                    timeRemaining = (Int(timerSeconds) ?? 1) * 100
                    currentRun = 0
                    currentMission = 0
                    currentId = 0
                    state = 0
                    runRunning = false
                    runsScores = [0]
                    times = [0]
                    notes = addNotes ? "Add some notes..." : ""
                    
                    for _ in runs {
                        runsScores.append(0)
                    }
                }
            }
            .navigationTitle("Scorer")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarHidden(false)
        } else if state == 1 {
            VStack {
                TimerRowView(sumPoints: $sumPoints, lastPoints: $lastPoints, timeRemaining: $timeRemaining, currentRun: $currentRun, currentMission: $currentMission, state: $state, runs: $runs, runsScores: $runsScores)
                    .frame(height: 63)
                
                Color(runs[currentId].color)
                    .frame(height: 200)
                    .padding(40)
                
                Text(runs[currentId].name)
                    .font(.title)
                
                Button(runRunning ? strings[0] : strings[1]) {
                    impactMed.impactOccurred()
                    
                    times.append(timeRemaining)
                    times[times.count-2] -= timeRemaining
                    
                    if runRunning {
                        currentId += 1
                    }
                    
                    runRunning.toggle()
                    
                    if currentId >= runs.count {
                        timer.upstream.connect().cancel()
                        times.removeLast()
                        state = 2
                    }
                }
                .buttonStyle(BigButtonStyle(backgroundColor: Color(white: 0.9), foregroundColor: .blue, width: 300))
                
                Spacer()
                
                if times.count > 1 {
                    Text("\(runRunning ? strings[2] : strings[3]) \(String(format: "%.2f", (Float(times[times.count-2]) / 100.0))) s")
                }
                
            }
            .onReceive(timer) { _ in
                timeRemaining -= 1
                if timeRemaining < 0 {
                    timeOut = -100
                } else {
                    timeOut = 100
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
        } else if state == 2 {
            VStack {
                TimerRowView(sumPoints: $sumPoints, lastPoints: $lastPoints, timeRemaining: $timeRemaining, currentRun: $currentRun, currentMission: $currentMission, state: $state, runs: $runs, runsScores: $runsScores)
                    .frame(height: 100)
                    .zIndex(10000)
                
                Image("M\(m[runs[currentRun].missionIDs[currentMission]].id)")
                    .resizable()
                    .scaledToFill()
                    .padding()
                    .frame(height: 300)
                    .clipped()
                    .border(.gray, width: 1)
                
                Color.clear
                
                MissionView(m: $m[runs[currentRun].missionIDs[currentMission]],
                            variation: runs[currentRun].scoreIDs[currentMission], onDone: { points in
                    lastPoints.append(points)
                    sumPoints += points
                    runsScores[currentRun] += points
                    
                    if currentMission < runs[currentRun].missionIDs.count-1 {
                        currentMission += 1
                    } else if currentRun < runs.count-1 {
                        currentRun += 1
                        currentMission = 0
                    } else {
                        latestTime = times.reduce(0, +)
                        latestScore = sumPoints
                        state = 3
                    }
                })
                
                Text("\(sumPoints) points")
                Text("\(currentRun + 1)/\(runs.count)")
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
        } else if state == 3 {
            VStack(spacing: 20) {
                Spacer()
                
                if addNotes {
                    TextEditor(text: $notes)
                        .frame(width: 300, height: 200)
                        .padding()
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color.gray, lineWidth: 1)
                        )
                    
                    Spacer()
                }
                
                Text("End")
                Text("Current time: \(String(format: "%.2f", (Float(times.reduce(0, +)) / 100.0))) s")
                Text("Current score: \(runsScores.reduce(0, +)) p")
                    .onAppear {
                        savedData = saveData()
                    }
                
                Button("Save") {
                    impactMed.impactOccurred()
                    
                    savedData = saveData()
                    
                    print(savedData) // TODO: ulozit na server
                    // TODO: Settings kam
                }
                .buttonStyle(BorderedButtonStyle())
                
                Button(action: {
                    impactMed.impactOccurred()
                    
                    if savedData == "" {
                        savedData = saveData()
                    }
                    
                    showShare.toggle()
                }, label: {
                    Image(systemName: "square.and.arrow.up")
                        .font(.largeTitle)
                        .padding(40)
                })
                .sheet(isPresented: $showShare, content: {
                    ActivityViewController(itemsToShare: [savedData])
                })
                
                Button("Reset") {
                    impactMed.impactOccurred()
                    
                    state = 0
                }
                .buttonStyle(BorderedButtonStyle())
                
                Spacer()
            }
            .ignoresSafeArea(.keyboard)
            .navigationTitle("Scorer")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarHidden(false)
        }
    }
    
    func getMaxScores() -> [Int] {
        var maxScores = [Int]()
        
        for r in runs {
            maxScores.append(0)
            
            for i in 0..<r.missionIDs.count {
                let variation = r.scoreIDs[i]
                let mm = r.missionIDs[i]
                
                if m[mm].score[variation-1].tags.isEmpty {
                    maxScores[maxScores.count-1] += m[mm].score[variation-1].points[0]
                } else if m[mm].score[variation-1].tags.last!.isInt {
                    maxScores[maxScores.count-1] += m[mm].score[variation-1].points.reduce(0, +)
                } else {
                    maxScores[maxScores.count-1] += m[mm].score[variation-1].points.last!
                }
            }
        }
        
        return maxScores
    }
    
    func saveData() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat
        // TODO: Settings var outputScheme
        var output = "id;RobotGame;\(formatter.string(from: Date()));"
        for i in 0..<runs.count {
            output += "\(Float(times[i*2]) / 100.0);\(Float(times[i*2+1]) / 100.0);"
            output += "\(runsScores[i]);\(maxScores[i]);"
        }
        output += "bonus;xd;\(notes)" // TODO: Dodelat bonus
        output = output.replacingOccurrences(of: ",", with: ".")
        // TODO: Dodelat funkcne
        return output
    }
    
    func loadRuns(fileName: String, fileType: String) -> [Run] {
        do {
            if let bundlePath = Bundle.main.path(forResource: fileName, ofType: fileType),
               let jsonData = try String(contentsOfFile: bundlePath).data(using: .utf8) {
                let runs = try JSONDecoder().decode([Run].self, from: jsonData)
                
                return runs
            }
        } catch {
            print(error.localizedDescription)
        }
        
        return [Run]()
    }
}

struct BigButtonStyle: ButtonStyle {
    var backgroundColor: Color
    var foregroundColor: Color
    var width: CGFloat? = nil
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(20)
            .frame(width: width)
            .foregroundColor(foregroundColor)
            .font(.largeTitle)
            .background(backgroundColor)
            .clipShape(Capsule())
            .scaleEffect(configuration.isPressed ? 1.2 : 1)
            .animation(.easeInOut(duration: 0.2), value: configuration.isPressed)
    }
}

struct ActivityViewController: UIViewControllerRepresentable {
    var itemsToShare: [Any]
    var servicesToShareItem: [UIActivity]? = nil
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ActivityViewController>) -> UIActivityViewController {
        let controller = UIActivityViewController(activityItems: itemsToShare, applicationActivities: servicesToShareItem)
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: UIViewControllerRepresentableContext<ActivityViewController>) {}
}
