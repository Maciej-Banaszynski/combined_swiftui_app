//
//  User.swift
//  combined_swiftui_app
//
//  Created by Maciej Banaszyński on 10/11/2024.
//

import SwiftData
import Foundation

@Model
class User {
    @Attribute(.unique) var id: UUID
    var firstName: String
    var lastName: String
    var birthday: Date
    var address: String
    var photo: Data?
    var phoneNumber: String
    var position: String
    var company: String
    
    init(id: UUID = UUID(), firstName: String, lastName: String, birthday: Date, address: String, photo: Data? = nil, phoneNumber: String, position: String, company: String) {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.birthday = birthday
        self.address = address
        self.photo = photo
        self.phoneNumber = phoneNumber
        self.position = position
        self.company = company
    }
}

