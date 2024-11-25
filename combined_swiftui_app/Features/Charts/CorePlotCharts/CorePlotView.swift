//
//  CorePlotView.swift
//  combined_swiftui_app
//
//  Created by Maciej Banaszyński on 20/11/2024.
//

import SwiftUI
import CorePlot

struct CorePlotView: View {
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
