//
//  MultipleChartsView.swift
//  combined_swiftui_app
//
//  Created by Maciej Banaszyński on 10/11/2024.
//


import SwiftUI
import Charts

struct MultipleChartsView: View {
    @State private var dataSize: DataSize = .oneThousand
    @State private var data: [DataPoint] = []
    
    var body: some View {
        VStack {
            Picker("Data Size", selection: $dataSize) {
                Text("100").tag(DataSize.hundred)
                Text("1,000").tag(DataSize.oneThousand)
                Text("10,000").tag(DataSize.tenThousand)
                Text("100,000").tag(DataSize.oneHundredThousand)
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
            .onChange(of: dataSize) { loadData() }
            
            ScrollView {
                VStack(spacing: 20) {
                    LineChart(data: data)
                    BarChart(data: data)
                    //                    PieChart(data: data)
                    ScatterChart(data: data)
                }
                .onAppear {
                    loadData()
                }
            }
        }
        .navigationTitle("Multiple Charts")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func loadData() {
        Task {
            await MetricsManager.shared.trackAction(actionName: "GenerateAndPlot") {
                let generatedData = ChartsManager.generateChartData(dataSize: dataSize)
                DispatchQueue.main.async {
                    _ = LineChart(data: generatedData)
                }
                data = generatedData
            }
        }
    }
    
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
