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
                    Label("Search", systemImage: "magnifyingglass")
                }
            
            DataManagementView()
                .tabItem {
                    Label("Profile", systemImage: "person.crop.circle.fill")
                }
        }
    }
}

#Preview {
    ContentView()
}
