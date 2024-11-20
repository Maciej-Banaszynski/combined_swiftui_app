//
//  MetricsManager.swift
//  combined_swiftui_app
//
//  Created by Maciej Banaszyński on 19/11/2024.
//

import Foundation
import UIKit

class MetricsManager {
    static let shared = MetricsManager()
    
    private var lastTimestamp: CFTimeInterval = 0
    private var frameCount: Int = 0
    private var timer: Timer?
    
    private let metricsQueue = DispatchQueue(label: "com.metricsmanager.queue", qos: .background)
    
    @Published var appCPUUsage: Double = 0
    @Published var currentFPS: Int = 0
    
    private init() {
        UIDevice.current.isBatteryMonitoringEnabled = true
    }
    
    // MARK: - Start Monitoring
    func startMonitoring() {
        let displayLink = CADisplayLink(target: self, selector: #selector(updateFrameRate))
        displayLink.add(to: .main, forMode: .common)
        
        self.monitorAppCPUUsage()
    }
    
    
    // MARK: - Metrics
    var batteryLevel: Float {
        UIDevice.current.batteryLevel
    }
    
    var batteryState: String {
        switch UIDevice.current.batteryState {
            case .charging: return "Charging"
            case .full: return "Full"
            default: return ""
        }
    }
    
    var freeDiskSpaceMB: Int64 {
        let fileManager = FileManager.default
        if let attributes = try? fileManager.attributesOfFileSystem(forPath: NSHomeDirectory()),
           let freeSpace = attributes[.systemFreeSize] as? NSNumber {
            return freeSpace.int64Value / (1024 * 1024) // MB
        }
        return -1
    }
    
    var totalDiskSpaceMB: Int64 {
        let fileManager = FileManager.default
        if let attributes = try? fileManager.attributesOfFileSystem(forPath: NSHomeDirectory()),
           let totalSpace = attributes[.systemSize] as? NSNumber {
            return totalSpace.int64Value / (1024 * 1024) // MB
        }
        return -1
    }
    
    var freeDiskPercentage: Double {
        let freeSpace = freeDiskSpaceMB
        let totalSpace = totalDiskSpaceMB
        return totalSpace > 0 ? (Double(freeSpace) / Double(totalSpace)) * 100 : -1
    }
    
    var memoryUsageMB: Double {
        var info = mach_task_basic_info()
        var count = mach_msg_type_number_t(MemoryLayout<mach_task_basic_info>.size) / 4
        let result = withUnsafeMutablePointer(to: &info) {
            $0.withMemoryRebound(to: Int32.self, capacity: 1) {
                task_info(mach_task_self_, task_flavor_t(MACH_TASK_BASIC_INFO), $0, &count)
            }
        }
        if result == KERN_SUCCESS {
            return Double(info.resident_size) / 1024 / 1024 // MB
        }
        return -1
    }
    
    var totalMemoryMB: Double {
        let physicalMemory = ProcessInfo.processInfo.physicalMemory
        return Double(physicalMemory) / 1024 / 1024
    }
    
    var freeMemoryPercentage: Double {
        let totalMemory = totalMemoryMB
        let usedMemory = memoryUsageMB
        return totalMemory > 0 ? ((totalMemory - usedMemory) / totalMemory) * 100 : -1
    }
    
    var getAppCPUUsage: Double {
        var threadsList: thread_act_array_t?
        var threadCount: mach_msg_type_number_t = 0
        
        guard task_threads(mach_task_self_, &threadsList, &threadCount) == KERN_SUCCESS, let threads = threadsList else {
            return -1
        }
        
        var totalCPUUsage: Double = 0
        
        for i in 0..<Int(threadCount) {
            var threadInfo = thread_basic_info()
            var threadInfoCount = mach_msg_type_number_t(THREAD_INFO_MAX)
            
            let result = withUnsafeMutablePointer(to: &threadInfo) {
                $0.withMemoryRebound(to: integer_t.self, capacity: Int(threadInfoCount)) {
                    thread_info(threads[i], thread_flavor_t(THREAD_BASIC_INFO), $0, &threadInfoCount)
                }
            }
            
            guard result == KERN_SUCCESS else { continue }
            
            if threadInfo.flags & TH_FLAGS_IDLE == 0 {
                totalCPUUsage += Double(threadInfo.cpu_usage) / Double(TH_USAGE_SCALE) * 100
            }
        }
        
        vm_deallocate(mach_task_self_, vm_address_t(bitPattern: threads), vm_size_t(Int(threadCount) * MemoryLayout<thread_t>.stride))
        
        return totalCPUUsage
    }
    
    
    private func monitorAppCPUUsage() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.metricsQueue.async {
                let cpuUsage = self?.getAppCPUUsage ?? 0
                DispatchQueue.main.async {
                    self?.appCPUUsage = cpuUsage
                }
            }
        }
    }
    
    @objc private func updateFrameRate(displayLink: CADisplayLink) {
            if lastTimestamp == 0 {
                lastTimestamp = displayLink.timestamp
                return
            }
            
            let elapsed = displayLink.timestamp - lastTimestamp
            frameCount += 1
            
            if elapsed >= 1.0 {
                let fps = Double(frameCount) / elapsed
                currentFPS = Int(round(fps))
                frameCount = 0
                lastTimestamp = displayLink.timestamp
            }
    }
    
    // MARK: - Track Action
    func trackAction<T>(actionName: String, action: @escaping () -> T) async {
        let startTime = Date()
        let csvFileName = "\(actionName)_\(formatDate(date: startTime)).csv"
        let csvFilePath = createCSVFile(name: csvFileName)
        var metricsData: [[String]] = [["Time", "Battery Level", "Battery State", "Free Disk Space (MB)", "Free Disk (%)", "Memory Usage (MB)", "Free Memory (%)", "CPU Usage (%)", "FPS"]]
        
        let timerQueue = DispatchQueue(label: "com.trackAction.timer", qos: .background)
        let timer = DispatchSource.makeTimerSource(queue: timerQueue)
        
        timer.schedule(deadline: .now(), repeating: 1.0)
        timer.setEventHandler {
            let metrics = self.collectMetrics()
            let timestamp = Date().timeIntervalSince(startTime)
            let row: [String] = [
                String(format: "%.2f", timestamp),
                "\(metrics["batteryLevel"] ?? "")",
                "\(metrics["batteryState"] ?? "")",
                "\(metrics["freeDiskSpaceMB"] ?? "")",
                "\(metrics["freeDiskPercentage"] ?? "")",
                "\(metrics["memoryUsageMB"] ?? "")",
                "\(metrics["freeMemoryPercentage"] ?? "")",
                "\(metrics["cpuUsage"] ?? "")",
                "\(metrics["fps"] ?? "")"
            ]
            print(row)
            metricsData.append(row)
        }
        timer.resume()
        
        await withTaskGroup(of: Void.self) { taskGroup in
            taskGroup.addTask {
                _ = action()
            }
        }
        
        timer.cancel()
        
        saveMetricsToCSV(metricsData, filePath: csvFilePath)
    }

    private func collectMetrics() -> [String: Any] {
        return [
            "batteryLevel": batteryLevel,
            "batteryState": batteryState,
            "freeDiskSpaceMB": freeDiskSpaceMB,
            "freeDiskPercentage": freeDiskPercentage,
            "memoryUsageMB": memoryUsageMB,
            "freeMemoryPercentage": freeMemoryPercentage,
            "cpuUsage": getAppCPUUsage,
            "fps": currentFPS
        ]
    }
    
    private func saveMetricsToCSV(_ metrics: [[String]], filePath: String) {
        let csvContent = metrics.map { $0.joined(separator: ",") }.joined(separator: "\n")
        do {
            try csvContent.write(toFile: filePath, atomically: true, encoding: .utf8)
            print("Metrics saved to \(filePath)")
        } catch {
            print("Failed to save metrics to CSV: \(error)")
        }
    }
    
    private func createCSVFile(name: String) -> String {
        let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let filePath = documentDirectory.appendingPathComponent(name).path
        FileManager.default.createFile(atPath: filePath, contents: nil, attributes: nil)
        return filePath
    }
    
    private func formatDate(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd_HH-mm-ss"
        return formatter.string(from: date)
    }

}

