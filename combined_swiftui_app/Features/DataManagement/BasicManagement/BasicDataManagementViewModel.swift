//
//  BasicDataManagementViewModel.swift
//  combined_swiftui_app
//
//  Created by Maciej Banaszyński on 10/11/2024.
//

import SwiftUI
import Combine
import SwiftData

enum DataUserFetchingMode { case loading, loaded, none }

class BasicDataViewModel: ObservableObject {
    private let repository: UserRepositoryProtocol
    @Published var users: [User] = []
    @Published var userCount: Int = 0
    @Published var dataUserFetchingMode: DataUserFetchingMode = .none
    
    init(repository: UserRepositoryProtocol) {
        self.repository = repository
        loadUserCount()
    }
    
    func loadUserCount() {
        DispatchQueue.main.async { [weak self] in
            self?.userCount = self?.repository.getUserCount() ?? 0
        }
        
    }
    func loadUsers() {
        DispatchQueue.main.async { [weak self] in
            self?.dataUserFetchingMode = .loading
            self?.users = self?.repository.getAllUsers() ?? []
            self?.dataUserFetchingMode = .loaded
        }
        
    }
    
    func generateUsers(count: Int) {
        let newUsers = (0..<count).map { _ in
            User(
                firstName: "John",
                lastName: "Doe",
                birthday: Date(),
                address: "123 Main St",
                phoneNumber: "123-456-7890",
                position: "Engineer",
                company: "Tech Inc"
            )
        }
        if repository.addUsers(newUsers) {
            loadUserCount()
        }
    }
    
    func deleteAllUsers() {
        if repository.deleteAllUsers() {
            loadUserCount()
            users = []
            loadUsers()
        }
    }
}

