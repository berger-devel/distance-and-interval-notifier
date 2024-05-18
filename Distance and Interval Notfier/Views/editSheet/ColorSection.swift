//
//  ColorSection.swift
//  Distance and Interval Notfier
//
//  Created by Stefan Berger on 24.08.22.
//

import Foundation
import SwiftUI

struct ColorSection: View {
    
    @Environment(\.colorScheme)
    private var colorScheme
    
    private let itemCountPerRow: Int
    private let rowCount: Int
    
    @Binding
    private var selectedColorIndex: Int
    
    init(width: CGFloat, selectedColorIndex: Binding<Int>) {
        self._selectedColorIndex = selectedColorIndex
        
        let itemCountPerRow = width / Constants.PICKER_ITEM_SIZE
        self.itemCountPerRow = Int(itemCountPerRow)
        self.rowCount = Int(ceil(CGFloat(ColorScheme.ICON_COLOR_COUNT) / itemCountPerRow))
    }
    
    var body: some View {
        Section("Color") {
            VStack(spacing: 0) {
                if rowCount > 0 {
                    ForEach(0 ..< rowCount, id: \.self) { lineIndex in
                        HStack(spacing: 0) {
                            ForEach(0 ..< min(itemCountPerRow, ColorScheme.ICON_COLOR_COUNT - lineIndex * itemCountPerRow), id: \.self) { index in
                                ColorPickerItem(colorIndex: lineIndex * itemCountPerRow + index, selected: selectedColorIndex)
                                    .onTapGesture {
                                        selectedColorIndex = lineIndex * itemCountPerRow + index
                                    }
                            }
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity)
        }
        .listRowBackground(ColorScheme.LIST_ROW_BACKGROUND(colorScheme))
    }
}
