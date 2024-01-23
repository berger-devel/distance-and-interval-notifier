//
//  Symbol.swift
//  Distance and Interval Notfier
//
//  Created by Stefan Berger on 24.03.23.
//

import Foundation
import SwiftUI

struct Icon: View {
    
    @Environment(\.colorScheme)
    private var colorScheme: SwiftUI.ColorScheme
    
    private var sfSymbol: String
    private var color: Color
    private var small: Bool
    
    init(sfSymbol: String, color: Color, small: Bool = false) {
        self.sfSymbol = sfSymbol
        self.color = color
        self.small = small
    }
    
    var body: some View {
        ZStack {
            Circle()
                .fill(color)
                .frame(width: small ? Constants.ICON_SIZE_SMALL : Constants.ICON_SIZE)
            
            Image(systemName: sfSymbol)
                .foregroundColor(ColorScheme.ICON_FOREGROUND_COLOR(colorScheme))
                .font(.system(size: small ? Constants.SF_SYMBOL_SIZE_SMALL : Constants.SF_SYMBOL_SIZE))
        }
    }
}
