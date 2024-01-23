//
//  WorkoutSymbolPicker.swift
//  Distance and Interval Notfier
//
//  Created by Stefan Berger on 24.08.22.
//

import Foundation
import SwiftUI

struct SymbolPicker: View {
    
    private let itemCountPerRow: Int
    private let rowCount: Int
    
    @Binding
    private var selectedSymbol: String
    
    init(width: CGFloat, selectedSymbol: Binding<String>) {
        self._selectedSymbol = selectedSymbol
        
        let itemCountPerRow = width / Constants.PICKER_ITEM_SIZE
        self.itemCountPerRow = Int(itemCountPerRow)
        self.rowCount = Int(ceil(CGFloat(Constants.AVAILABLE_SYMBOLS.count) / itemCountPerRow))
    }
    
    var body: some View {
        VStack(spacing: 0) {
            ForEach(0 ..< rowCount, id: \.self) { lineIndex in
                HStack(spacing: 0) {
                    ForEach(0 ..< min(itemCountPerRow, Constants.AVAILABLE_SYMBOLS.count - lineIndex * itemCountPerRow), id: \.self) { index in
                        SymbolPickerItem(symbolIndex: lineIndex * itemCountPerRow + index, selected: selectedSymbol)
                            .onTapGesture {
                                selectedSymbol = Constants.AVAILABLE_SYMBOLS[lineIndex * itemCountPerRow + index]
                            }
                    }
                }
            }
        }
        .frame(maxWidth: .infinity)
    }
    
    private struct SymbolPickerItem: View {
        
        @Environment(\.colorScheme)
        private var colorScheme
        
        let symbolIndex: Int
        let selected: String
        
        var body: some View {
            ZStack {
                if (selected == Constants.AVAILABLE_SYMBOLS[symbolIndex]) {
                    Circle()
                        .stroke(ColorScheme.SYMBOL_PICKER_SELECTION_MARKER_COLOR, lineWidth: Constants.PICKER_SELECTION_MARKER_LINE_WIDTH)
                        .frame(width: Constants.PICKER_SELECTION_MARKER_FRAME_SIZE, height: Constants.PICKER_SELECTION_MARKER_FRAME_SIZE)
                }
                
                Image(systemName: Constants.AVAILABLE_SYMBOLS[symbolIndex])
                    .font(.system(size: Constants.PICKER_SYMBOL_ITEM_SIZE_PADDED))
                    .foregroundColor(ColorScheme.PICKER_SYMBOL_COLOR(colorScheme))
            }
            .frame(width: Constants.PICKER_ITEM_SIZE, height: Constants.PICKER_ITEM_SIZE)
        }
    }
}
