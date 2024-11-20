//
//  LiveMetricsViewModel.swift
//  combined_swiftui_app
//
//  Created by Maciej Banaszyński on 19/11/2024.
//

import Foundation

class LiveMetricsViewModel: ObservableObject {
    @Published var coreUsage: String = "0"
    @Published var cpuUsage: String = "0"
    @Published var memoryUsage: String = "0"
    @Published var freeMemoryPercentage: String = "0"
    @Published var diskUsage: String = "0"
    @Published var freeDiskPercentage: String = "0"
    @Published var batteryLevel: String = "0"
    @Published var batteryState: String = ""
    @Published var frameRate: String = "0"
    
    private var timer: Timer?
    private let manager = MetricsManager.shared
    
    func startUpdating() {
        manager.startMonitoring()
        
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            self.updateMetrics()
        }
    }
    
    func stopUpdating() {
        timer?.invalidate()
        timer = nil
    }
    
    private func updateMetrics() {
        DispatchQueue.main.async {
            self.cpuUsage = String(format: "%.2f%", self.manager.getAppCPUUsage)
            self.memoryUsage = String(format: "%.2f MB", self.manager.memoryUsageMB)
            self.freeMemoryPercentage = String(format: "%.2f%%", self.manager.freeMemoryPercentage)
            self.diskUsage = String(format: "%.2f MB", Double(self.manager.freeDiskSpaceMB))
            self.freeDiskPercentage = String(format: "%.2f%%", self.manager.freeDiskPercentage)
            self.batteryLevel = String(format: "%.0f", self.manager.batteryLevel * 100)
            self.batteryState = self.manager.batteryState
            self.frameRate = "\(self.manager.currentFPS)"
        }
    }
}

