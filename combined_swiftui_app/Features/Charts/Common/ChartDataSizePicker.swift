//
//  ChartDataSizePicker.swift
//  combined_swiftui_app
//
//  Created by Maciej Banaszyński on 20/11/2024.
//

import SwiftUI

struct ChartDataSizePicker: View {
    @Binding var dataSize: DataSize
    var dataSizeValues: [DataSize]
    var title: String
    var onChange: () -> Void
    
    var body: some View {
        Picker(title, selection: $dataSize) {
            ForEach(dataSizeValues, id: \.self) { dataSize in
                Text("\(dataSize.rawValue)").tag(dataSize)
            }
        }
        .pickerStyle(SegmentedPickerStyle())
        .padding()
        .onChange(of: dataSize) { onChange() }
    }
}
