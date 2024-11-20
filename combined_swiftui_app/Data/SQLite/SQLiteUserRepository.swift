//
//  SQLiteUserRepository.swift
//  combined_swiftui_app
//
//  Created by Maciej Banaszyński on 10/11/2024.
//

import Foundation
import SQLite

class SQLiteUserRepository: UserRepositoryProtocol {
    private let userDAO: UserDAOProtocol
    
    init(userDAO: SQLiteUserDAO) {
        self.userDAO = userDAO
    }
    
    func getAllUsers() -> [User] {
        userDAO.fetchAll()
    }
    
    func getLeads() -> [User] {
        userDAO.getLeads()
    }
    
    func getUser(byId id: UUID) -> User? {
        userDAO.fetchById(id: id)
    }
    
    func addUser(_ user: User) -> Bool {
        return userDAO.insert(user: user)
    }
    
    func addUsers(_ users: [User]) -> Bool {
        do {
            return try userDAO.insertMultiple(users: users)
        } catch {
            return false
        }
    }
    
    func updateUser(_ user: User) -> Bool {
        return userDAO.update(user: user)
    }
    
    func deleteUser(_ user: User) -> Bool {
        return userDAO.delete(user: user)
    }
    
    func deleteAllUsers() -> Bool {
        do {
            return try userDAO.deleteAll()
        } catch {
            return false
        }
    }
    
    func getUserCount() -> Int {
        return userDAO.count()
    }
}
