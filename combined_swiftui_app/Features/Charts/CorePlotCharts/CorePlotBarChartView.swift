//
//  CorePlotBarChartView.swift
//  combined_swiftui_app
//
//  Created by Maciej Banaszyński on 20/11/2024.
//

import SwiftUI
import CorePlot

struct CorePlotBarChartView: View {
    @State private var dataSize: DataSize = .five
    @State private var data: (data: [[DataPoint]], labels: [String]) = ([],[])
    @State private var dataHasRendered: Bool = false
    
    var chartType: DGChartType
    
    var body: some View {
        VStack(spacing: 5) {
            Text(chartType.barTitle).font(.headline)
            ChartDataSizePicker(dataSize: $dataSize, dataSizeValues: DataSize.barChartValues, title: "Bar Data Size") { loadData() }
            CorePlotBarChartUIViewRepresentable(data: data.data, labels: data.labels, onRenderComplete: { dataHasRendered = true })
                .frame(height: 300)
        }
        .onAppear() { loadData() }
    }
    
    private func loadData()  {
        Task {
            switch chartType {
                case .single:
                        data = (data: [ChartsManager.generateChartData(dataSize: dataSize, byAdding: .hour)], labels: ["Bar 1"])
                case .multi:
                        let line1 = ChartsManager.generateChartData(dataSize: dataSize, byAdding: .hour)
                        let line2 = ChartsManager.generateChartData(dataSize: dataSize, byAdding: .hour)
                        let line3 = ChartsManager.generateChartData(dataSize: dataSize, byAdding: .hour)
                        data = (data: [line1, line2, line3], labels: ["Bar 1", "Bar 2", "Bar 3"])
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

struct CorePlotBarChartUIViewRepresentable: UIViewRepresentable {
    let data: [[DataPoint]]
    let labels: [String]
    var onRenderComplete: (() -> Void)?
    
    func makeUIView(context: Context) -> CPTGraphHostingView {
        let hostingView = CPTGraphHostingView()
        let graph = CPTXYGraph(frame: .zero)
        hostingView.hostedGraph = graph
        
        graph.paddingLeft = 0.0
        graph.paddingTop = 0.0
        graph.paddingRight = 0.0
        graph.paddingBottom = 0.0
        
        graph.plotAreaFrame?.paddingLeft = 10.0
        graph.plotAreaFrame?.paddingTop = 0.0
        graph.plotAreaFrame?.paddingRight = 10.0
        graph.plotAreaFrame?.paddingBottom = 15.0
        
        graph.axisSet = createAxisSet(for: graph)
        
        for (index, label) in labels.enumerated() {
            let barPlot = createBarPlot(for: label, index: index, context: context)
            graph.add(barPlot)
            print("Added bar plot for label: \(label)")
        }
        
        context.coordinator.onRenderComplete = onRenderComplete
        
        return hostingView
    }
    
    func updateUIView(_ uiView: CPTGraphHostingView, context: Context) {
        context.coordinator.data = data
        context.coordinator.labels = labels
        
        guard let graph = uiView.hostedGraph else {
            print("Graph not found in hosted view!")
            return
        }
        
        while let plot = graph.allPlots().first {
            plot.dataSource = nil
            graph.remove(plot)
        }
        
        for (index, label) in labels.enumerated() {
            let barPlot = createBarPlot(for: label, index: index, context: context)
            graph.add(barPlot)
        }
        
        updatePlotSpace(for: graph as! CPTXYGraph)
        
        graph.reloadData()
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(data: data, labels: labels, onRenderComplete: onRenderComplete)
    }
    
    private func createAxisSet(for graph: CPTXYGraph) -> CPTXYAxisSet {
        guard let axisSet = graph.axisSet as? CPTXYAxisSet else {
            print("Error: Failed to retrieve axis set.")
            return CPTXYAxisSet()
        }
        
        let xAxis = axisSet.xAxis!
        xAxis.labelingPolicy = .fixedInterval
        xAxis.majorIntervalLength = 3600 as NSNumber
        xAxis.minorTicksPerInterval = 0
        xAxis.orthogonalPosition = 0.0
        xAxis.titleOffset = 25.0
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d\nhh:mm"
        let xLabelFormatter = CPTTimeFormatter(dateFormatter: dateFormatter)
        xLabelFormatter.referenceDate = Date()
        xAxis.labelFormatter = xLabelFormatter
        
        xAxis.labelTextStyle = labelTextStyle()
        xAxis.axisLineStyle = axisLineStyle()
        xAxis.majorTickLineStyle = axisLineStyle()
        
        let yAxis = axisSet.yAxis!
        yAxis.labelingPolicy = .fixedInterval
        yAxis.majorIntervalLength = 10 as NSNumber
        yAxis.minorTicksPerInterval = 5
        yAxis.orthogonalPosition = 0.0
        yAxis.title = "Value"
        yAxis.titleOffset = 40.0
        
        yAxis.axisLineStyle = axisLineStyle()
        yAxis.majorTickLineStyle = axisLineStyle()
        yAxis.labelTextStyle = labelTextStyle()
        
        return axisSet
    }
    
    private func axisLineStyle() -> CPTMutableLineStyle {
        let lineStyle = CPTMutableLineStyle()
        lineStyle.lineWidth = 1.5
        lineStyle.lineColor = CPTColor.black()
        return lineStyle
    }
    
    private func minorAxisLineStyle() -> CPTMutableLineStyle {
        let lineStyle = CPTMutableLineStyle()
        lineStyle.lineWidth = 0.5
        lineStyle.lineColor = CPTColor.gray()
        return lineStyle
    }
    
    private func labelTextStyle() -> CPTMutableTextStyle {
        let textStyle = CPTMutableTextStyle()
        textStyle.color = CPTColor.black()
        textStyle.fontSize = 10.0
        textStyle.fontName = "Helvetica"
        textStyle.textAlignment = .center
        return textStyle
    }
    
    private func createBarPlot(for label: String, index: Int, context: Context) -> CPTBarPlot {
        let barPlot = CPTBarPlot()
        barPlot.identifier = label as NSString
        barPlot.dataSource = context.coordinator
        barPlot.delegate = context.coordinator
        
        barPlot.barWidth = 0.5 as NSNumber
        barPlot.barOffset = 0.25 as NSNumber
        barPlot.fill = CPTFill(color: CPTColor(componentRed: CGFloat(0.2 * Double(index + 1)),
                                               green: 0.5,
                                               blue: 0.5,
                                               alpha: 1.0))
        
        return barPlot
    }
    
    private func updatePlotSpace(for graph: CPTXYGraph) {
        let allXValues = data.flatMap { $0.map(\.x.timeIntervalSinceReferenceDate) }
        let allYValues = data.flatMap { $0.map(\.y) }
        
        let xMin = allXValues.min() ?? 0.0
        let xMax = allXValues.max() ?? 1.0
        let yMin = allYValues.min() ?? 0.0
        let yMax = allYValues.max() ?? 100.0
        
        let plotSpace = graph.defaultPlotSpace as! CPTXYPlotSpace
        plotSpace.xRange = CPTPlotRange(location: NSNumber(value: xMin), length: NSNumber(value: xMax - xMin))
        plotSpace.yRange = CPTPlotRange(location: NSNumber(value: yMin), length: NSNumber(value: yMax - yMin))
    }
    
    class Coordinator: NSObject, CPTPlotDataSource, CPTPlotDelegate {
        var data: [[DataPoint]]
        var labels: [String]
        var onRenderComplete: (() -> Void)?
        
        init(data: [[DataPoint]], labels: [String], onRenderComplete: (() -> Void)?) {
            self.data = data
            self.labels = labels
            self.onRenderComplete = onRenderComplete
        }
        
        func numberOfRecords(for plot: CPTPlot) -> UInt {
            guard let identifier = plot.identifier as? String,
                  let index = labels.firstIndex(of: identifier) else {
                return 0
            }
            return UInt(data[index].count)
        }
        
        func number(for plot: CPTPlot, field: UInt, record: UInt) -> Any? {
            guard let identifier = plot.identifier as? String,
                  let index = labels.firstIndex(of: identifier),
                  Int(record) < data[index].count else {
                return nil
            }
            
            let dataPoint = data[index][Int(record)]
            switch CPTBarPlotField(rawValue: Int(field)) {
                case .barLocation:
                    return dataPoint.x.timeIntervalSinceReferenceDate
                case .barTip:
                    return dataPoint.y
                default:
                    return nil
            }
        }
        
        func didFinishDrawing(_ plot: CPTPlot) {
            onRenderComplete?()
        }
    }
}

#Preview {
    CorePlotView()
}
