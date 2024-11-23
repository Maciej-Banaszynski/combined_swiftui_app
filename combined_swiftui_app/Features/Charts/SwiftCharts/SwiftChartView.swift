//
//  SwiftChartView.swift
//  combined_swiftui_app
//
//  Created by Maciej Banaszyński on 20/11/2024.
//

import SwiftUI
import Charts

struct SwiftChartView: View {
    @State private var dataSize: DataSize = .oneThousand
    @State private var data: [DataPoint] = []
    
    private var areaBackground: Gradient {
        return Gradient(colors: [Color.accentColor, Color.accentColor.opacity(0.1)])
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                SwiftLineChartView(chartType: .single)
                SwiftBarChartView(chartType: .single)
                SwiftLineChartView(chartType: .multi)
                SwiftBarChartView(chartType: .multi)
                
//                Text("Bar Chart").font(.headline)
//                Chart(data) {
//                    BarMark(x: .value("Date", $0.x),
//                            y: .value("Value", $0.y))
//                }
//                .frame(height: 200)
//                
//                Text("Scatter Chart").font(.headline)
//                Chart(data) {
//                    PointMark(x: .value("Date", $0.x),
//                              y: .value("Value", $0.y))
//                }
//                .frame(height: 200)
            }
            .onAppear() { loadData() }
            .padding()
        }
        .navigationTitle("Swift Charts")
    }
    
    private func loadData()  {
//        Task {
//            await MetricsManager.shared.trackAction(actionName: "GenerateAndPlot") {
//                let generatedData = ChartsManager.generateChartData(dataSize: dataSize)
//               
//                data = generatedData
//            }
//        }
    }
}

#Preview {
    SwiftChartView()
}
