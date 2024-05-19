//
//  WorkoutEditSheet.swift
//  Distance and Interval Notfier
//
//  Created by Stefan Berger on 23.08.22.
//

import Foundation
import SwiftUI

struct WorkoutEditSheet: View {
    
    @Environment(\.colorScheme)
    private var colorScheme
    
    private let onDone: () -> ()
    private let onCancel: () -> ()
    
    @Binding
    private var workout: Workout
        
    init(_ workout: Binding<Workout>, onDone: @escaping () -> (), onCancel: @escaping () -> ()) {
        self.onDone = onDone
        self.onCancel = onCancel
        self._workout = workout
    }
    
    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                Form {
                    EditSheetIcon(sfSymbol: workout.appearance.sfSymbol, colorIndex: workout.appearance.colorIndex)
                    NameSection(name: $workout.appearance.name)
                    SymbolSection(sfSymbol: $workout.appearance.sfSymbol, width: geometry.size.width - Constants.ICON_SECTION_PADDING)
                    ColorSection(width: geometry.size.width - Constants.ICON_SECTION_PADDING, selectedColorIndex: $workout.appearance.colorIndex)
                }
            }
            .toolbar {
                DoneButton(onDone: onDone)
                CancelButton(onCancel: onCancel)
            }
        }
    }
}
