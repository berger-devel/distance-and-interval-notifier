//
//  ExerciseListConditionalToolbarItem.swift
//  Distance and Interval Notfier
//
//  Created by Stefan Berger on 23.05.24.
//

import Foundation
import SwiftUI

struct ExerciseListConditionalToolbarItem<Content: View>: View {
    
    @Environment(\.colorScheme)
    private var colorScheme
    
    @Binding
    private var isHidden: Bool
    
    private var content: Content
    
    init(isHidden: Binding<Bool>, @ViewBuilder _ content: () -> Content) {
        self._isHidden = isHidden
        self.content = content()
    }
    
    var body: some View {
        ZStack {
            content
            
            if isHidden {
                ColorScheme.BACKGROUND_COLOR(colorScheme)
            }
        }
    }
}
