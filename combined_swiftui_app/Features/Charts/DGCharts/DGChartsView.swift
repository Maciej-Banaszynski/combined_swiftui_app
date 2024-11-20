//
//  DGChartsView.swift
//  combined_swiftui_app
//s
//  Created by Maciej Banaszyński on 20/11/2024.
//

import SwiftUI
import DGCharts

struct DGChartsView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                DGLineChartView(chartType: .singleLine)
                DGBarChartView()
                DGLineChartView(chartType: .multiLine)
            }
            .padding()
        }
        .navigationTitle("DGCharts")
    }
}

#Preview {
    DGChartsView()
}