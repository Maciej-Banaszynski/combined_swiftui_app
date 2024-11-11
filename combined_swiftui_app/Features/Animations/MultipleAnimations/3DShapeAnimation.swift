//
//  3DShapeAnimation.swift
//  combined_swiftui_app
//
//  Created by Maciej Banaszyński on 10/11/2024.
//

import SwiftUI

struct DShapeAnimation: View {
    @State private var rotationAngle: Double = 0
    
    var body: some View {
        Image("exampleImage")
            .resizable()
            .frame(width: 300, height: 300)
            .rotation3DEffect(
                .degrees(rotationAngle),
                axis: (x: 1, y: 1, z: 0)
            )
            .animation(.linear(duration: 3).repeatForever(autoreverses: false), value: rotationAngle)
            .onAppear {
                rotationAngle = 360
            }
    }
}


#Preview {
    DShapeAnimation()
}
