//
//  UserRepository.swift
//  combined_swiftui_app
//
//  Created by Maciej Banaszyński on 10/11/2024.
//

import Foundation

import CoreData

protocol UserRepositoryProtocol {
    func getAllUsers() -> [User]
    func getUser(byId id: UUID) -> User?
    func addUser(_ user: User) -> Bool
    func addUsers(_ users: [User]) -> Bool
    func updateUser(_ user: User) -> Bool
    func deleteUser(_ user: User) -> Bool
    func deleteAllUsers() -> Bool
    func getUserCount() -> Int
}
