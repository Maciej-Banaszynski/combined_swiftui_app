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
                }
            AnimationsView()
                .tabItem {
                    Label("Animations", systemImage: "circle.square.fill")
                }
            MapsPickerView()
                .tabItem {
                    Label("Maps", systemImage: "map")
                }
            DataManagementPickerView()
                .tabItem {
                    Label("Data", systemImage: "ellipsis.curlybraces")
                }
        }
    }
}

#Preview {
    ContentView()
}
