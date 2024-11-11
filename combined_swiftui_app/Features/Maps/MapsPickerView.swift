//
//  MapsPickerView.swift
//  combined_swiftui_app
//
//  Created by Maciej Banaszyński on 11/11/2024.
//

import SwiftUI

struct MapsPickerView: View {
    var body: some View {
        NavigationStack {
            List {
                NavigationLink("AppleMaps") {
                    AppleMapsView()
                        .toolbar(.hidden, for: .tabBar)
                }
                
            }
            .navigationTitle("Maps")
        }
    }
}

#Preview {
    MapsPickerView()
}
