//
//  GeneratedUsersCount.swift
//  combined_swiftui_app
//
//  Created by Maciej Banaszyński on 19/11/2024.
//

import Foundation

enum GeneratedUsersCount: CaseIterable {
    case thousand
    case tenThousand
    case thirtyThousand
    
    var filePath: String {
        switch self {
            case .thousand:
                return "assets/1000.csv"
            case .tenThousand:
                return "assets/10000.csv"
            case .thirtyThousand:
                return "assets/30000.csv"
        }
    }
    
    var displayName: String {
        switch self {
            case .thousand: return "1000"
            case .tenThousand: return "10000"
            case .thirtyThousand: return "30000"
        }
    }
    
    var accessibilityIdentifier: String {
        switch self {
            case .thousand: return "create1000EntriesButton"
            case .tenThousand: return "create10000EntriesButton"
            case .thirtyThousand: return "create30000EntriesButton"
        }
    }
    
    var count: Int {
        switch self {
            case .thousand: return 1000
            case .tenThousand: return 10000
            case .thirtyThousand: return 30000
        }
    }
}
