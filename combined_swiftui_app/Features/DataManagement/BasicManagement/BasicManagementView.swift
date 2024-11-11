//
//  BasicManagementView.swift
//  combined_swiftui_app
//
//  Created by Maciej Banaszyński on 10/11/2024.
//

import SwiftUI
import SwiftData

struct DataManagementView: View {
    @StateObject private var viewModel: BasicDataViewModel
    @State private var isLoading: Bool = false
    @State var isSQLiteView: Bool
    
    init(viewModel: BasicDataViewModel, isSQLiteView: Bool = false) {
        _viewModel = StateObject(wrappedValue: viewModel)
        self.isSQLiteView = isSQLiteView
    }
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        VStack(spacing: 10) {
            Text("User Count: \(viewModel.userCount)")
                .font(.title)
            Text("Generate users:")
            LazyVGrid(columns: columns, spacing: 10) {
                ForEach([10, 100, 1000, 10000, 30000], id: \.self) { count in
                    Button(action: { performAction { viewModel.generateUsers(count: count) } }, label: {
                        Text("\(count)")
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    })
                    .disabled(isLoading)
                    .buttonStyle(.borderedProminent)
                    
                }
                Button(action: { performAction { viewModel.deleteAllUsers() } }, label: {
                    Text("Delete All")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                })
                .disabled(isLoading)
                .buttonStyle(.borderedProminent)
                .tint(.red)
               
            }
            .padding()
            if !viewModel.users.isEmpty {
                NavigationLink {
                    ScrollView {
                        LazyVGrid(columns: [GridItem(.flexible()),GridItem(.flexible())]) {
                            ForEach(viewModel.users, id: \.id) { user in
                                UserProfileTile(user: user)
                                    .padding(6)
                            }
                        }
                    }
                } label: {
                    Text("See All Users")
                        .frame(maxWidth: .infinity)
                }
                .navigationTitle("Users List")
                .buttonStyle(.borderedProminent)
                .padding()
            }
            Spacer()
        }
        .onAppear {
            viewModel.loadUserCount()
            viewModel.loadUsers()
        }
        .navigationTitle("\(isSQLiteView ? "SQLite" : "Swift") Data Managament")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                }
            }
        }
    }
    
    private func performAction(_ action: @escaping () -> Void) {
        isLoading = true
        DispatchQueue.global().async {
            action()
            DispatchQueue.main.async {
                isLoading = false
            }
        }
    }
    
    
}

struct SwiftDataManagementDestinationView: View {
    var body: some View {
        if let modelContainer = try? ModelContainer(for: User.self) {
            let modelContext = modelContainer.mainContext
            let userDAO = SwiftDataUserDAO(modelContext: modelContext)
            let userRepository = SwiftDataUserRepository(userDAO: userDAO)
            let viewModel = BasicDataViewModel(repository: userRepository)
            
            DataManagementView(viewModel: viewModel)
                .environment(\.modelContext, modelContext)
        } else {
            Text("Failed to initialize data storage.")
        }
    }
}

#Preview {
    ContentView()
}

#Preview {
    SwiftDataManagementDestinationView()
}
