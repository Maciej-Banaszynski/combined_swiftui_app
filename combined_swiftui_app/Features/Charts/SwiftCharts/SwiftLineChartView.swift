//
//  SwiftLineChartView.swift
//  combined_swiftui_app
//
//  Created by Maciej Banaszyński on 20/11/2024.
//

import SwiftUI
import Charts

struct SwiftLineChartView: View {
    @State private var dataSize: DataSize = .fifty
    @State private var data: (data: [[DataPoint]], labels: [String]) = ( data: [], labels: [])
    
    var chartType: DGChartType
    
    var body: some View {
        VStack(spacing: 5) {
            Text(chartType.lineTitle).font(.headline)
            ChartDataSizePicker(dataSize: $dataSize, dataSizeValues: DataSize.lineChartValues, title: "Line Data Size") { loadData() }
            Chart {
                ForEach(data.data.indices, id: \.self) { index in
                    ForEach(data.data[index]) {
                        LineMark(
                            x: .value("Date", $0.x),
                            y: .value("Value", $0.y)
                        )
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
                        data = (data: [ChartsManager.generateChartData(dataSize: dataSize, byAdding: .hour)], labels: ["Line 1"])
                case .multi:
                        let line1 = ChartsManager.generateChartData(dataSize: dataSize, byAdding: .hour)
                        let line2 = ChartsManager.generateChartData(dataSize: dataSize, byAdding: .hour)
                        let line3 = ChartsManager.generateChartData(dataSize: dataSize, byAdding: .hour)
                        data = (data: [line1, line2, line3], labels: ["Line 1", "Line 2", "Line 3"])
            }
            
        }
    }
    
    private var areaBackground: Gradient {
        return Gradient(colors: [Color.accentColor, Color.accentColor.opacity(0.1)])
    }

    private var colors: [Color] { [.blue, .red, .green, .orange, .purple] }
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d\nhh:mm"
        return formatter
    }
}

#Preview {
    SwiftChartView()
}
