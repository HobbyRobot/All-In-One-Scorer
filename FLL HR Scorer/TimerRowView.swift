//
//  TimerRowView.swift
//  FLL HR Scorer
//
//  Created by Matej Volkmer on 27.08.2022.
//

import SwiftUI

struct TimerRowView: View {
    @Binding var sumPoints: Int
    @Binding var lastPoints: [Int]
    @Binding var timeRemaining: Int
    @Binding var currentRun: Int
    @Binding var currentMission: Int
    @Binding var state: Int
    @Binding var runs: [Run]
    @Binding var runsScores: [Int]
    
    var body: some View {
        GeometryReader { geo in
            VStack {
                HStack {
                    Spacer()
                    
                    Button("Reset") {
                        let impactMed = UIImpactFeedbackGenerator(style: feedback)
                        impactMed.impactOccurred()
                        
                        state = 0
                    }
                    
                    Text(String(format:"%02i:%02i", Int(timeRemaining / timeOut) / 60 % 60, Int(timeRemaining / timeOut) % 60))
                        .font(.system(size: 50, weight: .bold, design: .monospaced))
                        .frame(width: 200)
                        .foregroundColor(timeOut < 0 ? .red : .blue)
                    
                    Button("Undo") {
                        let impactMed = UIImpactFeedbackGenerator(style: feedback)
                        impactMed.impactOccurred()
                        
                        if currentMission > 0 {
                            currentMission -= 1
                        } else {
                            currentRun -= 1
                            currentMission = runs[currentRun].missionIDs.count-1
                        }
                        
                        runsScores[currentRun] -= lastPoints.last!
                        sumPoints -= lastPoints.last!
                        lastPoints.removeLast()
                    }
                    .disabled(currentMission == 0 && currentRun == 0)
                    
                    Spacer()
                }
                .frame(width: geo.size.width)
                
                Rectangle()
                    .foregroundColor(.blue)
                    .frame(width: timeRemaining > 1000 ? CGFloat(Int(geo.size.width) / 150 * (timeRemaining / 100)) : CGFloat(Int(geo.size.width) / 150 * 10), height: 3)
                    .offset(x: 0, y: -10)
            }
        }
    }
}
