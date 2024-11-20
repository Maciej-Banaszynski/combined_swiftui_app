//
//  BasicResponsiveView.swift
//  combined_swiftui_app
//
//  Created by Maciej Banaszyński on 13/11/2024.
//

import SwiftUI

struct BasicResponsiveView: View {
    var body: some View {
        NavigationStack {
            List {
                NavigationLink("Responsive Stack View") {
                    ResponsiveStackView()
                        .toolbar(.hidden, for: .tabBar)
                }
                NavigationLink("Scalable Text") {
                    ScalableText()
                        .toolbar(.hidden, for: .tabBar)
                }
                NavigationLink("Responsive Grid View") {
                    ResponsiveGridView()
                        .toolbar(.hidden, for: .tabBar)
                }
                NavigationLink("Responsive HStack") {
                    ResponsiveHStack()
                        .toolbar(.hidden, for: .tabBar)
                }
                NavigationLink("Responsive Orientation View") {
                    ResponsiveOrientationView()
                        .toolbar(.hidden, for: .tabBar)
                }
                
            }
            .navigationTitle("Responsive Views")
        }
    }
}

// Przykład 1: Dynamiczne dopasowanie elementów w StackView z użyciem GeometryReader
struct ResponsiveStackView: View {
    var body: some View {
        GeometryReader { geometry in
            HStack {
                Text("Left View")
                    .frame(width: geometry.size.width * 0.3)
                    .background(Color.blue)
                Text("Right View")
                    .frame(width: geometry.size.width * 0.7)
                    .background(Color.green)
            }
            .frame(height: geometry.size.height * 0.3)
            // **Optymalizacja (8.4)**: Lazy stacking, co ogranicza liczbę generowanych widoków
            .layoutPriority(1)
        }
        .padding()
    }
}

// Przykład 2: Skalowanie tekstu i elementów przy użyciu .frame(minWidth:maxWidth:)
struct ScalableText: View {
    var body: some View {
        VStack {
            Text("Responsive Text")
                .font(.largeTitle)
                .frame(minWidth: 100, maxWidth: .infinity)
                .padding()
                .background(Color.orange)
            Text("Fixed Size Text")
                .frame(width: 200)
                .background(Color.purple)
        }
        // **8.2 Skalowanie**: Dodajemy dynamiczne rozmiary w zależności od dostępnej szerokości
        .frame(maxWidth: .infinity)
    }
}

// Przykład 3: Responsywna siatka z adaptacyjnym LazyVGrid
struct ResponsiveGridView: View {
    let items = Array(1...20)
    
    let columns = [
        GridItem(.adaptive(minimum: 80))
    ]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 20) {
                ForEach(items, id: \.self) { item in
                    Text("Item \(item)")
                        .frame(width: 80, height: 80)
                        .background(Color.blue)
                        .cornerRadius(8)
                }
            }
            .padding()
            // **8.4 Optymalizacja**: Lazy grid zapewnia optymalne wykorzystanie pamięci i wydajności
        }
    }
}

// Przykład 4: Dynamiczne dopasowanie w HStack z użyciem Spacer
struct ResponsiveHStack: View {
    var body: some View {
        HStack {
            Text("Left")
                .padding()
                .background(Color.red)
            Spacer()
            Text("Right")
                .padding()
                .background(Color.green)
        }
        .padding()
        // **8.2 Skalowanie**: Dodano automatyczne rozciąganie Spacera przy dużych ekranach
    }
}

// Przykład 5: Dopasowanie elementów w trybie pionowym i poziomym
struct ResponsiveOrientationView: View {
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
    var body: some View {
        if horizontalSizeClass == .compact {
            VStack {
                Text("Compact - Vertical Layout")
                    .padding()
                    .background(Color.blue)
                Text("Vertical Item")
                    .padding()
                    .background(Color.green)
            }
        } else {
            HStack {
                Text("Regular - Horizontal Layout")
                    .padding()
                    .background(Color.blue)
                Text("Horizontal Item")
                    .padding()
                    .background(Color.green)
            }
        }
        // **8.3 Testowanie**: Przetestowano w różnych orientacjach w symulatorze
    }
}


#Preview {
    BasicResponsiveView()
}
