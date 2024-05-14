//
//  Constants.swift
//  Distance and Interval Notfier
//
//  Created by Stefan Berger on 18.08.22.
//

import Foundation
import SwiftUI

struct Constants {
    
    static let AVAILABLE_SYMBOLS = ["calendar", "figure.walk", "bicycle", "cloud.drizzle", "music.quarternote.3", "heart", "bolt", "camera", "house", "moon.fill", "arrowtriangle.forward", "lifepreserver", "hourglass", "waveform.path.ecg.rectangle", "hands.clap", "hand.point.right", "hand.thumbsup", "crown", "film", "tortoise", "hare", "lungs"]
    
    static let BOLD = Font.Weight.semibold
    
    static let ICON_SECTION_PADDING = 50.0
    static let COLOR_SECTION_HEIGHT = PICKER_ITEM_SIZE * 2
    
    static let DISTANCE_AMOUNTS_METER: [Double] = Array([10, 20] + stride(from: 50, through: 500, by: 50)) + Array(stride(from: 1000, through: 3000, by: 100))
    static let DISTANCE_AMOUNTS_KILOMETER: [Double] = Array(stride(from: 1.0, through: 20.0, by: 1.0)) + Array(stride(from:25.0, through: 40.0, by: 5.0)) + [42.195, 45.0, 50.0]
    static let DISTANCE_AMOUNTS_MILES: [Double] = Array(stride(from: 1.0, through: 10.0, by: 1)) + [15.0, 25.0, 26.219, 30.0]
      
    static let PICKER_COLOR_ITEM_SIZE_PADDED = PICKER_ITEM_SIZE * 0.8
    static let PICKER_ITEM_SIZE = 38.0
    static let PICKER_SELECTION_MARKER_LINE_WIDTH = 2.0
    static let PICKER_SELECTION_MARKER_FRAME_SIZE = PICKER_ITEM_SIZE - PICKER_SELECTION_MARKER_LINE_WIDTH
    static let PICKER_SYMBOL_ITEM_SIZE_PADDED = PICKER_ITEM_SIZE * 0.45

    static let SF_SYMBOL_SIZE = 25.0
    static let SF_SYMBOL_SIZE_SMALL = 10.0
    
    static let ICON_SIZE = 50.0
    static let ICON_SIZE_SMALL = 25.0
    static let ICON_CONTAINER_SIZE = 70.0
    
    static let ICON_PREVIEW_FONT_SIZE = 50.0
    static let ICON_PREVIEW_SIZE = 90.0
    
    static let ICON_SECTION_HEIGHT = PICKER_ITEM_SIZE * 3
    
    static let TIME_AMOUNTS_SECOND: [Double] = Array(stride(from: 10.0, through: 180.0, by: 10.0))
    static let TIME_AMOUNTS_MINUTE: [Double] = Array(stride(from: 1.0, through: 30.0, by: 1.0)) + Array(stride(from: 40.0, through: 60.0, by: 10.0)) + Array(stride(from: 90.0, through: 180.0, by: 30.0))
    static let TIME_AMOUNTS_HOUR: [Double] = Array(stride(from: 1.0, through: 5.0, by: 1.0))
    
    static let WORKOUT_LIST_ITEM_CORNER_RADIUS = 10.0
    static let WORKOUT_LIST_ITEM_HEIGHT = 72.5
    static let WORKOUT_LIST_SPACING = 15.0
    
    static var STARTBUTTON_FONT_SIZE = 24.0
}

enum OptionalError: Error {
    case from(_ identifier: String)
}
