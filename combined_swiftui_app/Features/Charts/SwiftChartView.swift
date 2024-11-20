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
                Picker("Data Size", selection: $dataSize) {
                    Text("100").tag(DataSize.hundred)
                    Text("1,000").tag(DataSize.oneThousand)
                    Text("10,000").tag(DataSize.tenThousand)
                    Text("100,000").tag(DataSize.oneHundredThousand)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                .onChange(of: dataSize) { loadData() }
                
                Text("Line Chart").font(.headline)
                Chart(data) {
                    LineMark(
                        x: .value("Date", $0.x),
                        y: .value("Value", $0.y)
                    )
                    .symbol(.circle)
                    .interpolationMethod(.catmullRom)
                    
                    AreaMark(
                        x: .value("Date", $0.x),
                        y: .value("Value", $0.y)
                    )
                    .interpolationMethod(.catmullRom)
                    .foregroundStyle(areaBackground)
                }
                .frame(height: 200)
                
                Text("Bar Chart").font(.headline)
                Chart(data) {
                    BarMark(x: .value("Date", $0.x),
                            y: .value("Value", $0.y))
                }
                .frame(height: 200)
                
                Text("Scatter Chart").font(.headline)
                Chart(data) {
                    PointMark(x: .value("Date", $0.x),
                              y: .value("Value", $0.y))
                }
                .frame(height: 200)
            }
            .onAppear() { loadData() }
            .padding()
        }
        .navigationTitle("Swift Charts")
    }
    
    private func loadData()  {
        Task {
            await MetricsManager.shared.trackAction(actionName: "GenerateAndPlot") {
                let generatedData = ChartsManager.generateChartData(dataSize: dataSize)
                DispatchQueue.main.async {
                    _ = LineChart(data: generatedData)
                }
                data = generatedData
            }
        }
    }
}

#Preview {
    SwiftChartView()
}
