//
//  CustomScorerView.swift
//  FLL HR Scorer
//
//  Created by Matej Volkmer on 19.08.2022.
//

import SwiftUI

struct CustomScorerView: View {
    @State private var sumPoints = 0
    @State private var variation = 1
    @State private var lastPoints = 0
    @State private var timeRemaining = 15000
    @State private var currentId = 0
    @State private var state = 0
    @State private var feedback =  UIImpactFeedbackGenerator.FeedbackStyle.medium
    @State private var timeOut = 100
        
    @Binding var m: [Mission]
    
    var timer = Timer.publish(every: 0.01, on: .main, in: .common).autoconnect()
    
    var body: some View {
        VStack {
            HStack {
                Button("Reset") {
                    let impactMed = UIImpactFeedbackGenerator(style: feedback)
                    impactMed.impactOccurred()
                    
                    timeRemaining = 150 * 100
                    currentId = 0
                    // Reset vseho
                }
                
                Text(String(format:"%02i:%02i", Int(timeRemaining / timeOut) / 60 % 60, Int(timeRemaining / timeOut) % 60))
                    .font(.system(size: 50, weight: .bold, design: .monospaced))
                    .frame(width: 200)
                    .foregroundColor(timeOut < 0 ? .red : .blue)
                
                Button("Undo") {
                    let impactMed = UIImpactFeedbackGenerator(style: feedback)
                    impactMed.impactOccurred()
                    
                    currentId -= 1
                    // Reset vseho
                }
                .disabled(currentId < 1)
            }
            .frame(height: 60)
            
            Rectangle()
                .foregroundColor(.blue)
                .frame(width: CGFloat(3 * timeRemaining / 100), height: 3)
            
            Spacer()
            
            MissionView(m: $m[currentId], variation: $variation, lastPoints: $lastPoints, onDone: { points in
                sumPoints += points
                variation = 1
                lastPoints = 0
                currentId += 1
                // Reset vseho
            })
            
            Text("\(currentId + 1)/\(m.count)")
        }
            
    //        Group {
    //            if i > m.count - 1 {
    //                Text("End")
    //                    .onAppear {
    //                        print(sumPoints)
    //                    }
    //                    .navigationTitle("Custom scorer")
    //                    .navigationBarTitleDisplayMode(.inline)
    //            } else {
    //                VStack {
//                        MissionView(m: $m[i], variation: $variation, lastPoints: $lastPoints, onDone: { points in
//                            sumPoints += points
//                            variation = 1
//                            lastPoints = 0
//                            i += 1
//                        })
    //                }
    //                .navigationBarBackButtonHidden(true)
    //            }
    //        }
    }
}

struct CustomScorerView_Previews: PreviewProvider {
    static var previews: some View {
        CustomScorerView(m: .constant([Mission(id: 1, name: "Test", description: "descirption", score: [Score(id: 1, desc: "tag", tags: ["0", "1", "2"], points: [10, 10, 10])])]))
    }
}
