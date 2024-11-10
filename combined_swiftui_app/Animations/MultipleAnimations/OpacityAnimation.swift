//
//  OpacityAnimation.swift
//  combined_swiftui_app
//
//  Created by Maciej Banaszyński on 10/11/2024.
//

import SwiftUI

struct OpacityAnimation: View {
    @State private var opacity: Double = 1.0
    
    var body: some View {
        VStack {
            Rectangle()
                .fill(Color.green)
                .frame(width: 300, height: 300)
                .opacity(opacity)
                .animation(.easeInOut(duration: 2).repeatForever(autoreverses: true), value: opacity)
                .onAppear {
                    opacity = 0.3
                }
        }
    }
}


#Preview {
    OpacityAnimation()
}
