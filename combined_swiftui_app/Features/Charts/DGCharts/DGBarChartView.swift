//
//  DGBarChartView.swift
//  combined_swiftui_app
//
//  Created by Maciej Banaszyński on 20/11/2024.
//

import SwiftUI
import DGCharts

struct DGBarChartView: View{
    @State private var dataSize: DataSize = .ten
    @State private var data: [DataPoint] = []
    
    var body: some View {
        VStack(spacing: 5) {
            Text("Bar Chart").font(.headline)
            ChartDataSizePicker(dataSize: $dataSize, dataSizeValues: DataSize.barChartValues, title: "Bar Data Size") { loadData() }
            DGBarChartUIViewRepresentable(data: data)
                .frame(height: 300)
        }
        .onAppear() { loadData() }
    }
    
    private func loadData() {
        Task {
            await MetricsManager.shared.trackAction(actionName: "GenerateAndPlot") {
                data = ChartsManager.generateChartData(dataSize: dataSize, byAdding: .month)
            }
        }
    }
}

struct DGBarChartUIViewRepresentable: UIViewRepresentable {
    let data: [DataPoint]
    
    func makeUIView(context: Context) -> BarChartView {
        let chartView = BarChartView()
        
        chartView.chartDescription.enabled = false
        chartView.dragEnabled = true
        chartView.setScaleEnabled(false)
        chartView.pinchZoomEnabled = false
        chartView.rightAxis.enabled = false
        
        let xAxis = chartView.xAxis
        xAxis.labelPosition = .bottom
        xAxis.granularity = 1
        xAxis.valueFormatter = MonthValueFormatter()
        xAxis.labelRotationAngle = -45
        
        let leftAxis = chartView.leftAxis
        leftAxis.axisMinimum = 0
        leftAxis.drawLimitLinesBehindDataEnabled = true
        
        return chartView
    }
    
    func updateUIView(_ uiView: BarChartView, context: Context) {
        let entries = data.enumerated().map { index, dataPoint in
            BarChartDataEntry(x: Double(index), y: dataPoint.y)
        }
        
        let dataSet = BarChartDataSet(entries: entries, label: "Monthly Values")
        dataSet.colors = [UIColor.systemBlue]
        dataSet.valueColors = [.black]
        
        uiView.data = BarChartData(dataSet: dataSet)
        
        uiView.notifyDataSetChanged()
    }
}
