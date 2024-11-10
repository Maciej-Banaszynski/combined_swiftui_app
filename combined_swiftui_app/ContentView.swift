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
                    Label("Charts", systemImage: "house.fill")
                }
            
            AnimationsView()
                .tabItem {
                    Label("Animations", systemImage: "magnifyingglass")
                }
            
            DataManagementView()
                .tabItem {
                    Label("Data", systemImage: "person.crop.circle.fill")
                }
        }
    }
}

#Preview {
    ContentView()
}
