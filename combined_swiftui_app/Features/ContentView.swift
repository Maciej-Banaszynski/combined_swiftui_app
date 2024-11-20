//
//  ContentView.swift
//  combined_swiftui_app
//
//  Created by Maciej Banaszyński on 10/11/2024.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            ChartsView()
                .tabItem {
                    Label("Charts", systemImage: "chart.bar.xaxis.ascending")
                        .accessibilityIdentifier("chartsTab")
                }
            AnimationsView()
                .tabItem {
                    Label("Animations", systemImage: "circle.square.fill")
                        .accessibilityIdentifier("animationsTab")
                }
            MapsPickerView()
                .tabItem {
                    Label("Maps", systemImage: "map")
                        .accessibilityIdentifier("mapsTab")
                }
            DataManagementPickerView()
                .tabItem {
                    Label("Data", systemImage: "ellipsis.curlybraces")
                        .accessibilityIdentifier("dataTab")
                }
            ResponsiveViews()
                .tabItem {
                    Label("Responsive Views", systemImage: "viewfinder")
                        .accessibilityIdentifier("responsiveTab")
                }
        }
    }
}

#Preview {
    ContentView()
}
