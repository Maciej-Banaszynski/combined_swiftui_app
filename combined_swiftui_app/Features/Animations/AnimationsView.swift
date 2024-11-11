//
//  AnimationsView.swift
//  combined_swiftui_app
//
//  Created by Maciej Banaszyński on 10/11/2024.
//

import SwiftUI

struct AnimationsView: View {
    var body: some View {
        NavigationStack {
            List {
                NavigationLink("Basic Animations") {
                    BasicAnimationsView()
                        .toolbar(.hidden, for: .tabBar)
                }
                NavigationLink("Multiple Animations") { 
                    MultipleAnimationsView()
                        .toolbar(.hidden, for: .tabBar)
                }
                NavigationLink("Bouncing balls") {
                    BouncingBallsView()
                        .toolbar(.hidden, for: .tabBar)
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
