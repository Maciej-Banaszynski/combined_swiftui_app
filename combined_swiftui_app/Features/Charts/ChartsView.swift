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
                NavigationLink(destination: MultipleChartsView()) {
                    Text("Multiple Charts")
                }
                
                NavigationLink(destination: DetailView(title: "Option 2")) {
                    Text("Option 2")
                }
                
                NavigationLink(destination: DetailView(title: "Option 3")) {
                    Text("Option 3")                    
                }
            }
            .navigationTitle("Charts")
        }
    }
}

#Preview {
    ContentView()
}

#Preview {
    ChartsView()
}
