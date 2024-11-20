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
    }
    
    func loadUserCount() {
        DispatchQueue.main.async { [weak self] in
            self?.dataUserFetchingMode = .loading
            self?.userCount = self?.repository.getUserCount() ?? 0
            self?.dataUserFetchingMode = .loaded
        }
    }
    
    func loadUsers() {
        DispatchQueue.main.async { [weak self] in
            self?.dataUserFetchingMode = .loading
            self?.users = self?.repository.getAllUsers() ?? []
            self?.userCount = self?.users.count ?? 0
            self?.dataUserFetchingMode = .loaded
        }
    }
    
    func loadLeadsUsers() {
        DispatchQueue.main.async { [weak self] in
            self?.dataUserFetchingMode = .loading
            self?.users = self?.repository.getLeads() ?? []
            self?.userCount = self?.users.count ?? 0
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
    
    func loadUsersFromCSV(count: GeneratedUsersCount) {
        guard let filePath = Bundle.main.path(forResource: "\(count.displayName)", ofType: "csv") else {
            print("Plik CSV nie został znaleziony dla ścieżki: \(count.filePath)")
            return
        }
        
        do {
            let csvString = try String(contentsOfFile: filePath, encoding: .utf8)
            let rows = csvString.components(separatedBy: "\n").map { $0.components(separatedBy: ",") }
            let users = rows.dropFirst().compactMap { row -> User? in
                guard row.count >= 7 else { return nil }
                
                return User(
                    firstName: row[0].trimmingCharacters(in: .whitespacesAndNewlines),
                    lastName: row[1].trimmingCharacters(in: .whitespacesAndNewlines),
                    birthday: ISO8601DateFormatter().date(from: row[2].trimmingCharacters(in: .whitespacesAndNewlines)) ?? Date(),
                    address: row[3].trimmingCharacters(in: .whitespacesAndNewlines),
                    phoneNumber: row[4].trimmingCharacters(in: .whitespacesAndNewlines),
                    position: row[5].trimmingCharacters(in: .whitespacesAndNewlines),
                    company: row[6].trimmingCharacters(in: .whitespacesAndNewlines)
                )
            }
            
            if repository.addUsers(users) {
                loadUserCount()
            }
        } catch {
            print("Błąd podczas wczytywania pliku CSV: \(error)")
        }
    }
    
    func deleteAllUsers() {
        DispatchQueue.main.async { [weak self] in
            if self?.repository.deleteAllUsers() == true {
                self?.loadUserCount()
                self?.users = []
                self?.loadUsers()
            }
        }
    }
}

