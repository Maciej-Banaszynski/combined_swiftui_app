//
//  ShapeAnimations.swift
//  combined_swiftui_app
//
//  Created by Maciej Banaszyński on 10/11/2024.
//

import SwiftUI

struct ShapeAnimations: View {
    @State private var changeShape = false
    
    var body: some View {
        Path { path in
            if changeShape {
                path.move(to: CGPoint(x: 50, y: 50))
                path.addLine(to: CGPoint(x: 250, y: 150))
                path.addQuadCurve(to: CGPoint(x: 50, y: 250), control: CGPoint(x: 150, y: 50))
                path.addLine(to: CGPoint(x: 50, y: 50))
            } else {
                path.move(to: CGPoint(x: 150, y: 50))
                path.addLine(to: CGPoint(x: 50, y: 150))
                path.addLine(to: CGPoint(x: 150, y: 250))
                path.addLine(to: CGPoint(x: 250, y: 150))
                path.addLine(to: CGPoint(x: 150, y: 50))
            }
        }
        .stroke(Color.blue, lineWidth: 5)
        .animation(.easeInOut(duration: 2).repeatForever(autoreverses: true), value: changeShape)
        .onAppear {
            changeShape.toggle()
        }
    }
}


#Preview {
    ShapeAnimations()
}
