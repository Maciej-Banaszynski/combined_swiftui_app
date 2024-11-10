//
//  AnimationsView.swift
//  combined_swiftui_app
//
//  Created by Maciej Banaszyński on 10/11/2024.
//

import SwiftUI

struct AnimationsView: View {
    var body: some View {
        NavigationView {
            List {
                NavigationLink(destination: BasicAnimationsView()) {
                    Text("Basic Animations")
                }
                
                NavigationLink(destination: MultipleAnimationsView()) {
                    Text("Multiple Animations")
                }
                
                NavigationLink(destination: DetailView(title: "Option 3")) {
                    Text("Option 3")
                }
            }
            .navigationTitle("Animations")
        }
    }
}

#Preview {
    ContentView()
}

#Preview {
    AnimationsView()
}
