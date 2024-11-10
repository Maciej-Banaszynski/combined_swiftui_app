//
//  MultipleAnimationsView.swift
//  combined_swiftui_app
//
//  Created by Maciej Banaszyński on 10/11/2024.
//

import SwiftUI
import os.signpost

let performanceLog = OSLog(subsystem: Bundle.main.bundleIdentifier ?? "com.example", category: "performance")

struct MultipleAnimationsView: View {
    @State private var opacity: Double = 0.0
    @State private var scale: CGFloat = 0.5
    @State private var rotation: Angle = .degrees(0)
    @State private var offsetX: CGFloat = -100
    @State private var loadingTime: CFAbsoluteTime = 0
    @State private var launchTime: CFAbsoluteTime = 0
    
    
    @State private var duration: Double = 1.0
    @State private var delay: Double = 0.0
    @State private var springResponse: Double = 0.5
    @State private var springDamping: Double = 0.6
    
    var body: some View {
        VStack {
            ScrollView {
                VStack(spacing: 100) {
                    Text("Opacity Animation")
                        .opacity(opacity)
                        .onAppear {
                            withAnimation(Animation.easeInOut(duration: duration).delay(delay)) {
                                opacity = 1.0
                            }
                        }
                    Text("Scale Animation")
                        .scaleEffect(scale)
                        .onAppear {
                            withAnimation(.spring(response: springResponse, dampingFraction: springDamping).delay(delay)) {
                                scale = 1.0
                            }
                        }
                    Text("Rotation Animation")
                        .rotationEffect(rotation)
                        .onAppear {
                            withAnimation(Animation.linear(duration: duration).delay(delay)) {
                                rotation = .degrees(360)
                            }
                        }
                    Text("Offset Animation")
                        .offset(x: offsetX)
                        .onAppear {
                            withAnimation(Animation.easeOut(duration: duration).delay(delay)) {
                                offsetX = 0
                            }
                        }
                }
                .padding()
            }
            
            Divider().padding()
            
            VStack {
                Text("Animation Controls")
                    .font(.headline)
                HStack {
                    Text("Duration: \(String(format: "%.2f", duration))s")
                    Slider(value: $duration, in: 0.1...5.0, step: 0.1, onEditingChanged: { _ in runAnimations() })
                }
                HStack {
                    Text("Delay: \(String(format: "%.2f", delay))s")
                    Slider(value: $delay, in: 0.0...3.0, step: 0.1, onEditingChanged: { _ in runAnimations() })
                }
                HStack {
                    Text("Spring Response: \(String(format: "%.2f", springResponse))s")
                    Slider(value: $springResponse, in: 0.1...2.0, step: 0.1, onEditingChanged: { _ in runAnimations() })
                }
                HStack {
                    Text("Spring Damping: \(String(format: "%.2f", springDamping))")
                    Slider(value: $springDamping, in: 0.1...1.0, step: 0.1, onEditingChanged: { _ in runAnimations() })
                }
            }
            .padding()
        }
        .onAppear {
            runAnimations()
        }
        .navigationTitle("Multiple Animations")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func runAnimations() {
        opacity = 0.0
        scale = 0.5
        rotation = .degrees(0)
        offsetX = -100
        
        let loadingStart = CFAbsoluteTimeGetCurrent()
        DispatchQueue.main.async {
            loadingTime = CFAbsoluteTimeGetCurrent() - loadingStart
            os_signpost(.event, log: performanceLog, name: "View Loaded", "Load Time: %lf", loadingTime)
        }
        
        withAnimation(Animation.easeInOut(duration: duration).delay(delay)) {
            opacity = 1.0
        }
        
        withAnimation(.spring(response: springResponse, dampingFraction: springDamping).delay(delay)) {
            scale = 1.0
        }
        
        withAnimation(Animation.linear(duration: duration).delay(delay)) {
            rotation = .degrees(360)
        }
        
        withAnimation(Animation.easeOut(duration: duration).delay(delay)) {
            offsetX = 0
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + delay + duration) {
            launchTime = CFAbsoluteTimeGetCurrent() - loadingStart
            os_signpost(.event, log: performanceLog, name: "View Launched", "Launch Time: %lf", launchTime)
        }
    }
}



#Preview {
    MultipleAnimationsView()
}


