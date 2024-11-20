//
//  AxisFormatters.swift
//  combined_swiftui_app
//
//  Created by Maciej Banaszyński on 20/11/2024.
//

import Foundation
import DGCharts

class DateValueFormatter: AxisValueFormatter {
    private let formatter: DateFormatter
    
    init() {
        self.formatter = DateFormatter()
        self.formatter.dateFormat = "MMM d\nhh:mm"
    }
    
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        let date = Date(timeIntervalSince1970: value)
        let calendar = Calendar.current
        
        // Round to the nearest hour
        let components = calendar.dateComponents([.year, .month, .day, .hour], from: date)
        if let roundedDate = calendar.date(from: components) {
            return formatter.string(from: roundedDate)
        }
        return ""
    }
}

class MonthValueFormatter: AxisValueFormatter {
    private let formatter: DateFormatter
    
    init() {
        self.formatter = DateFormatter()
        self.formatter.dateFormat = "MMM yyyy" // Example: "Nov 2024"
    }
    
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        let date = Date(timeIntervalSince1970: value)
        return formatter.string(from: date)
    }
}
