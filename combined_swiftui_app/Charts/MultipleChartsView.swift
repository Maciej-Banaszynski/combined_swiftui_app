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