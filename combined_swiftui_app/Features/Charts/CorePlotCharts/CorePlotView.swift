//
//  CorePlotView.swift
//  combined_swiftui_app
//
//  Created by Maciej Banaszyński on 20/11/2024.
//

import SwiftUI
import CorePlot

struct CorePlotView: View {
    @State private var lineDataSize: DataSize = .hundred
    @State private var lineData: [DataPoint] = []
    
    @State private var barDataSize: DataSize = .ten
    @State private var barData: [DataPoint] = []
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text("Line Chart").font(.headline)
                ChartDataSizePicker(dataSize: $lineDataSize, dataSizeValues: DataSize.lineChartValues, title: "Line Data Size") { loadLineData() }
                CorePlotChartView(chartType: .line, data: lineData)
                    .frame(height: 200)
                
                Text("Bar Chart").font(.headline)
                ChartDataSizePicker(dataSize: $barDataSize, dataSizeValues: DataSize.barChartValues, title: "Bar Data Size") { loadBarData() }
                    .frame(height: 200)
                
                //                Text("Scatter Chart").font(.headline)
                //                CorePlotChartView(chartType: .scatter, data: data)
                //                    .frame(height: 200)
            }
            .onAppear() { loadData() }
            .padding()
        }
        .navigationTitle("Core Plot")
    }
    
    private func loadData()  {
        loadLineData()
        loadBarData()
    }
    
    private func loadLineData()  {
        Task {
            await MetricsManager.shared.trackAction(actionName: "GenerateAndPlot") {
                lineData = ChartsManager.generateChartData(dataSize: lineDataSize, byAdding: .hour)
            }
        }
    }
    private func loadBarData()  {
        Task {
            await MetricsManager.shared.trackAction(actionName: "GenerateAndPlot") {
                barData = ChartsManager.generateChartData(dataSize: barDataSize, byAdding: .month)
            }
        }
    }
}

struct CorePlotChartView: UIViewRepresentable {
    enum ChartType {
        case line, bar, scatter
    }
    
    let chartType: ChartType
    let data: [DataPoint]
    
    func makeUIView(context: Context) -> CPTGraphHostingView {
        let hostingView = CPTGraphHostingView()
        let graph = CPTXYGraph(frame: .zero)
        hostingView.hostedGraph = graph
        graph.apply(CPTTheme(named: .plainWhiteTheme))
        
        return hostingView
    }
    
    func updateUIView(_ uiView: CPTGraphHostingView, context: Context) {}
}


#Preview {
    CorePlotView()
}
