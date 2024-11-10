//
//  MultipleAnimationsView.swift
//  combined_swiftui_app
//
//  Created by Maciej Banaszyński on 10/11/2024.
//

import SwiftUI

struct MultipleAnimationsView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 50) {
                ShapeAnimations()
                BlurAndSaturationAnimation()
                ShadowAnimation()
                DShapeAnimation()
                ScalingAnimation()
                OpacityAnimation()
            }
            .navigationTitle("Multiple Animations")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    ContentView()
}

#Preview {
    MultipleAnimationsView()
}
