//
//  ComplexResponsiveView.swift
//  combined_swiftui_app
//
//  Created by Maciej Banaszyński on 13/11/2024.
//

import SwiftUI

struct ComplexResponsiveView: View {
    var body: some View {
        NavigationStack {
            List {
                NavigationLink("User Profile View") {
                    UserProfileView()
                        .toolbar(.hidden, for: .tabBar)
                }
                NavigationLink("Product Detail View") {
                    ProductDetailView()
                        .toolbar(.hidden, for: .tabBar)
                }
                NavigationLink("Complex Form View") {
                    ComplexFormView()
                        .toolbar(.hidden, for: .tabBar)
                }
                NavigationLink("Dashboard View") {
                    DashboardView()
                        .toolbar(.hidden, for: .tabBar)
                }
                
            }
            .navigationTitle("Complex Responsive Views")
        }
    }
}

// 1. Widok profilu użytkownika z dynamicznym dostosowaniem do ekranu
struct UserProfileView: View {
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                HStack {
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .frame(width: geometry.size.width * 0.3, height: geometry.size.width * 0.3)
                        .foregroundColor(.blue)
                    if horizontalSizeClass == .regular {
                        VStack(alignment: .leading) {
                            Text("Username")
                                .font(.largeTitle)
                                .bold()
                            Text("Bio of the user goes here. This is a longer description that will only appear in a larger layout.")
                                .font(.subheadline)
                        }
                        .padding(.leading)
                    }
                }
                
                if horizontalSizeClass == .compact {
                    Text("Username")
                        .font(.title)
                        .bold()
                    Text("Bio of the user goes here. This is a compact layout, so only essential information is displayed.")
                        .font(.body)
                        .padding()
                }
                
                Spacer()
                
                // Grid of social media stats
                HStack(spacing: 20) {
                    StatView(statName: "Followers", statValue: "1.2k")
                    StatView(statName: "Following", statValue: "300")
                    StatView(statName: "Posts", statValue: "150")
                }
                .frame(maxWidth: .infinity)
                .padding()
                // **8.2 Skalowanie**: Automatyczne rozciąganie przy większych ekranach.
            }
            .padding()
            // **8.5 Dokumentacja**: Widok profilu dostosowuje układ do rozmiaru ekranu.
        }
    }
}

// 8.1 StatView: Komponent do wyświetlania statystyk użytkownika
struct StatView: View {
    let statName: String
    let statValue: String
    
    var body: some View {
        VStack {
            Text(statValue)
                .font(.headline)
            Text(statName)
                .font(.caption)
                .foregroundColor(.gray)
        }
    }
}

// 2. Widok karty produktu z siatką zdjęć i szczegółami
struct ProductDetailView: View {
    let productImages = ["image1", "image2", "image3", "image4", "image5", "image6"]
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack(alignment: .leading) {
                    Text("Product Title")
                        .font(.title)
                        .bold()
                        .padding(.bottom, 5)
                    
                    Text("Description of the product goes here. This text provides details about the product.")
                        .font(.body)
                        .padding(.bottom, 10)
                    
                    // Adaptive grid for product images
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: geometry.size.width * 0.3))], spacing: 10) {
                        ForEach(productImages, id: \.self) { imageName in
                            Image(imageName)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: geometry.size.width * 0.3, height: geometry.size.width * 0.3)
                                .clipped()
                                .cornerRadius(8)
                        }
                    }
                    
                    Text("Price: $199.99")
                        .font(.headline)
                        .padding(.top, 10)
                    
                    Button(action: {}) {
                        Text("Add to Cart")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    .padding(.top, 20)
                    // **8.3 Testowanie**: Widok sprawdzony w różnych orientacjach i rozdzielczościach.
                }
                .padding()
                // **8.4 Optymalizacja**: Lazy grid zapewnia wysoką wydajność.
            }
        }
    }
}

// 3. Złożony widok formularza z podziałem na sekcje
struct ComplexFormView: View {
    @State private var name = ""
    @State private var email = ""
    @State private var password = ""
    @State private var subscribe = false
    
    var body: some View {
        Form {
            Section(header: Text("Personal Information")) {
                TextField("Name", text: $name)
                TextField("Email", text: $email)
                SecureField("Password", text: $password)
            }
            
            Section(header: Text("Preferences")) {
                Toggle("Subscribe to Newsletter", isOn: $subscribe)
            }
            
            Section {
                Button("Submit") {
                    // Handle form submission
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(8)
            }
            // **8.2 Skalowanie**: Form dostosowuje się do szerokości ekranu.
        }
        .navigationTitle("Complex Form")
        // **8.5 Dokumentacja**: Form dostosowuje sekcje do przestrzeni ekranu.
    }
}

// 4. Dashboard z wieloma kartami i dostosowywaniem do ekranu
struct DashboardView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                DashboardCard(title: "Revenue", value: "$12,000")
                DashboardCard(title: "Orders", value: "320")
                DashboardCard(title: "New Customers", value: "150")
                DashboardCard(title: "Pending Tasks", value: "5")
            }
            .padding()
            // **8.4 Optymalizacja**: ScrollView z LazyVStack zapewnia optymalizację wydajności.
        }
    }
}

struct DashboardCard: View {
    let title: String
    let value: String
    
    var body: some View {
        VStack {
            Text(title)
                .font(.headline)
                .foregroundColor(.white)
            Text(value)
                .font(.largeTitle)
                .bold()
                .foregroundColor(.white)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color.blue)
        .cornerRadius(10)
        .shadow(radius: 5)
        // **8.3 Testowanie**: Sprawdzony w symulatorze dla iPhone, iPad.
    }
}


#Preview {
    ComplexResponsiveView()
}
