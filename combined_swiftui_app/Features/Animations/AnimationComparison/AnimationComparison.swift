//
//  AnimationComparisonSettings.swift
//  combined_swiftui_app
//
//  Created by Maciej Banaszyński on 22/11/2024.
//

import SwiftUI

struct AnimationComparisonScreen: View {
    @State private var isAnimating: Bool = false
    @State private var numElements: Int = 5
    @State private var animationSpeed: Double = 1.0
    @State private var isLoadingUsers: Bool = false
    @State private var listOfUsers: [User] = []
    
    var body: some View {
        ScrollView {
            VStack {
                VStack(spacing: 16) {
                    HStack {
                        Text("Number of Animations:")
                        Picker("", selection: $numElements) {
                            Text("5").tag(5)
                            Text("10").tag(10)
                            Text("20").tag(20)
                            Text("50").tag(50)
                            Text("100").tag(100)
                            Text("200").tag(200)
                            Text("500").tag(500)
                            Text("800").tag(800)
                            Text("1000").tag(1000)
                        }
                        .pickerStyle(MenuPickerStyle())
                    }
                    HStack {
                        Text("Animation Speed:")
                        Slider(value: $animationSpeed, in: 0.1...100.0, step: 0.1) {
                            Text("Speed")
                        }
                        .frame(height: 50)
                    }
                    Text("Speed: \(animationSpeed, specifier: "%.1f")x")
                        .font(.caption)
                    Toggle("Run Animations", isOn: $isAnimating)
                        .onChange(of: isAnimating) { newValue in
                            if newValue {
                                startMetricsTracking()
                            }
                        }
                }
                .padding()
                
                VStack(spacing: 8) {
                    HStack {
                        Text("Loaded Users: \(listOfUsers.count)")
                            .font(.headline)
                        if isLoadingUsers { ProgressView().padding(.leading, 8) }
                    }
                    
                    HStack {
                        ForEach(GeneratedUsersCount.allCases, id: \.self) { count in
                            Button(action: {
                                Task {
                                    await loadUsers(from: count)
                                }
                            }) {
                                Text("Load\n\(count.displayName)")
                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                                
                                    .background(isLoadingUsers ? Color.gray : Color.blue)
                                    .foregroundColor(.white)
                                    .cornerRadius(8)
                            }
                            .accessibilityIdentifier(count.accessibilityIdentifier)
                            .disabled(isLoadingUsers)
                        }
                        Button(action: {
                            Task {
                                listOfUsers = []
                            }
                        }) {
                            Text("Clear")
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                .background(isLoadingUsers ? Color.gray : Color.red)
                                .foregroundColor(.white)
                                .cornerRadius(8)
                            
                        }
                        .disabled(isLoadingUsers)
                    }
                    .frame(height: 60)
                }
                .padding()
                .padding(.bottom, 50)
                
                GeometryReader { geometry in
                    ZStack {
                        ForEach(0..<numElements, id: \.self) { index in
                            ExpensiveAnimatedCircle(
                                isAnimating: $isAnimating,
                                animationSpeed: $animationSpeed,
                                screenWidth: geometry.size.width,
                                screenHeight: geometry.size.height
                            )
                        }
                    }
                }
                .frame(height: 500)
            }
        }
        .navigationTitle("Animation Comparison")
    }
    
    private func startMetricsTracking() {
//        Task {
//            await MetricsManager.shared.trackAction(actionName: "Animation Comparison Metrics numElements:\(numElements) animationSpeed:\(animationSpeed)") {
//                while isAnimating {
//                    try? await Task.sleep(nanoseconds: UInt64(100_000_000))
//                }
//                return
//            }
//        }
    }
    
    private func loadUsers(from count: GeneratedUsersCount) async {
        isLoadingUsers = true
        defer { isLoadingUsers = false }
        
        do {
            try await loadUsersFromCSV(count: count)
        } catch {
            print("Error loading users: \(error)")
        }
    }
    
    private func loadUsersFromCSV(count: GeneratedUsersCount) async throws {
        guard let filePath = Bundle.main.path(forResource: "\(count.displayName)", ofType: "csv") else {
            throw NSError(domain: "FileError", code: 404, userInfo: [NSLocalizedDescriptionKey: "File not found"])
        }
        
        let csvString = try await Task.detached {
            try String(contentsOfFile: filePath, encoding: .utf8)
        }.value
        
        let rows = csvString.components(separatedBy: "\n").map { $0.components(separatedBy: ",") }.dropFirst()
        
        let users: [User] = await Task.detached {
            rows.compactMap { row in
                guard row.count >= 7 else { return nil }
                let user = User(
                    firstName: row[0].trimmingCharacters(in: .whitespacesAndNewlines),
                    lastName: row[1].trimmingCharacters(in: .whitespacesAndNewlines),
                    birthday: ISO8601DateFormatter().date(from: row[2].trimmingCharacters(in: .whitespacesAndNewlines)) ?? Date(),
                    address: row[3].trimmingCharacters(in: .whitespacesAndNewlines),
                    phoneNumber: row[4].trimmingCharacters(in: .whitespacesAndNewlines),
                    position: row[5].trimmingCharacters(in: .whitespacesAndNewlines),
                    company: row[6].trimmingCharacters(in: .whitespacesAndNewlines)
                )
                listOfUsers.append(user)
                return user
            }
        }.value
    }
}
struct ExpensiveAnimatedCircle: View {
    @Binding var isAnimating: Bool
    @Binding var animationSpeed: Double
    let screenWidth: CGFloat
    let screenHeight: CGFloat
    
    @State private var randomX: CGFloat = CGFloat.random(in: -150...150)
    @State private var randomY: CGFloat = CGFloat.random(in: -300...300)
    @State private var randomColor: Color = Color(
        red: Double.random(in: 0...1),
        green: Double.random(in: 0...1),
        blue: Double.random(in: 0...1)
    )
    
    @State private var offsetX: CGFloat = 0
    @State private var offsetY: CGFloat = 0
    
    var body: some View {
        Circle()
            .fill(randomColor)
            .frame(width: 20, height: 20)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .offset(x: offsetX, y: offsetY)
            .onAppear {
                startAnimation()
            }
            .onChange(of: isAnimating) { newValue in
                if newValue {
                    startAnimation()
                } else {
                    stopAnimation()
                }
            }
            .onChange(of: animationSpeed) { _ in
                if isAnimating {
                    startAnimation()
                }
            }
    }
    
    private func startAnimation() {
        guard isAnimating else { return }
        
        withAnimation(
            Animation.easeInOut(duration: (Double.random(in: 2.0...10.0) / animationSpeed))
                .repeatForever(autoreverses: true)
        ) {
            offsetX = randomX
            offsetY = randomY
        }
    }
    
    
    
    private func stopAnimation() {
        withAnimation(.default) {
            offsetX = 0
            offsetY = 0
        }
    }
}



#Preview {
    AnimationComparisonScreen()
}
