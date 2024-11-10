//
//  ShadowAnimation.swift
//  combined_swiftui_app
//
//  Created by Maciej Banaszyński on 10/11/2024.
//

import SwiftUI

struct ShadowAnimation: View {
    @State private var shadowRadius: CGFloat = 1.0
    
    var body: some View {
        Text("Shadow Animation")
            .font(.largeTitle)
            .padding()
            .background(Color.blue)
            .cornerRadius(10)
            .shadow(color: .black.opacity(0.5), radius: shadowRadius, x: 0, y: 10)
            .animation(.easeInOut(duration: 1).repeatForever(autoreverses: true), value: shadowRadius)
            .onAppear {
                shadowRadius = 20.0
            }
    }
}


#Preview {
    ShadowAnimation()
}
