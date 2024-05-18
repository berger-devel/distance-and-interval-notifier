//
//  EditSheetIcon.swift
//  Distance and Interval Notfier
//
//  Created by Stefan Berger on 16.05.24.
//

import Foundation
import SwiftUI

struct EditSheetIcon: View {
    
    @Environment(\.colorScheme)
    private var colorScheme
    
    private let sfSymbol: String
    private let colorIndex: Int
    
    init(sfSymbol: String, colorIndex: Int) {
        self.sfSymbol = sfSymbol
        self.colorIndex = colorIndex
    }
    
    var body: some View {
        HStack(spacing: 0) {
            Spacer()
            
            ZStack {
                Circle()
                    .fill(ColorScheme.ICON_COLOR(colorIndex))
                    .frame(width: Constants.ICON_PREVIEW_SIZE, height: Constants.ICON_PREVIEW_SIZE)
                
                Image(systemName: sfSymbol)
                    .foregroundColor(Color(.systemBackground))
                    .font(.system(size: Constants.ICON_PREVIEW_FONT_SIZE))
            }
            
            Spacer()
        }
        .padding(.vertical)
        .listRowBackground(ColorScheme.BACKGROUND_COLOR(colorScheme))
        .frame(maxHeight: Constants.ICON_CONTAINER_SIZE)
    }
}
