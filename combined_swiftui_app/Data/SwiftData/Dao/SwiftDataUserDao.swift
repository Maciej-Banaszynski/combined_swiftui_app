//
//  UserDataDao.swift
//  combined_swiftui_app
//
//  Created by Maciej Banaszyński on 10/11/2024.
//

import SwiftData
import Foundation

class SwiftDataUserDAO: UserDAOProtocol {
    private let modelContext: ModelContext
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    func fetchAll() -> [User] {
        let request = FetchDescriptor<User>()
        return (try? modelContext.fetch(request)) ?? []
    }
    
    func getLeads() -> [User] {
        let request = FetchDescriptor<User>(predicate: #Predicate<User> { $0.position.contains("lead") ||  $0.position.contains("Lead") })
        return (try? modelContext.fetch(request)) ?? []
    }

    
    func fetchById(id: UUID) -> User? {
        let request = FetchDescriptor<User>(predicate: #Predicate { $0.id == id })
        return try? modelContext.fetch(request).first
    }
    
    func insert(user: User) -> Bool {
        modelContext.insert(user)
        return saveContext()
    }
    
    func insertMultiple(users: [User]) throws -> Bool {
        guard !users.isEmpty else { return false }
        let chunkSize: Int = 1000
        
        try stride(from: 0, to: users.count, by: chunkSize).forEach { start in
            let end = min(start + chunkSize, users.count)
            users[start..<end].forEach { modelContext.insert($0) }
            try modelContext.save()
        }
        
        return true
    }

    
    func update(user: User) -> Bool {
        return saveContext()
    }
    
    func delete(user: User) -> Bool {
        modelContext.delete(user)
        return saveContext()
    }
    
    func deleteAll() throws -> Bool {
        try modelContext.delete(model: User.self, where: nil, includeSubclasses: true)
        return saveContext()
    }
    
    func count() -> Int {
        return fetchAll().count
    }
    
    private func saveContext() -> Bool {
        do {
            try modelContext.save()
            return true
        } catch {
            print("Failed to save context: \(error)")
            return false
        }
    }
}
