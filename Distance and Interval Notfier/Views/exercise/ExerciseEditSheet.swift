//
//  WorkoutEditSheet.swift
//  Distance and Interval Notfier
//
//  Created by Stefan Berger on 23.08.22.
//

import Foundation
import SwiftUI

struct ExerciseEditSheet: View {
    
    @Environment(\.colorScheme)
    private var colorScheme
    
    private let onDone: () -> ()
    private let onCancel: () -> ()
    
    @Binding
    private var exercise: Exercise
    
    init(_ exercise: Binding<Exercise>, onDone: @escaping () -> (), onCancel: @escaping () -> ()) {
        self.onDone = onDone
        self.onCancel = onCancel
        self._exercise = exercise
    }
    
    var body: some View {        
        NavigationStack {
            GeometryReader { geometry in
                ZStack {
                    ColorScheme.BACKGROUND_COLOR(colorScheme)
                        .ignoresSafeArea(.all)
                    Form {
                        EditSheetIcon(sfSymbol: exercise.appearance.sfSymbol, colorIndex: exercise.appearance.colorIndex)
                        NameSection(name: $exercise.appearance.name)
                        OptionsSection(exercise: $exercise)
                        NotificationFrequencySection(exercise: $exercise)
                        SymbolSection(sfSymbol: $exercise.appearance.sfSymbol, width: geometry.size.width - Constants.ICON_SECTION_PADDING)
                        ColorSection(width: geometry.size.width - Constants.ICON_SECTION_PADDING, selectedColorIndex: $exercise.appearance.colorIndex)
                    }
                }
            }
            .toolbar {
                DoneButton(onDone: onDone)
                CancelButton(onCancel: onCancel)
            }
        }
    }
}
