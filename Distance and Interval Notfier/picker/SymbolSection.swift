//
//  SymbolSection.swift
//  Distance and Interval Notfier
//
//  Created by Stefan Berger on 24.08.22.
//

import Foundation
import SwiftUI

struct SymbolSection: View {
    
    @Environment(\.colorScheme)
    private var colorScheme
    
    private let itemCountPerRow: Int
    private let rowCount: Int
    
    @Binding
    private var sfSymbol: String
    
    init(sfSymbol: Binding<String>, width: CGFloat) {
        self._sfSymbol = sfSymbol
        
        let itemCountPerRow = width / Constants.PICKER_ITEM_SIZE
        self.itemCountPerRow = Int(itemCountPerRow)
        self.rowCount = Int(ceil(CGFloat(Constants.AVAILABLE_SYMBOLS.count) / itemCountPerRow))
    }
    
    var body: some View {
        Section("Symbol") {
            VStack(spacing: 0) {
                if rowCount > 0 {
                    ForEach(0 ..< rowCount, id: \.self) { lineIndex in
                        HStack(spacing: 0) {
                            ForEach(0 ..< min(itemCountPerRow, Constants.AVAILABLE_SYMBOLS.count - lineIndex * itemCountPerRow), id: \.self) { index in
                                SymbolPickerItem(symbolIndex: lineIndex * itemCountPerRow + index, selectedSymbolIndex: sfSymbol)
                                    .onTapGesture {
                                        sfSymbol = Constants.AVAILABLE_SYMBOLS[lineIndex * itemCountPerRow + index]
                                    }
                            }
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity)
            .listRowBackground(ColorScheme.LIST_ROW_BACKGROUND(colorScheme))
        }
    }
}
