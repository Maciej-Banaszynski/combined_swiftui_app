//
//  UserProfileTile.swift
//  combined_swiftui_app
//
//  Created by Maciej Banaszyński on 10/11/2024.
//

import SwiftUI

struct UserProfileTile: View {
    let user: User
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                if let photoData = user.photo, let image = UIImage(data: photoData) {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 60, height: 60)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.gray, lineWidth: 1))
                } else {
                    Circle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(width: 60, height: 60)
                        .overlay(Text(user.firstName.prefix(1) + user.lastName.prefix(1))
                            .foregroundColor(.gray)
                            .font(.headline))
                }
                
                VStack(alignment: .leading) {
                    Text("\(user.firstName) \(user.lastName)")
                        .font(.headline)
                        .foregroundColor(.primary)
                    Text(user.position)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
            
            Divider()
            
            VStack(alignment: .leading, spacing: 4) {
                Text("Company: \(user.company)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Text("Phone: \(user.phoneNumber)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Text("Address: \(user.address)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Text("Birthday: \(formattedDate(user.birthday))")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .padding(.leading, 4)
        }
        .padding()
        .background(Color(UIColor.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 4)
    }
    
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}


#Preview {
    UserProfileTile(user: User(
        firstName: "John",
        lastName: "Doe",
        birthday: Date(),
        address: "123 Main St",
        phoneNumber: "123-456-7890",
        position: "Engineer",
        company: "Tech Inc"
    ))
}
