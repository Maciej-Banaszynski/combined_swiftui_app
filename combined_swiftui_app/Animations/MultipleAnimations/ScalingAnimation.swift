//
//  ScalingAnimation.swift
//  combined_swiftui_app
//
//  Created by Maciej Banaszyński on 10/11/2024.
//

import SwiftUI

struct ScalingAnimation: View {
    @State private var scale: CGFloat = 1.0
    
    var body: some View {
        Text("Scaling Animation")
            .font(.title)
            .padding()
            .background(Color.red)
            .cornerRadius(10)
            .scaleEffect(scale)
            .animation(.easeInOut(duration: 1).repeatForever(autoreverses: true), value: scale)
            .onAppear {
                scale = 1.5
            }
    }
}


#Preview {
    ScalingAnimation()
}
