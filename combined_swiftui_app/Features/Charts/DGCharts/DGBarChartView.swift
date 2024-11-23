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
    @State private var data: (data: [[DataPoint]], labels: [String]) = ([],[])
    @State private var dataHasRendered: Bool = false
    
    var chartType: DGChartType
    
    var body: some View {
        VStack(spacing: 5) {
            Text(chartType.barTitle).font(.headline)
            ChartDataSizePicker(dataSize: $dataSize, dataSizeValues: DataSize.barChartValues, title: "Bar Data Size") { loadData() }
            DGBarChartUIViewRepresentable(data: data.data, labels: data.labels, onRenderComplete: { dataHasRendered = true })
                .frame(height: 300)
        }
        .onAppear() { loadData() }
    }
    
    private func loadData() {
        Task {
            switch chartType {
                case .single:
                    await MetricsManager.shared.trackAction(actionName: "Generate \(dataSize.rawValue) Data for single DGBarChart") {
                        data = (data: [ChartsManager.generateChartData(dataSize: dataSize, byAdding: .hour)], labels: ["Line 1"])
                        await waitForDataRender()
                        dataHasRendered = false
                    }
                case .multi:
                    await MetricsManager.shared.trackAction(actionName: "Generate \(dataSize.rawValue) Data for multiline DGBarChart") {
                        let line1 = ChartsManager.generateChartData(dataSize: dataSize, byAdding: .hour)
                        let line2 = ChartsManager.generateChartData(dataSize: dataSize, byAdding: .hour)
                        let line3 = ChartsManager.generateChartData(dataSize: dataSize, byAdding: .hour)
                        data = (data: [line1, line2, line3], labels: ["Bar 1", "Bar 2", "Bar 3"])
                        await waitForDataRender()
                        dataHasRendered = false
                    }
            }
            
        }
    }
    
    private func waitForDataRender() async {
        await withCheckedContinuation { continuation in
            let timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
                if dataHasRendered {
                    timer.invalidate()
                    continuation.resume()
                }
            }
            RunLoop.main.add(timer, forMode: .common)
        }
    }
}

struct DGBarChartUIViewRepresentable: UIViewRepresentable {
    let data: [[DataPoint]]
    let labels: [String]
    var onRenderComplete: (() -> Void)?
    
    func makeUIView(context: Context) -> CustomBarChartView {
        let chartView = CustomBarChartView()
        
        chartView.chartDescription.enabled = false
        chartView.dragEnabled = true
        chartView.setScaleEnabled(false)
        chartView.pinchZoomEnabled = false
        chartView.rightAxis.enabled = false
        
        chartView.legend.verticalAlignment = .top
        
        let xAxis = chartView.xAxis
        xAxis.labelPosition = .bottom
        xAxis.granularity = 1
        xAxis.valueFormatter = MonthValueFormatter()
        xAxis.labelRotationAngle = -45
        
        let leftAxis = chartView.leftAxis
        leftAxis.axisMinimum = 0
        leftAxis.drawLimitLinesBehindDataEnabled = true
        
        chartView.onRenderComplete = onRenderComplete
        
        return chartView
    }
    
    func updateUIView(_ uiView: CustomBarChartView, context: Context) {
        
        let dataSets: [BarChartDataSet] = data.enumerated().map { index, groupData in
            let entries = groupData.enumerated().map { innerIndex, dataPoint in
                BarChartDataEntry(x: Double(innerIndex), y: dataPoint.y)
            }
            let dataSet = BarChartDataSet(entries: entries, label: labels[index])
            
            
            let colors: [UIColor] = [.systemBlue, .systemRed, .systemGreen, .systemOrange, .systemPurple]
            dataSet.colors = [colors[index % colors.count]]
            dataSet.valueColors = [.black]
            return dataSet
        }
        
        let chartData = BarChartData(dataSets: dataSets)
        
        chartData.barWidth = 0.2
        let groupSpace = 0.3
        let barSpace = 0.05
        chartData.groupBars(fromX: 0, groupSpace: groupSpace, barSpace: barSpace)
        
        uiView.data = chartData
        
        let groupCount = data.first?.count ?? 0
        uiView.xAxis.axisMinimum = -0.5
        uiView.xAxis.axisMaximum = Double(groupCount) * (chartData.groupWidth(groupSpace: groupSpace, barSpace: barSpace))
        
        uiView.notifyDataSetChanged()
    }
}

class CustomBarChartView: BarChartView {
    var onRenderComplete: (() -> Void)?
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        onRenderComplete?()
    }
}
