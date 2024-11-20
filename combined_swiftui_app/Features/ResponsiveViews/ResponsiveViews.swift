//
//  ResponsiveViews.swift
//  combined_swiftui_app
//
//  Created by Maciej Banaszyński on 13/11/2024.
//

import SwiftUI

struct ResponsiveViews: View {
    var body: some View {
        NavigationStack {
            List {
                NavigationLink("Basic Responsive View") {
                    BasicResponsiveView()
                        .toolbar(.hidden, for: .tabBar)
                }
                NavigationLink("Complex Responsive View") {
                    ComplexResponsiveView()
                        .toolbar(.hidden, for: .tabBar)
                }
                NavigationLink("Responsive Navigation View") {
                    ResponsiveNavigationView()
                        .toolbar(.hidden, for: .tabBar)
                }
                
            }
            .navigationTitle("Responsive Views")
        }
    }
}

#Preview {
    ResponsiveViews()
}
