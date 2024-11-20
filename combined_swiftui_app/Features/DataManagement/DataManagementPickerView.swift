//
//  DataManagementPickerView.swift
//  combined_swiftui_app
//
//  Created by Maciej Banaszyński on 10/11/2024.
//

import SwiftUI
import Foundation
import SwiftData

struct DataManagementPickerView: View {
    var body: some View {
        NavigationStack {
            List {
                NavigationLink("Swift Data Managament") {
                    SwiftDataManagementDestinationView()
                        .toolbar(.hidden, for: .tabBar)
                }
                .accessibilityIdentifier("swiftDataManagementButton")
                NavigationLink("SQLite Data Management") {
                    let userRepository = SQLiteUserRepository(userDAO: SQLiteUserDAO())
                    let viewModel = BasicDataViewModel(repository: userRepository)
                    
                    DataManagementView(viewModel: viewModel, isSQLiteView: true)
                        .toolbar(.hidden, for: .tabBar)
                }
                .accessibilityIdentifier("sqliteDataManagementButton")
            }
            .navigationTitle("Data")
        }
    }
}


#Preview {
    ContentView()
}

#Preview {
    DataManagementPickerView()
}

