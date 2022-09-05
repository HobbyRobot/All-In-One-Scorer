//
//  TimerView.swift
//  FLL HR Scorer
//
//  Created by Matej Volkmer on 21.08.2022.
//

import SwiftUI

struct TimerView: View {
    @Binding var fontSize: CGFloat
    @Binding var userClock: [Int]
    @Binding var notes: NSMutableAttributedString 
    
    @State private var tempClock = 0
    @State private var timer = [0, 0, 0]
    @State private var buttonsDisabled = [false, true, true]
    @State private var running = false
    
    let fontSizes: [CGFloat] = [60, 24]
    var clock = Timer.publish(every: 0.01, on: .main, in: .default).autoconnect()
    
    var body: some View {
        VStack(alignment: .center) {
            VStack {
                ZStack(alignment: .bottomTrailing) {
                    HStack {
                        Button(action: {
                            fontSize += 2
                        }, label: {
                            Image(systemName: "plus.circle")
                        })
                        Button(action: {
                            fontSize -= 2
                        }, label: {
                            Image(systemName: "minus.circle")
                        })
                    }
                    .padding()
                    .zIndex(100)
                    
                    TextView(attributedText: $notes, fontSize: $fontSize, allowsEditingTextAttributes: true)
                        .padding()
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color.gray, lineWidth: 1)
                        )
                        .zIndex(1)
                }
                .frame(width: 360)
                .frame(maxHeight: 160)
                
                HStack(alignment: .lastTextBaseline) {
                    Text(timer[2] < 10 ? "0\(timer[2])" : "\(timer[2])")
                        .font(.system(size: fontSizes[1], weight: .regular, design: .monospaced))
                        .foregroundColor(.clear)
                    HStack {
                        Text(timer[0] < 10 ? "0\(timer[0])" : "\(timer[0])")
                        Text(":")
                        Text(timer[1] < 10 ? "0\(timer[1])" : "\(timer[1])")
                    }
                    .font(.system(size: fontSizes[0], weight: .regular, design: .monospaced))
                    Text(timer[2] < 10 ? "0\(timer[2])" : "\(timer[2])")
                        .font(.system(size: fontSizes[1], weight: .regular, design: .monospaced))
                        .foregroundColor(.gray)
                }
                .padding()
                .onReceive(clock) { _ in
                    if running {
                        tempClock -= 1
                    }
                    
                    timer[2] = tempClock % 100
                    timer[1] = (tempClock / 100) % 60
                    timer[0] = (tempClock / 100 / 60) % 60
                }
                        
                if buttonsDisabled[2] && buttonsDisabled[1] {
                    VStack {
                        HStack(alignment: .top) {
                            Picker(selection: $userClock[0], content: {
                                ForEach(0...59, id: \.self) { i in
                                    Text("\(i)")
                                }
                            }, label: { })
                            .pickerStyle(WheelPickerStyle())
                            .frame(width: 130)
                            .clipped()
                            
                            Picker(selection: $userClock[1], content: {
                                ForEach(0...59, id: \.self) { i in
                                    Text("\(i)")
                                }
                            }, label: { })
                            .pickerStyle(WheelPickerStyle())
                            .frame(width: 130)
                            .clipped()
                        }
                                            
                        Button("Save as default") {
                            store.set(userClock[0], forKey: "timer-clock-minutes")
                            store.set(userClock[1], forKey: "timer-clock-seconds")
                        }
                        .offset(x: 0, y: -40)
                    }
                }
                
                Spacer()
                    .onDisappear {
                        tempClock = (userClock[0] * 60 + userClock[1]) * 100
                        running = false
                        buttonsDisabled = [false, true, true]
                        timer = [0, 0, 0]
                    }
                    .onAppear {
                        tempClock = (userClock[0] * 60 + userClock[1]) * 100
                    }
                    .onChange(of: userClock) { _ in
                        tempClock = (userClock[0] * 60 + userClock[1]) * 100
                    }
                
                Button(action: {
                    if tempClock == 0 {
                        tempClock = userClock[0] * 60 + userClock[1]
                    }
                    running = true
                    buttonsDisabled = [true, false, true]
                }, label: {
                    HStack {
                        Spacer()
                        Text("Start")
                        Spacer()
                    }
                })
                .buttonStyle(BorderedButtonStyle())
                .disabled(buttonsDisabled[0])
                .frame(width: 160)
                
                Button(action: {
                    running = false
                    buttonsDisabled = [false, true, false]
                }, label: {
                    HStack {
                        Spacer()
                        Text("Pause")
                        Spacer()
                    }
                })
                .buttonStyle(BorderedButtonStyle())
                .disabled(buttonsDisabled[1])
                .frame(width: 160)
                
                Button(action: {
                    tempClock = (userClock[0] * 60 + userClock[1]) * 100
                    running = false
                    buttonsDisabled = [false, true, true]
                    timer = [0, 0, 0]
                }, label: {
                    HStack {
                        Spacer()
                        Text("Reset")
                        Spacer()
                    }
                })
                .buttonStyle(BorderedButtonStyle())
                .disabled(buttonsDisabled[2])
                .frame(width: 160)
            }
        }
        .navigationTitle("Timer")
        .navigationBarTitleDisplayMode(.inline)
        .ignoresSafeArea(.keyboard)
    }
}

struct TimerView_Previews: PreviewProvider {
    @State var timer = [0, 0, 0]
    @State var buttonsDisabled = [false, true, true]
    @State var running = false
    @State var tempClock = 0
    @State var fontSize: CGFloat = 30
    @State var userClock = [2, 30]
    @State var notes: NSMutableAttributedString = NSMutableAttributedString(string: "Enter some text")
    
    static var previews: some View {
        TimerView(fontSize: .constant(30), userClock: .constant([0, 30]), notes: .constant(NSMutableAttributedString(string: "Enter some text")))
    }
}

extension UIPickerView {
    open override var intrinsicContentSize: CGSize {
        return CGSize(width: UIView.noIntrinsicMetric , height: 150)
    }
}

struct TextView: UIViewRepresentable {
    @Binding var attributedText: NSMutableAttributedString
    @Binding var fontSize: CGFloat
    @State var allowsEditingTextAttributes: Bool = false
    
    func makeUIView(context: Context) -> UITextView {
        let uiView = UITextView()
        uiView.font = UIFont(name: "AppleSDGothicNeo-Regular", size: fontSize)!
        uiView.delegate = context.coordinator
        return uiView
    }
    
    func updateUIView(_ uiView: UITextView, context: Context) {
        uiView.attributedText = attributedText
        uiView.allowsEditingTextAttributes = allowsEditingTextAttributes
        uiView.font = UIFont(name: "AppleSDGothicNeo-Regular", size: fontSize)!
        uiView.text = attributedText.string
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator($attributedText)
    }
     
    class Coordinator: NSObject, UITextViewDelegate {
        var text: Binding<NSMutableAttributedString>
     
        init(_ text: Binding<NSMutableAttributedString>) {
            self.text = text
        }
     
        func textViewDidChange(_ textView: UITextView) {
            self.text.wrappedValue = NSMutableAttributedString(string: textView.text)
        }
    }
}
