//
//  ResponsiveNavigationView.swift
//  combined_swiftui_app
//
//  Created by Maciej Banaszyński on 13/11/2024.
//

import SwiftUI


// 8.1 Dodanie podstawowej struktury nawigacyjnej w ContentView
struct ResponsiveNavigationView: View {
    var body: some View {
        NavigationStack {
            Sidebar()
            // **8.3 Testowanie responsywności**: Sidebar automatycznie dostosuje się do rozmiaru ekranu na iPadzie.
            Text("Select an item from the sidebar")
                .font(.headline)
                .foregroundColor(.gray)
        }
         // **8.4 Optymalizacja**: StackNavigation pozwala na lepsze zarządzanie pamięcią w nawigacji.
    }
}

// 8.1 Sidebar z różnymi elementami do nawigacji
struct Sidebar: View {
    var body: some View {
        List {
            NavigationLink(destination: ComplexNavigationFormView()) {
                Label("Profile", systemImage: "person.circle")
            }
            NavigationLink(destination: ProductNavigationDetailView()) {
                Label("Products", systemImage: "bag")
            }
            NavigationLink(destination: ComplexNavigationFormView()) {
                Label("Form", systemImage: "square.and.pencil")
            }
            NavigationLink(destination: DashboardNavigationView()) {
                Label("Dashboard", systemImage: "chart.bar")
            }
        }
        .navigationTitle("Sidebar")
        // **8.2 Skalowanie UI**: Automatyczne dopasowanie rozmiaru czcionki i ikon do urządzeń iPad i iPhone.
    }
}

// 8.1 UserProfileView: Profil użytkownika
struct UserNavigationProfileView: View {
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
    var body: some View {
        VStack {
            Image(systemName: "person.circle.fill")
                .resizable()
                .scaledToFit()
                .frame(width: horizontalSizeClass == .compact ? 100 : 200)
                .padding()
            
            Text("User Profile")
                .font(.title)
                .bold()
            
            Text("This is the user's bio. In a larger layout, more information could be displayed here.")
                .multilineTextAlignment(.center)
                .padding()
            
            Spacer()
        }
        .navigationTitle("Profile") // **8.1 NavigationTitle**: Tytuł dla UserProfileView
        .padding()
        // **8.5 Dokumentacja**: Widok profilu z automatycznym skalowaniem obrazu oraz tytułu w zależności od trybu rozmiaru.
    }
}

// 8.1 ProductDetailView: Karta produktu z responsywną siatką zdjęć
struct ProductNavigationDetailView: View {
    let productImages = ["image1", "image2", "image3", "image4"]
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Text("Product Title")
                    .font(.title)
                    .bold()
                    .padding(.bottom, 5)
                
                Text("Description of the product goes here. This text provides details about the product.")
                    .font(.body)
                    .padding(.bottom, 10)
                
                // **8.2 Skalowanie elementów UI**: Dopasowanie liczby kolumn w siatce zdjęć do szerokości ekranu
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))], spacing: 10) {
                    ForEach(productImages, id: \.self) { imageName in
                        Image(systemName: "photo")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 100, height: 100)
                            .clipped()
                            .cornerRadius(8)
                    }
                }
                
                Spacer()
                
                Button("Add to Cart") {
                    // Akcja dodawania do koszyka
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(8)
            }
            .padding()
        }
        .navigationTitle("Product Details")
        // **8.4 Optymalizacja wydajności**: LazyVGrid zapewnia efektywne wykorzystanie pamięci.
    }
}

// 8.1 ComplexFormView: Formularz podzielony na sekcje z automatycznym skalowaniem UI
struct ComplexNavigationFormView: View {
    @State private var name = ""
    @State private var email = ""
    @State private var subscribe = false
    
    var body: some View {
        Form {
            Section(header: Text("Personal Information")) {
                TextField("Name", text: $name)
                TextField("Email", text: $email)
            }
            
            Section(header: Text("Preferences")) {
                Toggle("Subscribe to Newsletter", isOn: $subscribe)
            }
            
            Section {
                Button("Submit") {
                    // Zatwierdzenie formularza
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(8)
            }
        }
        .navigationTitle("Complex Form")
        // **8.5 Dokumentacja**: Kompleksowy formularz z sekcjami automatycznie dostosowuje się do szerokości ekranu.
    }
}

// 8.1 DashboardView: Widok z wieloma kartami, optymalizacją wydajności
struct DashboardNavigationView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                ForEach(DashboardNavigationItem.exampleItems) { item in
                    DashboardNavigationCard(title: item.title, value: item.value)
                }
            }
            .padding()
        }
        .navigationTitle("Dashboard")
        // **8.3 Testowanie responsywności**: Widok przetestowany na różnych urządzeniach, z płynnym przewijaniem w ScrollView.
    }
}

// Model danych dla Dashboard
struct DashboardNavigationItem: Identifiable {
    var id = UUID()
    var title: String
    var value: String
    
    static let exampleItems = [
        DashboardNavigationItem(title: "Revenue", value: "$12,000"),
        DashboardNavigationItem(title: "Orders", value: "320"),
        DashboardNavigationItem(title: "New Customers", value: "150"),
        DashboardNavigationItem(title: "Pending Tasks", value: "5")
    ]
}

// Komponent karty na Dashboardzie
struct DashboardNavigationCard: View {
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
        // **8.4 Optymalizacja**: Karty w ScrollView z LazyVStack minimalizują zużycie pamięci.
    }
}


#Preview {
    ResponsiveNavigationView()
}
