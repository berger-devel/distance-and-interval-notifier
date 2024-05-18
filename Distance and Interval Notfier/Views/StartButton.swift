//
//  PortraitStartButton.swift
//  Distance and Interval Notfier
//
//  Created by Stefan Berger on 26.03.23.
//

import Foundation
import SwiftUI

struct StartButton: View {
    
    @Environment(\.colorScheme)
    private var colorScheme
    
    var isRunning: Binding<Bool>
    var start: () -> ()
    var stop: () -> ()
    
    var body: some View {
        HStack {
            if isRunning.wrappedValue == true {
                Button(action: stop) {
                    ZStack {
                        Circle()
                            .fill(ColorScheme.STOPBUTTON_GRADIENT)
                        Text("Stop")
                            .foregroundColor(ColorScheme.STARTBUTTON_TEXT_COLOR)
                            .font(.system(size: Constants.STARTBUTTON_FONT_SIZE))
                        
                        Circle()
                            .stroke(style: .init(lineWidth: 7))
                            .fill(ColorScheme.STARTBUTTON_OUTER_OUTLINE_GRADIENT)
                            .frame(width: 95)
                        
                        Circle()
                            .stroke(style: .init(lineWidth: 1))
                            .fill(ColorScheme.STARTBUTTON_INNER_OUTLINE_GRADIENT)
                            .frame(width: 88)
                    }
                    .frame(width: 100)
                }
            } else {
                Button(action: start) {
                    ZStack {
                        Circle()
                            .fill(ColorScheme.STARTBUTTON_GRADIENT)
                        
                        Circle()
                            .stroke(style: .init(lineWidth: 7))
                            .fill(ColorScheme.STARTBUTTON_OUTER_OUTLINE_GRADIENT)
                            .frame(width: 95)
                        
                        Circle()
                            .stroke(style: .init(lineWidth: 1))
                            .fill(ColorScheme.STARTBUTTON_INNER_OUTLINE_GRADIENT)
                            .frame(width: 88)
                        
                        Text("Start")
                            .foregroundColor(ColorScheme.STARTBUTTON_TEXT_COLOR)
                            .font(.system(size: Constants.STARTBUTTON_FONT_SIZE))
                    }
                    .frame(width: 100)
                }
            }
        }
        .padding([.bottom], 30)
        .frame(maxWidth: .infinity, maxHeight: 140)
        .background(ColorScheme.BACKGROUND_COLOR(colorScheme))
        .ignoresSafeArea()
    }
}
