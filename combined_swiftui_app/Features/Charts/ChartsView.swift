//
//  ChartsView.swift
//  combined_swiftui_app
//
//  Created by Maciej Banaszyński on 10/11/2024.
//

import SwiftUI

struct ChartsView: View {
    var body: some View {
        NavigationView {
            List {
                NavigationLink(destination: SwiftChartView()) {
                    Text("Swift Charts")
                }
                NavigationLink(destination: CorePlotView()) {
                    Text("Core Plot Charts")
                }
                NavigationLink(destination: DGChartsView()) {
                    Text("DGCharts")
                }
            }
            .navigationTitle("Charts")
        }
    }
}


#Preview {
    ChartsView()
}
