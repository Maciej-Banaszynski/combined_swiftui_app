//
//  CorePlotLineChartView.swift
//  combined_swiftui_app
//
//  Created by Maciej Banaszyński on 20/11/2024.
//

import SwiftUI
import CorePlot

struct CorePlotLineChartView: View {
    @State private var dataSize: DataSize = .hundred
    @State private var data: (data: [[DataPoint]], labels: [String]) = ( data: [], labels: [])
    @State private var dataHasRendered: Bool = false
    
    var chartType: DGChartType
    
    var body: some View {
        VStack(spacing: 5) {
            Text(chartType.lineTitle).font(.headline)
            ChartDataSizePicker(dataSize: $dataSize, dataSizeValues: DataSize.lineChartValues, title: "Line Data Size") { loadData() }
            CorePlotLineChartUIViewRepresentable(data: data.data, labels: data.labels, onRenderComplete: { dataHasRendered = true }).frame(height: 350)
        }
        .onAppear() { loadData() }
    }
    
    private func loadData()  {
        Task {
            switch chartType {
                case .single:
                    await MetricsManager.shared.trackAction(actionName: "Generate \(dataSize.rawValue) Data for single CorePlotLineChart") {
                        data = (data: [ChartsManager.generateChartData(dataSize: dataSize, byAdding: .hour)], labels: ["Line 1"])
//                        await waitForDataRender()
//                        dataHasRendered = false
                    }
                case .multi:
                    await MetricsManager.shared.trackAction(actionName: "Generate \(dataSize.rawValue) Data for multiline CorePlotLineChart") {
                        let line1 = ChartsManager.generateChartData(dataSize: dataSize, byAdding: .hour)
                        let line2 = ChartsManager.generateChartData(dataSize: dataSize, byAdding: .hour)
                        let line3 = ChartsManager.generateChartData(dataSize: dataSize, byAdding: .hour)
                        data = (data: [line1, line2, line3], labels: ["Line 1", "Line 2", "Line 3"])
//                        await waitForDataRender()
//                        dataHasRendered = false
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

struct CorePlotLineChartUIViewRepresentable: UIViewRepresentable {
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
        
        graph.plotAreaFrame?.paddingLeft = 0.0
        graph.plotAreaFrame?.paddingTop = 0.0
        graph.plotAreaFrame?.paddingRight = 0.0
        graph.plotAreaFrame?.paddingBottom = 40.0
    
        graph.axisSet = createAxisSet(for: graph)
        enableZoomAndScroll(for: graph, coordinator: context.coordinator)
        
        for (index, label) in labels.enumerated() {
            let linePlot = createLinePlot(for: label, index: index, context: context)
            graph.add(linePlot)
            print("Added initial plot for label: \(label)")
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
        
        enableZoomAndScroll(for: graph as! CPTXYGraph, coordinator: context.coordinator)
        
        while let plot = graph.allPlots().first {
            plot.dataSource = nil
            graph.remove(plot)
        }
        
        for (index, label) in labels.enumerated() {
            let linePlot = createLinePlot(for: label, index: index, context: context)
            graph.add(linePlot)
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
        
        xAxis.majorGridLineStyle = majorGridLineStyle()
        xAxis.minorGridLineStyle = nil
        
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

    private func createLinePlot(for label: String, index: Int, context: Context) -> CPTScatterPlot {
        let linePlot = CPTScatterPlot()
        linePlot.identifier = label as NSString
        linePlot.dataSource = context.coordinator
        linePlot.delegate = context.coordinator
        
        let lineStyle = CPTMutableLineStyle()
        lineStyle.lineColor = CPTColor(componentRed: CGFloat(0.2 * Double(index + 1)),
                                       green: 0.5,
                                       blue: 0.5,
                                       alpha: 1.0)
        lineStyle.lineWidth = 2.0
        linePlot.dataLineStyle = lineStyle
        
        return linePlot
    }
    
    private func updatePlotSpace(for graph: CPTXYGraph) {
        let allXValues = data.flatMap { $0.map(\.x.timeIntervalSinceReferenceDate) }
        let allYValues = data.flatMap { $0.map(\.y) }
        
        var xMin = allXValues.min() ?? 0.0
        var xMax = allXValues.max() ?? 1.0
        var yMin = allYValues.min() ?? 0.0
        var yMax = allYValues.max() ?? 100.0
        
        let xPadding = 3600.0
        let yPadding = (yMax - yMin)
        xMin -= xPadding
        xMax += xPadding
        yMin -= yPadding
        yMax += yPadding
        
        if xMax == xMin {
            xMin -= 1.0
            xMax += 1.0
        }
        if yMax == yMin {
            yMin -= 1.0
            yMax += 1.0
        }
        
        let plotSpace = graph.defaultPlotSpace as! CPTXYPlotSpace
        plotSpace.xRange = CPTPlotRange(location: NSNumber(value: xMin), length: NSNumber(value: xMax - xMin))
        plotSpace.yRange = CPTPlotRange(location: NSNumber(value: yMin), length: NSNumber(value: yMax - yMin))
    }
    
    private func majorGridLineStyle() -> CPTMutableLineStyle {
        let lineStyle = CPTMutableLineStyle()
        lineStyle.lineWidth = 1.0
        lineStyle.lineColor = CPTColor.gray().withAlphaComponent(0.5)
        return lineStyle
    }
    
    private func enableZoomAndScroll(for graph: CPTXYGraph, coordinator: Coordinator) {
        guard let plotSpace = graph.defaultPlotSpace as? CPTXYPlotSpace else {
            print("Error: Could not retrieve CPTXYPlotSpace.")
            return
        }
        
        plotSpace.allowsUserInteraction = true
        plotSpace.delegate = coordinator
        
        let allXValues = data.flatMap { $0.map(\.x.timeIntervalSinceReferenceDate) }
        let xMin = (allXValues.min() ?? 0.0) - 3600.0
        let xMax = (allXValues.max() ?? 1.0) + 3600.0
        
        let allYValues = data.flatMap { $0.map(\.y) }
        let yMin = (allYValues.min() ?? 0.0) - 10.0
        let yMax = (allYValues.max() ?? 100.0) + 10.0
        
        plotSpace.globalXRange = CPTPlotRange(location: NSNumber(value: xMin), length: NSNumber(value: xMax - xMin))
        plotSpace.xRange = CPTPlotRange(location: NSNumber(value: xMin), length: NSNumber(value: xMax - xMin))
        plotSpace.globalYRange = CPTPlotRange(location: NSNumber(value: yMin), length: NSNumber(value: yMax - yMin))
        plotSpace.yRange = CPTPlotRange(location: NSNumber(value: yMin), length: NSNumber(value: yMax - yMin))
        
        plotSpace.allowsMomentumX = true
        plotSpace.allowsMomentumY = false
    }

    class Coordinator: NSObject, CPTPlotDataSource, CPTPlotSpaceDelegate, CPTPlotDelegate {
        var data: [[DataPoint]]
        var labels: [String]
        var onRenderComplete: (() -> Void)?
        
        init(data: [[DataPoint]], labels: [String], onRenderComplete: (() -> Void)?) {
            self.data = data
            self.labels = labels
            self.onRenderComplete = onRenderComplete
        }
        
        func plotSpace(_ space: CPTPlotSpace, shouldScaleBy interactionScale: CGFloat, aboutPoint interactionPoint: CGPoint) -> Bool {
            if let plotSpace = space as? CPTXYPlotSpace {
                plotSpace.yRange = plotSpace.globalYRange!
                return true
            }
            return false
        }
        
        func numberOfRecords(for plot: CPTPlot) -> UInt {
            guard let identifier = plot.identifier as? String,
                  let index = labels.firstIndex(of: identifier) else {
                return 0
            }
            let count = UInt(data[index].count)
            return count
        }
        
        func number(for plot: CPTPlot, field: UInt, record: UInt) -> Any? {
            guard let identifier = plot.identifier as? String,
                  let index = labels.firstIndex(of: identifier),
                  Int(record) < data[index].count else {
                return nil
            }
            
            let dataPoint = data[index][Int(record)]
            switch CPTScatterPlotField(rawValue: Int(field)) {
                case .X:
                    return dataPoint.x.timeIntervalSinceReferenceDate
                case .Y:
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
