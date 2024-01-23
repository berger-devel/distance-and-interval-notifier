//
//  WorkoutColorPicker.swift
//  Distance and Interval Notfier
//
//  Created by Stefan Berger on 24.08.22.
//

import Foundation
import SwiftUI

struct ColorPicker: View {
    
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
        VStack(spacing: 0) {
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
        .frame(maxWidth: .infinity)
    }
    
    private struct ColorPickerItem: View {
        
        private let colorIndex: Int
        private let selected: Int
        
        init(colorIndex: Int, selected: Int) {
            self.colorIndex = Int(colorIndex)
            self.selected = selected
        }
        
        var body: some View {
            ZStack {
                if(selected == colorIndex) {
                    Circle()
                        .stroke(ColorScheme.ICON_COLOR(colorIndex), lineWidth: Constants.PICKER_SELECTION_MARKER_LINE_WIDTH)
                        .frame(width: Constants.PICKER_SELECTION_MARKER_FRAME_SIZE, height: Constants.PICKER_SELECTION_MARKER_FRAME_SIZE)
                }

                Circle()
                    .fill(ColorScheme.ICON_COLOR(colorIndex))
                    .frame(width: Constants.PICKER_COLOR_ITEM_SIZE_PADDED, height: Constants.PICKER_COLOR_ITEM_SIZE_PADDED)
            }
            .frame(width: Constants.PICKER_ITEM_SIZE, height: Constants.PICKER_ITEM_SIZE)
        }
    }
}
