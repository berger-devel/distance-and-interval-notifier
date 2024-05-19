//
//  ColorPickerItem.swift
//  Distance and Interval Notfier
//
//  Created by Stefan Berger on 17.05.24.
//

import Foundation
import SwiftUI

struct ColorPickerItem: View {
    
    private let colorIndex: Int
    private let selected: Bool
    
    init(colorIndex: Int, selected: Bool) {
        self.colorIndex = Int(colorIndex)
        self.selected = selected
    }
    
    var body: some View {
        ZStack {
            if(selected) {
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
