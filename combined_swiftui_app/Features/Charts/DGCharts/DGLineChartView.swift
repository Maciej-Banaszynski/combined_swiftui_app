//
//  DGLineChartView.swift
//  combined_swiftui_app
//
//  Created by Maciej Banaszyński on 20/11/2024.
//

import SwiftUI
import DGCharts
import Combine

struct DGLineChartView : View {
    @State private var dataSize: DataSize = .hundred
    @State private var data: (data: [[DataPoint]], labels: [String]) = ([],[])
    @State private var dataHasRendered: Bool = false
    
    var chartType: DGChartType
    
    var body: some View {
        VStack(spacing: 5) {
            Text(chartType.lineTitle).font(.headline)
            ChartDataSizePicker(dataSize: $dataSize, dataSizeValues: DataSize.lineChartValues, title: "Line Data Size") { loadData() }
            DGLineChartUIViewRepresentable(data: data.data, labels: data.labels, onRenderComplete: { dataHasRendered = true })
                .frame(height: 300)
        }
        .onAppear() { loadData() }
        
    }
    
    private func loadData()  {
        Task {
            switch chartType {
                case .single:
//                    _ = await MetricsManager.shared.trackAction(actionName: "Generate \(dataSize.rawValue) Data for single DGLineChart") {
                        data = (data: [ChartsManager.generateChartData(dataSize: dataSize, byAdding: .hour)], labels: ["Line 1"])
                        await waitForDataRender()
                        dataHasRendered = false
//                    }
                case .multi:
//                    await MetricsManager.shared.trackAction(actionName: "Generate \(dataSize.rawValue) Data for multiline DGLineChart") {
                        let line1 = ChartsManager.generateChartData(dataSize: dataSize, byAdding: .hour)
                        let line2 = ChartsManager.generateChartData(dataSize: dataSize, byAdding: .hour)
                        let line3 = ChartsManager.generateChartData(dataSize: dataSize, byAdding: .hour)
                        data = (data: [line1, line2, line3], labels: ["Line 1", "Line 2", "Line 3"])
                        await waitForDataRender()
                        dataHasRendered = false
//                    }
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

struct DGLineChartUIViewRepresentable: UIViewRepresentable {
    let data: [[DataPoint]]
    let labels: [String]
    var onRenderComplete: (() -> Void)?
    
    func makeUIView(context: Context) -> CustomLineChartView {
        let chartView = CustomLineChartView()
        
        chartView.chartDescription.enabled = false
        chartView.dragEnabled = true
        chartView.setScaleEnabled(true)
        chartView.pinchZoomEnabled = true
        chartView.scaleYEnabled = false
        
        chartView.xAxis.gridLineDashLengths = [10, 10]
        chartView.xAxis.gridLineDashPhase = 0
        chartView.xAxis.labelPosition = .bottom
        chartView.xAxis.valueFormatter = DateValueFormatter()
        
        chartView.legend.verticalAlignment = .top
        
        let leftAxis = chartView.leftAxis
        leftAxis.removeAllLimitLines()
        leftAxis.axisMaximum = 110
        leftAxis.axisMinimum = -10
        leftAxis.gridLineDashLengths = [5, 5]
        leftAxis.drawLimitLinesBehindDataEnabled = false
        
        chartView.rightAxis.enabled = false
        
        
        chartView.onRenderComplete = onRenderComplete
        
        return chartView
    }
    
    func updateUIView(_ uiView: CustomLineChartView, context: Context) {
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

class CustomLineChartView: LineChartView {
    var onRenderComplete: (() -> Void)?
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        onRenderComplete?()
    }
}

