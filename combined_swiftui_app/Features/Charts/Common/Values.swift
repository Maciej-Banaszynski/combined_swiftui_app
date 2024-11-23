//
//  Values.swift
//  combined_swiftui_app
//
//  Created by Maciej Banaszyński on 20/11/2024.
//

import Foundation

enum DataSize: Int, CaseIterable {
    case three = 3, five = 5, eight = 8, ten = 10, fifty = 50, hundred = 100,  oneThousand = 1000, tenThousand = 10000, oneHundredThousand = 100000
    
    static var lineChartValues: [DataSize] = [.ten, .fifty, .hundred, .oneThousand, .tenThousand, .oneHundredThousand]
    static var barChartValues: [DataSize] = [.three,.five, .eight, .ten, .fifty, .hundred]
}

enum DGChartType {
    case single, multi
    
    var lineTitle: String {
        switch self {
            case .single: return "Single Line Chart"
            case .multi: return "Multi Line Chart"
        }
    }
    
    var barTitle: String {
        switch self {
            case .single: return "Single Bar Chart"
            case .multi: return "Multi Bar Chart"
        }
    }
}

struct DataPoint: Identifiable {
    let id = UUID()
    let x: Date
    let y: Double
}

class ChartsManager {
    
    static func generateChartData(dataSize: DataSize, byAdding component: Calendar.Component = .day) -> [DataPoint] {
        let valueRange: ClosedRange<Double> = 0...100
        let calendar = Calendar.current
        let currentDate = Date()
        return (0..<dataSize.rawValue).map { index in
            let date = calendar.date(byAdding: component, value: -index, to: currentDate) ?? Date()
            let value = Double.random(in: valueRange)
            return DataPoint(x: date, y: value)
        }.reversed()
    }
}

