//
//  SQLiteUserDao.swift
//  combined_swiftui_app
//
//  Created by Maciej Banaszyński on 10/11/2024.
//

import Foundation
import SQLite

class SQLiteUserDAO: UserDAOProtocol {
    private let db: Connection?
    private let usersTable = Table("users")
    
    private let id = Expression<UUID>(value: "id")
    private let firstName = Expression<String>(value: "firstName")
    private let lastName = Expression<String>(value: "lastName")
    private let birthday = Expression<Date>(value: "birthday")
    private let address = Expression<String>(value: "address")
    private let photo = Expression<Data?>(value: "photo")
    private let phoneNumber = Expression<String>(value: "phoneNumber")
    private let position = Expression<String>(value: "position")
    private let company = Expression<String>(value: "company")
    
    init() {
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        db = try? Connection("\(path)/db.sqlite3")
        createTable()
    }
    
    private func createTable() {
        guard let db = db else { return }
        do {
            try db.run(usersTable.create(ifNotExists: true) { t in
                t.column(id, primaryKey: true)
                t.column(firstName)
                t.column(lastName)
                t.column(birthday)
                t.column(address)
                t.column(photo)
                t.column(phoneNumber)
                t.column(position)
                t.column(company)
            })
        } catch {
            print("Failed to create table: \(error)")
        }
    }
    
    func fetchAll() -> [User] {
        var users: [User] = []
//        guard let db = db else { return users }
//        do {
//            for row in try db.prepare(usersTable) {
//                let user = User(
//                    id: row[id],
//                    firstName: row[firstName],
//                    lastName: row[lastName],
//                    birthday: row[birthday],
//                    address: row[address],
//                    photo: row[photo],
//                    phoneNumber: row[phoneNumber],
//                    position: row[position],
//                    company: row[company]
//                )
//                users.append(user)
//            }
//        } catch {
//            print("Failed to fetch users: \(error)")
//        }
        return users
    }
    
    func getLeads() -> [User] {
        return []
    }
    
    func fetchById(id: UUID) -> User? {
        guard let db = db else { return nil }
//        let query = usersTable.filter(self.id == id)
//        do {
//            if let row = try db.pluck(query) {
//                return User(
//                    id: row[self.id],
//                    firstName: row[firstName],
//                    lastName: row[lastName],
//                    birthday: row[birthday],
//                    address: row[address],
//                    photo: row[photo],
//                    phoneNumber: row[phoneNumber],
//                    position: row[position],
//                    company: row[company]
//                )
//            }
//        } catch {
//            print("Failed to fetch user by ID: \(error)")
//        }
        return nil
    }
    
    func insert(user: User) -> Bool {
        guard let db = db else { return false }
//        let insert = usersTable.insert(
//            id <- user.id,
//            firstName <- user.firstName,
//            lastName <- user.lastName,
//            birthday <- user.birthday,
//            address <- user.address,
//            photo <- user.photo,
//            phoneNumber <- user.phoneNumber,
//            position <- user.position,
//            company <- user.company
//        )
//        do {
//            try db.run(insert)
            return true
//        } catch {
//            print("Failed to insert user: \(error)")
//            return false
//        }
    }
    
    func insertMultiple(users: [User]) throws -> Bool {
        guard let db = db else { return false }
        do {
            try db.transaction {
                for user in users {
                    _ = self.insert(user: user)
                }
            }
            return true
        } catch {
            print("Failed to insert multiple users: \(error)")
            throw error
        }
    }
    
    func update(user: User) -> Bool {
        guard let db = db else { return false }
//        let userToUpdate = usersTable.filter(id == user.id)
//        do {
//            try db.run(userToUpdate.update(
//                firstName <- user.firstName,
//                lastName <- user.lastName,
//                birthday <- user.birthday,
//                address <- user.address,
//                photo <- user.photo,
//                phoneNumber <- user.phoneNumber,
//                position <- user.position,
//                company <- user.company
//            ))
            return true
//        } catch {
//            print("Failed to update user: \(error)")
//            return false
//        }
    }
    
    func delete(user: User) -> Bool {
        guard let db = db else { return false }
//        let userToDelete = usersTable.filter(id == user.id)
//        do {
//            try db.run(userToDelete.delete())
            return true
//        } catch {
//            print("Failed to delete user: \(error)")
//            return false
//        }
    }
    
    func deleteAll() throws -> Bool {
        guard let db = db else { return false }
        do {
            try db.run(usersTable.delete())
            return true
        } catch {
            print("Failed to delete all users: \(error)")
            throw error
        }
    }
    
    func count() -> Int {
        guard let db = db else { return 0 }
        do {
            return try db.scalar(usersTable.count)
        } catch {
            print("Failed to count users: \(error)")
            return 0
        }
    }
}
