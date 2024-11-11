//
//  BouncingBallsView.swift
//  combined_swiftui_app
//
//  Created by Maciej Banaszyński on 11/11/2024.
//

import SwiftUI

struct Ball: Identifiable {
    let id = UUID()
    var position: CGPoint
    var velocity: CGSize
    var color: Color
    var lastBounceTime: Date = Date()
}

struct BouncingBallsView: View {
    @State private var balls: [Ball] = []
    @State private var allowNewBalls = true
    @State private var allowAcceleration = false
    @State private var initialSpeed: CGFloat = 5.0
    @State private var showSettings = false
    @State private var animationStarted = false
    @State private var isPaused = false
    let ballDiameter: CGFloat = 15
    let timer = Timer.publish(every: 0.016, on: .main, in: .common).autoconnect()
    
    var body: some View {
        VStack {
            if animationStarted {
                Text("Number of Balls: \(balls.count)")
                    .font(.headline)
                
                GeometryReader { geometry in
                    let boxWidth = geometry.size.width * 0.95
                    let boxHeight = geometry.size.height * 0.95
                    let boxX = (geometry.size.width - boxWidth) / 2
                    let boxY = (geometry.size.height - boxHeight) / 2
                    
                    ZStack {
                        ForEach(balls) { ball in
                            Circle()
                                .fill(ball.color)
                                .frame(width: ballDiameter, height: ballDiameter)
                                .position(ball.position)
                        }
                    }
                    .frame(width: boxWidth, height: boxHeight)
                    .onReceive(timer) { _ in
                        if !isPaused {
                            updateBalls(in: CGRect(x: boxX, y: boxY, width: boxWidth, height: boxHeight))
                        }
                    }
                }
                
                HStack {
                    Button(action: togglePause) {
                        Image(systemName: isPaused ? "play.fill" : "pause.fill")
                            .resizable()
                            .frame(width: 50, height: 50)
                            .padding()
                            .background(Color.black.opacity(0.7))
                            .foregroundColor(.white)
                            .clipShape(Circle())
                    }
                    
                    Spacer()
                    
                    Button(action: resetAnimation) {
                        Image(systemName: "arrow.clockwise")
                            .resizable()
                            .frame(width: 50, height: 50)
                            .padding()
                            .background(Color.black.opacity(0.7))
                            .foregroundColor(.white)
                            .clipShape(Circle())
                    }
                }
                .padding(.horizontal)
            } else {
                Button(action: startAnimation) {
                    Image(systemName: "play.circle.fill")
                        .resizable()
                        .frame(width: 100, height: 100)
                        .foregroundColor(.blue)
                }
            }
        }
        .navigationTitle("Bouncing Balls")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(trailing: Button(action: {
            showSettings = true
        }) {
            Image(systemName: "gearshape.fill")
                .imageScale(.large)
        })
        .sheet(isPresented: $showSettings) {
            SettingsView(initialSpeed: $initialSpeed, allowNewBalls: $allowNewBalls, allowAcceleration: $allowAcceleration, applySettings: applySettings)
        }
    }
    
    private func startAnimation() {
        balls = [
            Ball(position: CGPoint(x: 40, y: 40), velocity: CGSize(width: initialSpeed, height: initialSpeed), color: .red)
        ]
        animationStarted = true
        isPaused = false
    }
    
    private func togglePause() {
        isPaused.toggle()
    }
    
    private func resetAnimation() {
        balls = [
            Ball(position: CGPoint(x: 40, y: 40), velocity: CGSize(width: initialSpeed, height: initialSpeed), color: .red)
        ]
        isPaused = false
    }
    
    private func updateBalls(in box: CGRect) {
        let ballDiameter: CGFloat = ballDiameter
        let radius = ballDiameter / 2
        
        for i in 0..<balls.count {
            var ball = balls[i]
            let currentTime = Date()
            
            ball.position.x += ball.velocity.width
            ball.position.y += ball.velocity.height
            
            if ball.position.x - radius <= box.minX || ball.position.x + radius >= box.maxX {
                ball.velocity.width *= allowAcceleration ? -1.1 : -1
                ball.position.x = min(max(ball.position.x, box.minX + radius), box.maxX - radius)
                
                if currentTime.timeIntervalSince(ball.lastBounceTime) > 0.3 {
                    ball.lastBounceTime = currentTime
                    if allowNewBalls { addNewBall(at: ball.position) }
                }
            }
            
            if ball.position.y - radius <= box.minY || ball.position.y + radius >= box.maxY {
                ball.velocity.height *= allowAcceleration ? -1.1 : -1
                ball.position.y = min(max(ball.position.y, box.minY + radius), box.maxY - radius)
                
                if currentTime.timeIntervalSince(ball.lastBounceTime) > 0.3 {
                    ball.lastBounceTime = currentTime
                    if allowNewBalls { addNewBall(at: ball.position) }
                }
            }
            
            balls[i] = ball
        }
    }
    
    private func addNewBall(at position: CGPoint) {
        let newVelocity = CGSize(width: CGFloat.random(in: -10...10), height: CGFloat.random(in: -10...10))
        let newColor = Color(hue: Double.random(in: 0...1), saturation: 1, brightness: 1)
        balls.append(Ball(position: position, velocity: newVelocity, color: newColor))
    }
    
    private func applySettings() {
        resetAnimation()
        showSettings = false
    }
}

struct SettingsView: View {
    @Binding var initialSpeed: CGFloat
    @Binding var allowNewBalls: Bool
    @Binding var allowAcceleration: Bool
    let applySettings: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Settings")
                .font(.headline)
            
            VStack(alignment: .leading) {
                Text("Initial Ball Speed")
                Slider(value: $initialSpeed, in: 1...20, step: 1)
                    .padding(.horizontal)
                Text("Current Speed: \(Int(initialSpeed))")
                    .font(.caption)
            }
            
            Toggle("Create new balls on bounce", isOn: $allowNewBalls)
                .padding()
            
            Toggle("Enable acceleration on bounce", isOn: $allowAcceleration)
                .padding()
            
            Button(action: {
                applySettings()
            }) {
                Text("Save & Apply")
                    .font(.headline)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()
            
            Spacer()
        }
        .padding()
    }
}

#Preview {
    BouncingBallsView()
}
