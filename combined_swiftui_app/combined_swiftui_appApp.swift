//
//  combined_swiftui_appApp.swift
//  combined_swiftui_app
//
//  Created by Maciej Banaszyński on 10/11/2024.
//

import SwiftUI

@main
struct combined_swiftui_appApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(for: [User.self])
        }
    }
}
