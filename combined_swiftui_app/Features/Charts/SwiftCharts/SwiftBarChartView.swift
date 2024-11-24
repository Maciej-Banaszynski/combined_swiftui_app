//
//  SwiftBarChartView.swift
//  combined_swiftui_app
//
//  Created by Maciej Banaszyński on 20/11/2024.
//

import SwiftUI
import Charts

struct SwiftBarChartView: View {
    @State private var dataSize: DataSize = .hundred
    @State private var data: (data: [[DataPoint]], labels: [String]) = ( data: [], labels: [])
    
    private var areaBackground: Gradient {
        return Gradient(colors: [Color.accentColor, Color.accentColor.opacity(0.1)])
    }
    
    var chartType: DGChartType
    
    var body: some View {
        VStack(spacing: 5) {
            Text(chartType.lineTitle).font(.headline)
            ChartDataSizePicker(dataSize: $dataSize, dataSizeValues: DataSize.barChartValues, title: "Bar Data Size") { loadData() }
            Chart {
                ForEach(data.data.indices, id: \.self) { index in
                    ForEach(data.data[index]) {
                        BarMark(
                            x: .value("Date", $0.x),
                            y: .value("Value", $0.y)
                        )
                        .foregroundStyle(by: .value("Product Category", index))
                        .interpolationMethod(.catmullRom)
                        .foregroundStyle(colors[index])
                    }
                    
                    
                }
            }
            .chartXAxis {
                AxisMarks { value in
                    if let dateValue = value.as(Date.self) {
                        AxisValueLabel {
                            Text(dateFormatter.string(from: dateValue))
                                .multilineTextAlignment(.center)
                        }
                    }
                }
            }
            .frame(height: 300)
        }
        .onAppear() { loadData() }
    }
    
    private func loadData()  {
        Task {
            switch chartType {
                case .single:
//                    await MetricsManager.shared.trackAction(actionName: "Generate \(dataSize.rawValue) Data for single SwiftBarChart") {
                        data = (data: [ChartsManager.generateChartData(dataSize: dataSize, byAdding: .month)], labels: ["Line 1"])
                        
//                    }
                case .multi:
//                    await MetricsManager.shared.trackAction(actionName: "Generate \(dataSize.rawValue) Data for multiline SwiftBarChart") {
                        let line1 = ChartsManager.generateChartData(dataSize: dataSize, byAdding: .month)
                        let line2 = ChartsManager.generateChartData(dataSize: dataSize, byAdding: .month)
                        let line3 = ChartsManager.generateChartData(dataSize: dataSize, byAdding: .month)
                        print("HERE l1:\(line1), l2:\(line2), l3:\(line3)")
                        data = (data: [line1, line2, line3], labels: ["Line 1", "Line 2", "Line 3"])
//                    }
            }
            
        }
    }
    
    
    private var colors: [Color] { [.blue, .red, .green, .orange, .purple] }
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d\nyyyy"
        return formatter
    }
}

#Preview {
    SwiftChartView()
}
