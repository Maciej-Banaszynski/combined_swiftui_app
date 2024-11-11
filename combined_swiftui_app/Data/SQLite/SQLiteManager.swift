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
    
    let id = Expression<UUID>("id")
    let firstName = Expression<String>("firstName")
    let lastName = Expression<String>("lastName")
    let birthday = Expression<Date>("birthday")
    let address = Expression<String>("address")
    let photo = Expression<Data?>("photo")
    let phoneNumber = Expression<String>("phoneNumber")
    let position = Expression<String>("position")
    let company = Expression<String>("company")
    
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
