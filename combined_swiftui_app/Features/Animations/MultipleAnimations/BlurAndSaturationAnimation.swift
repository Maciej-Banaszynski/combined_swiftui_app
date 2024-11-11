//
//  BlurAndSaturationAnimation.swift
//  combined_swiftui_app
//
//  Created by Maciej Banaszyński on 10/11/2024.
//

import SwiftUI

struct BlurAndSaturationAnimation: View {
    @State private var blurAmount: CGFloat = 0.0
    @State private var saturationAmount: Double = 1.0
    
    var body: some View {
        Image("exampleImage")
            .resizable()
            .scaledToFit()
            .frame(width: 300, height: 300)
            .blur(radius: blurAmount)
            .saturation(saturationAmount)
            .animation(.easeInOut(duration: 2).repeatForever(autoreverses: true), value: blurAmount)
            .onAppear {
                blurAmount = 10.0
                saturationAmount = 0.2
            }
    }
}


#Preview {
    BlurAndSaturationAnimation()
}
