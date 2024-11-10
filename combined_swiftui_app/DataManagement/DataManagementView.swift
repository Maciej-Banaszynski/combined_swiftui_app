//
//  DataManagementView.swift
//  combined_swiftui_app
//
//  Created by Maciej Banaszyński on 10/11/2024.
//

import SwiftUI

struct DataManagementView: View {
    var body: some View {
        NavigationView {
            List {
                NavigationLink(destination: DetailView(title: "Option 1")) {
                    Text("Option 1")
                }
                
                NavigationLink(destination: DetailView(title: "Option 2")) {
                    Text("Option 2")
                }
                
                NavigationLink(destination: DetailView(title: "Option 3")) {
                    Text("Option 3")
                }
            }
            .navigationTitle("Data")
        }
    }
}

#Preview {
    ContentView()
}

#Preview {
    DataManagementView()
}
