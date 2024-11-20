//
//  DGLineChartView.swift
//  combined_swiftui_app
//
//  Created by Maciej Banaszyński on 20/11/2024.
//

import SwiftUI
import DGCharts

enum DGLineChartType {
    case singleLine, multiLine
        
    var viewTitle: String {
        switch self {
            case .singleLine: return "Single Line Chart"
            case .multiLine: return "Multi Line Chart"
        }
    }
}

struct DGLineChartView : View {
    @State private var dataSize: DataSize = .hundred
    @State private var data: (data: [[DataPoint]], labels: [String]) = ([],[])
    
    var chartType: DGLineChartType
    
    var body: some View {
        VStack(spacing: 5) {
            Text(chartType.viewTitle).font(.headline)
            ChartDataSizePicker(dataSize: $dataSize, dataSizeValues: DataSize.lineChartValues, title: "Line Data Size") { loadData() }
            DGLineChartUIViewRepresentable(data: data.data, labels: data.labels)
                .frame(height: 300)
        }
        .onAppear() { loadData() }
    }
    
    private func loadData()  {
        Task {
            switch chartType {
                case .singleLine:
                    await MetricsManager.shared.trackAction(actionName: "Generate Data for single DGLineChart") {
                        data = (data: [ChartsManager.generateChartData(dataSize: dataSize, byAdding: .hour)], labels: ["Line 1"])
                    }
                case .multiLine:
                    await MetricsManager.shared.trackAction(actionName: "Generate Data for multiline DGLineChart") {
                        let line1 = ChartsManager.generateChartData(dataSize: dataSize, byAdding: .hour)
                        let line2 = ChartsManager.generateChartData(dataSize: dataSize, byAdding: .hour)
                        let line3 = ChartsManager.generateChartData(dataSize: dataSize, byAdding: .hour)
                        data = (data: [line1, line2, line3], labels: ["Line 1", "Line 2", "Line 3"])
                    }
            }
            
        }
    }
}

struct DGLineChartUIViewRepresentable: UIViewRepresentable {
    let data: [[DataPoint]]
    let labels: [String] 
    
    func makeUIView(context: Context) -> LineChartView {
        let chartView = LineChartView()
        
        chartView.chartDescription.enabled = false
        chartView.dragEnabled = true
        chartView.setScaleEnabled(true)
        chartView.pinchZoomEnabled = true
        chartView.scaleYEnabled = false
        
        chartView.xAxis.gridLineDashLengths = [10, 10]
        chartView.xAxis.gridLineDashPhase = 0
        chartView.xAxis.labelPosition = .bottom
        chartView.xAxis.valueFormatter = DateValueFormatter()
        
        let leftAxis = chartView.leftAxis
        leftAxis.removeAllLimitLines()
        leftAxis.axisMaximum = 110
        leftAxis.axisMinimum = -10
        leftAxis.gridLineDashLengths = [5, 5]
        leftAxis.drawLimitLinesBehindDataEnabled = false
        
        chartView.rightAxis.enabled = false
        
        return chartView
    }
    
    func updateUIView(_ uiView: LineChartView, context: Context) {
        let dataSets = data.enumerated().map { index, dataPoints in
            let entries = dataPoints.map { ChartDataEntry(x: $0.x.timeIntervalSince1970, y: $0.y) }
            let dataSet = LineChartDataSet(entries: entries, label: labels[index])
            
            let lineColors: [UIColor] = [.systemBlue, .systemRed, .systemGreen, .systemOrange, .systemPurple]
            dataSet.colors = [lineColors[index % lineColors.count]]
            dataSet.circleColors = [.cyan]
            dataSet.circleRadius = 0
            dataSet.valueColors = [.clear]
            dataSet.lineWidth = 2.0
            return dataSet
        }
        
        uiView.data = LineChartData(dataSets: dataSets)
    }
}


