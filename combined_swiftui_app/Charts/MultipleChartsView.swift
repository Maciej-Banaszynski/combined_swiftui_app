//
//  MultipleChartsView.swift
//  combined_swiftui_app
//
//  Created by Maciej Banaszyński on 10/11/2024.
//


import SwiftUI
import Charts

struct MultipleChartsView: View {
    enum DataSize: Int {
        case houndred = 100,  oneThousand = 1000, tenThousand = 10000, oneHundredThousand = 100000
    }
    
    @State private var dataSize: DataSize = .oneThousand
    @State private var refreshInterval: TimeInterval = 60
    @State private var data: [DataPoint] = []
    @State private var timer: Timer?
    
    @State private var loadStartTime: Date?
    @State private var loadEndTime: Date?
    @State private var renderStartTime: Date?
    @State private var renderEndTime: Date?
    
    var body: some View {
        VStack {
            Picker("Data Size", selection: $dataSize) {
                Text("100").tag(DataSize.houndred)
                Text("1,000").tag(DataSize.oneThousand)
                Text("10,000").tag(DataSize.tenThousand)
                Text("100,000").tag(DataSize.oneHundredThousand)
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
            .onChange(of: dataSize) { _ in loadData() }
            
            Picker("Refresh Interval", selection: $refreshInterval) {
                Text("30s").tag(30.0)
                Text("60s").tag(60.0)
                Text("120s").tag(120.0)
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
            .onChange(of: refreshInterval) { interval in
                timer?.invalidate()
                startTimer()
            }
            
            ScrollView {
                VStack(spacing: 20) {
                    LineChart(data: data)
                    BarChart(data: data)
//                    PieChart(data: data)
                    ScatterChart(data: data)
                }
                .onAppear {
                    loadData()
                    startTimer()
                }
            }
        }
        .onDisappear {
            timer?.invalidate()
        }
        .navigationTitle("Multiple Charts")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func loadData() {
        loadStartTime = Date()
        
        DispatchQueue.global(qos: .userInitiated).async {
            let generatedData = (0..<dataSize.rawValue).map { _ in
                DataPoint(x: Double.random(in: 0...100), y: Double.random(in: 0...100))
            }
            
            DispatchQueue.main.async {
                self.data = generatedData
                loadEndTime = Date()
                logMetrics()
            }
        }
    }
    
    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: refreshInterval, repeats: true) { _ in
            loadData()
        }
    }
    
    private func logMetrics() {
        guard let loadStart = loadStartTime, let loadEnd = loadEndTime else { return }
        
        let loadDuration = loadEnd.timeIntervalSince(loadStart)
        print("Data Load Time: \(loadDuration) seconds for \(data.count) points")
        
        if let memoryUsage = getMemoryUsage() {
            print("Memory Usage: \(memoryUsage / 1024 / 1024) MB")
        }
        
        let cpuUsage = getCPUUsage()
        print("CPU Usage: \(cpuUsage)%")
        
//        let fps = getFPS()
//        print("Frame Rate (FPS): \(fps)")
        
        let uptime = ProcessInfo.processInfo.systemUptime
        print("System Uptime: \(uptime) seconds")
    }
    
    private func getMemoryUsage() -> UInt64? {
        var info = mach_task_basic_info()
        var count = mach_msg_type_number_t(MemoryLayout<mach_task_basic_info>.size) / 4
        
        let kerr: kern_return_t = withUnsafeMutablePointer(to: &info) {
            $0.withMemoryRebound(to: integer_t.self, capacity: 1) {
                task_info(mach_task_self_, task_flavor_t(MACH_TASK_BASIC_INFO), $0, &count)
            }
        }
        
        guard kerr == KERN_SUCCESS else { return nil }
        return info.resident_size
    }
    
    private func getCPUUsage() -> Double {
        var threads: thread_act_array_t?
        var threadCount = mach_msg_type_number_t()
        
        guard task_threads(mach_task_self_, &threads, &threadCount) == KERN_SUCCESS, let threads = threads else { return -1 }
        
        var totalUsage: Double = 0.0
        for i in 0..<Int(threadCount) {
            var info = thread_basic_info()
            var infoCount = mach_msg_type_number_t(THREAD_INFO_MAX)
            let result = withUnsafeMutablePointer(to: &info) {
                $0.withMemoryRebound(to: integer_t.self, capacity: Int(infoCount)) {
                    thread_info(threads[i], thread_flavor_t(THREAD_BASIC_INFO), $0, &infoCount)
                }
            }
            if result == KERN_SUCCESS {
                totalUsage += Double(info.cpu_usage) / Double(TH_USAGE_SCALE) * 100.0
            }
        }
        
        vm_deallocate(mach_task_self_, vm_address_t(bitPattern: threads), vm_size_t(Int(threadCount) * MemoryLayout<thread_act_t>.size))

        return totalUsage
    }
}

struct DataPoint: Identifiable {
    let id = UUID()
    let x: Double
    let y: Double
}

struct LineChart: View {
    let data: [DataPoint]
    
    var body: some View {
        Chart(data) {
            LineMark(x: .value("X", $0.x), y: .value("Y", $0.y))
        }
        .frame(height: 200)
        .padding()
    }
}

struct BarChart: View {
    let data: [DataPoint]
    
    var body: some View {
        Chart(data) {
            BarMark(x: .value("X", $0.x), y: .value("Y", $0.y))
        }
        .frame(height: 200)
        .padding()
    }
}

//struct PieChart: View {
//    let data: [DataPoint]
//    
//    var body: some View {
//        let categorizedData = categorizeData(data)
//        
//        Chart(categorizedData) {
//            SectorMark(
//                angle: .value("Value", $0.value),
//                innerRadius: 50,
//                outerRadius: 100
//            )
//            .foregroundStyle(by: .value("Category", $0.category))
//        }
//        .frame(height: 200)
//        .padding()
//    }
//    
//    private func categorizeData(_ data: [DataPoint]) -> [CategoryData] {
//        let bins = [
//            CategoryData(category: "Low (0-33)", value: data.filter { $0.y < 33 }.count),
//            CategoryData(category: "Mid (33-66)", value: data.filter { $0.y >= 33 && $0.y < 66 }.count),
//            CategoryData(category: "High (66-100)", value: data.filter { $0.y >= 66 }.count)
//        ]
//        
//        return bins
//    }
//}


struct CategoryData: Identifiable {
    let id = UUID()
    let category: String
    let value: Int
}

struct ScatterChart: View {
    let data: [DataPoint]
    
    var body: some View {
        Chart(data) {
            PointMark(x: .value("X", $0.x), y: .value("Y", $0.y))
        }
        .frame(height: 200)
        .padding()
    }
}



#Preview {
    MultipleChartsView()
}
