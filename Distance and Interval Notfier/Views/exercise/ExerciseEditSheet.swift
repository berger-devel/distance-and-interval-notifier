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
    private var selectedExercise: Exercise
    
    init(_ selectedExercise: Binding<Exercise>, onDone: @escaping () -> (), onCancel: @escaping () -> ()) {
        self.onDone = onDone
        self.onCancel = onCancel
        self._selectedExercise = selectedExercise
    }
    
    var body: some View {        
        NavigationStack {
            GeometryReader { geometry in
                ZStack {
                    ColorScheme.BACKGROUND_COLOR(colorScheme)
                        .ignoresSafeArea(.all)
                    Form {
                        EditSheetIcon(sfSymbol: selectedExercise.sfSymbol, colorIndex: selectedExercise.colorIndex)
                        NameSection(name: $selectedExercise.name)
                        OptionsSection(exercise: $selectedExercise)
                        NotificationFrequencySection(exercise: $selectedExercise)
                        SymbolSection(sfSymbol: $selectedExercise.sfSymbol, width: geometry.size.width - Constants.ICON_SECTION_PADDING)
                        ColorSection(width: geometry.size.width - Constants.ICON_SECTION_PADDING, selectedColorIndex: $selectedExercise.colorIndex)
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
