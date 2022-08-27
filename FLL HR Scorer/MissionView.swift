//
//  MissionView.swift
//  FLL HR Scorer
//
//  Created by Matej Volkmer on 16.08.2022.
//

import SwiftUI

struct MissionView: View {
    @Binding var m: Mission
    var variation: Int
    
    var onDone: (Int) -> ()
    
    var body: some View {
        VStack(alignment: .center, spacing: 20) {
            Image("\(m.name).jpeg")
                .resizable()
                .frame(width: 300, height: 200)
                .border(.gray, width: 1)
            
            VStack {
                Text(m.name)
                    .font(.title)
                Text(m.description)
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding()
                Text(m.score[variation - 1].desc)
                    .font(.body)
                
                if m.score[variation - 1].points.count == 1 {
                    // Yes or No
                    HStack {
                        Button("NO") {
                            let impactMed = UIImpactFeedbackGenerator(style: feedback)
                            impactMed.impactOccurred()
                            
                            onDone(0)
                        }.buttonStyle(BorderedButtonStyle())
                        
                        Button("YES") {
                            let impactMed = UIImpactFeedbackGenerator(style: feedback)
                            impactMed.impactOccurred()
                            
                            onDone(m.score[variation - 1].points.first!)
                        }
                        .buttonStyle(BorderedButtonStyle())
                    }
                } else if m.score[variation - 1].tags.first!.isInt {
                    // Numbered
                    HStack {
                        ForEach(m.score[variation - 1].tags, id: \.self) { tag in
                            Button(tag) {
                                let impactMed = UIImpactFeedbackGenerator(style: feedback)
                                impactMed.impactOccurred()
                                
                                onDone(m.score[variation - 1].points.sumArr())
                            }
                            .buttonStyle(BorderedButtonStyle())
                        }
                    }
                } else {
                    // Choose
                    HStack {
                        ForEach(m.score[variation - 1].tags, id: \.self) { tag in
                            Button(tag) {
                                let impactMed = UIImpactFeedbackGenerator(style: feedback)
                                impactMed.impactOccurred()
                                
                                onDone(m.score[variation - 1].points[m.score[variation - 1].tags.firstIndex(of: tag)!])
                            }
                            .buttonStyle(BorderedButtonStyle())
                        }
                    }
                }
            }
            .padding()
        }
    }
}

struct MissionView_Previews: PreviewProvider {
    static var previews: some View {
        MissionView(m: .constant(Mission(id: 1, name: "Test", description: "descirption", score: [Score(id: 1, desc: "tag", tags: ["0", "1", "2"], points: [10, 10, 10])])), variation: 1, onDone: { _ in })
    }
}

extension String {
    var isInt: Bool {
        return Int(self) != nil
    }
}

extension Array {
    public func sumArr() -> Int {
        var sum = 0
        for i in 0..<self.count {
            sum += self[i] as! Int
        }
        return sum
    }
}
