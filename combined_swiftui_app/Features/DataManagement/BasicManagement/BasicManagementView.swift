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
    
    var body: some View {
        VStack(spacing: 10) {
            Text("User Count: \(viewModel.userCount)")
                .font(.title)
            Text("Generate users:")
            ButtonsSection(viewModel: viewModel, isLoading: $isLoading)
            SeeUsersSection(viewModel: viewModel)
            Spacer()
        }
        .buttonStyle(.borderedProminent)
        .disabled(isLoading)
        .onAppear { Task {viewModel.loadUsers() }}
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
}

struct ButtonsSection: View {
    @ObservedObject var viewModel: BasicDataViewModel
    @Binding var isLoading: Bool
    
    var body: some View {
        LazyVGrid(columns: columns, spacing: 10) {
            ForEach(GeneratedUsersCount.allCases, id: \.self) { count in
                ViewButton(
                    isLoading: $isLoading,
                    action: { viewModel.loadUsersFromCSV(count: count) },
                    label: "\(count.displayName)"
                )
                .accessibilityIdentifier("\(count.accessibilityIdentifier)")
            }
            ViewButton(
                isLoading: $isLoading,
                action: { viewModel.loadLeadsUsers() },
                label: "Get only Leads"
            )
            .accessibilityIdentifier("getOnlyLeadUsersButton")
            ViewButton(
                isLoading: $isLoading,
                action: { viewModel.loadUsers() },
                label: "Get All"
            )
            .accessibilityIdentifier("getAllUsersButton")
            ViewButton(
                isLoading: $isLoading,
                action: { viewModel.deleteAllUsers() },
                label: "Delete All"
            )
            .tint(.red)
            .accessibilityIdentifier("deleteAllUsersButton")
        }
        .padding()
    }
    
    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
}

struct SeeUsersSection: View {
    @ObservedObject var viewModel: BasicDataViewModel
    
    var body: some View {
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
                Text("See Users")
                    .frame(maxWidth: .infinity)
            }
            .padding()
        }
    }
}

struct ViewButton: View {
    @Binding var isLoading: Bool
    let action: () -> Void
    let label: String
    
    var body: some View {
        Button(
            action: {
                isLoading = true
                Task.detached {
                    await performAction()
                }
            },
            label: {
                Text(label)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        )
        .disabled(isLoading)
    }
    
    private func performAction() async {
        await withTaskGroup(of: Void.self) { taskGroup in
            taskGroup.addTask {
//                await MetricsManager.shared.trackAction(actionName: label) {
                await action()
//                }
            }
        }
        DispatchQueue.main.async {
            isLoading = false
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
