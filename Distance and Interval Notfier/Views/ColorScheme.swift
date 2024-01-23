//
//  ColorScheme.swift
//  Distance and Interval Notfier
//
//  Created by Stefan Berger on 16.08.22.
//

import Foundation
import SwiftUI

struct ColorScheme {
    
    private static let AVAILABLE_COLORS: [Color] = [.blue, .red, .green, .yellow, .black, .cyan, .brown, .indigo, .mint, .orange, .purple, .gray, .pink, .teal]
    static var ICON_COLOR_COUNT = AVAILABLE_COLORS.count
    static func ICON_COLOR(_ index: Int) -> Color { AVAILABLE_COLORS[Int(index)] }
    static var ICON_FOREGROUND_COLOR = { colorScheme in colorScheme == SwiftUI.ColorScheme.light ? Color.white : Color(.systemGray5) }
    
    static var QUANTITY_ICON_GREY = Color(.systemYellow)
    static var TIME_ICON_COLOR = STARTBUTTON_COLOR
    static var DISTANCE_ICON_COLOR1 = Color(red: 53/255, green: 199/255, blue: 98/255)
    
    static var BACKGROUND_COLOR = { colorScheme in colorScheme == SwiftUI.ColorScheme.light ? Color(.systemGray6) : Color(.black) }
    
    static var STARTBUTTON_OUTER_OUTLINE_GRADIENT = LinearGradient(
        colors: [Color(.systemGray6), Color(.systemGray2)],
        startPoint: .topLeading,
        endPoint: .bottom
    )
    
    static var STARTBUTTON_INNER_OUTLINE_GRADIENT = LinearGradient(
        colors: [Color.white, Color.black],
        startPoint: .topLeading,
        endPoint: .bottom
    )
    
    static var STARTBUTTON_COLOR = Color(red: 0.0, green: 122/255, blue: 1.0)
    static var STARTBUTTON_GRADIENT = LinearGradient(colors: [
        STARTBUTTON_COLOR,
        Color(red: 3/255, green: 76/255, blue: 160/255)
    ], startPoint: .topLeading, endPoint: .bottom)
    
    static var STOPBUTTON_COLOR = Color(red: 1.0, green: 59/255, blue: 49/255)
    static var STOPBUTTON_GRADIENT = LinearGradient(colors: [
        STOPBUTTON_COLOR,
        Color(red: 190/255, green: 44/255, blue: 38/255)
    ], startPoint: .topLeading, endPoint: .bottom)
    
    static var STARTBUTTON_TEXT_COLOR = Color.white
    
    static let LIST_ITEM_TEXT_COLOR = Color.primary
    
    private static let LIST_ROW_BACKGROUND_DARK = Color(red: 0.1725, green: 0.1725, blue: 0.1804)
    static let LIST_ROW_BACKGROUND = { colorScheme in colorScheme == SwiftUI.ColorScheme.light ? .white : LIST_ROW_BACKGROUND_DARK }
    
    static let SYMBOL_PICKER_SELECTION_MARKER_COLOR = Color(red: 0.4157, green: 0.4157, blue: 0.4196)
    static let PICKER_SYMBOL_COLOR = { colorScheme in
        colorScheme == SwiftUI.ColorScheme.light ? Color(red: 0.251, green: 0.251, blue: 0.2549) : Color(red: 0.7451, green: 0.7451, blue: 0.7490)
    }
    
    static var GRAY_OVERLAY = { colorScheme in
        ZStack {
            if colorScheme == SwiftUI.ColorScheme.light {
                Color.white.opacity(0.4)
                Color.black.opacity(0.02)
            } else {
                LIST_ROW_BACKGROUND_DARK.opacity(0.4)
                Color(white: 1, opacity: 0.02)
            }
        }
    }
}
