//
//  SymbolPickerItem.swift
//  Distance and Interval Notfier
//
//  Created by Stefan Berger on 17.05.24.
//

import Foundation
import SwiftUI

struct SymbolPickerItem: View {
    
    @Environment(\.colorScheme)
    private var colorScheme
    
    let symbolIndex: Int
    let selectedSymbolIndex: String
    
    init(symbolIndex: Int, selectedSymbolIndex: String) {
        self.symbolIndex = symbolIndex
        self.selectedSymbolIndex = selectedSymbolIndex
    }
    
    var body: some View {
        ZStack {
            if (selectedSymbolIndex == Constants.AVAILABLE_SYMBOLS[symbolIndex]) {
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
