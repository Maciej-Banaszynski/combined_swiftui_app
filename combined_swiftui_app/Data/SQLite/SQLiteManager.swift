//
//  SQLiteManager.swift
//  combined_swiftui_app
//
//  Created by Maciej Banaszyński on 10/11/2024.
//

import Foundation
import SQLite

class SQLiteManager {
    static let shared = SQLiteManager()
    
    private(set) var db: Connection?
    private(set) var usersTable = Table("users")
    
    let id = Expression<UUID>(value: "id")
    let firstName = Expression<String>(value: "firstName")
    let lastName = Expression<String>(value: "lastName")
    let birthday = Expression<Date>(value: "birthday")
    let address = Expression<String>(value: "address")
    let photo = Expression<Data?>(value: "photo")
    let phoneNumber = Expression<String>(value: "phoneNumber")
    let position = Expression<String>(value: "position")
    let company = Expression<String>(value: "company")
    
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
}
