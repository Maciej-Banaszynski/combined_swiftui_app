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
                CorePlotLineChartView(chartType: .single)
                CorePlotBarChartView(chartType: .single)
                CorePlotLineChartView(chartType: .multi)
                CorePlotBarChartView(chartType: .multi)
            }
        }
        .navigationTitle("Core Plot")
    }
}

#Preview {
    CorePlotView()
}
