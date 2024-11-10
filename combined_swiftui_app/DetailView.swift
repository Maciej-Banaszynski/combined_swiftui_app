//
//  DetailView.swift
//  combined_swiftui_app
//
//  Created by Maciej Banaszyński on 10/11/2024.
//

import SwiftUI

struct DetailView: View {
    let title: String
    
    var body: some View {
        VStack {
            Text("Detail View for \(title)")
                .font(.largeTitle)
                .padding()
            Spacer()
        }
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.inline) 
    }
}

#Preview {
    DetailView(title: "Example screen")
}
