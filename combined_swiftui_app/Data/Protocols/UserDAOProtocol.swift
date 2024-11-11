//
//  UserDAOProtocol.swift
//  combined_swiftui_app
//
//  Created by Maciej Banaszyński on 10/11/2024.
//

import Foundation

protocol UserDAOProtocol {
    func fetchAll() -> [User]
    func fetchById(id: UUID) -> User?
    func insert(user: User) -> Bool
    func insertMultiple(users: [User]) throws -> Bool
    func update(user: User) -> Bool
    func delete(user: User) -> Bool
    func deleteAll() throws -> Bool
    func count() -> Int
}
