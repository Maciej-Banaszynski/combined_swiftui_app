//
//  LiveMetricsView.swift
//  combined_swiftui_app
//
//  Created by Maciej Banaszyński on 19/11/2024.
//

import SwiftUI

struct LiveMetricsView: View {
    @StateObject private var metricsViewModel = LiveMetricsViewModel()
    
    @State private var currentPosition: CGSize = .zero
    @State private var dragOffset: CGSize = .zero
    
    var body: some View {
        HStack {
            VStack {
                VStack(alignment: .leading, spacing: 2) {
                    MetricsRow(title: "CPU: ", value: "\(metricsViewModel.cpuUsage)%")
                    MetricsRow(title: "Mem: ", value: "\(metricsViewModel.memoryUsage)")
                    MetricsRow(title: "Free Mem: ", value: "\(metricsViewModel.freeMemoryPercentage)")
                    MetricsRow(title: "Disk: ", value: "\(metricsViewModel.diskUsage)")
                    MetricsRow(title: "Free Disk: ", value: "\(metricsViewModel.freeDiskPercentage)")
                    MetricsRow(title: "Bat: ", value: "\(metricsViewModel.batteryLevel)%")
                    MetricsRow(title: "FPS: ", value: "\(metricsViewModel.frameRate)")
                }
                .padding(8)
                .background(Color.black.opacity(0.7))
                .foregroundColor(.white)
                .cornerRadius(10)
                .shadow(radius: 5)
                .offset(x: currentPosition.width + dragOffset.width,
                        y: currentPosition.height + dragOffset.height)
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            dragOffset = value.translation
                        }
                        .onEnded { _ in
                            currentPosition.width += dragOffset.width
                            currentPosition.height += dragOffset.height
                            dragOffset = .zero
                        }
                )
                .onAppear {
                    metricsViewModel.startUpdating()
                }
                .onDisappear {
                    metricsViewModel.stopUpdating()
                }
                .padding()
                Spacer()
            }
            Spacer()
        }
    }
}

struct MetricsRow: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text(title)
                .font(.caption)
                .bold()
            Text(value)
                .font(.caption2)
        }
    }
}


#Preview {
    ZStack {
        Color.blue
            .ignoresSafeArea()
        LiveMetricsView()
    }
}

