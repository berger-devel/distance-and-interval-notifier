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
    
    @Binding
    private var workout: CurrentWorkout
    
    @Binding
    private var isSheetPresented: Bool
    
    private var doneCallback: () -> Void
    
    init(_ newWorkout: Binding<CurrentWorkout>, _ isSheetPresented: Binding<Bool>, onDone doneCallback: @escaping () -> Void) {
        self._workout = newWorkout
        self._isSheetPresented = isSheetPresented
        self.doneCallback = doneCallback
    }
    
    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                Form {
                    HStack(spacing: 0) {
                        Spacer()
                        
                        ZStack {
                            Circle()
                                .fill(ColorScheme.ICON_COLOR(Int(workout.colorIndex)))
                                .frame(width: Constants.ICON_PREVIEW_SIZE, height: Constants.ICON_PREVIEW_SIZE)
                            
                            Image(systemName: workout.sfSymbol)
                                .foregroundColor(Color(.systemBackground))
                                .font(.system(size: Constants.ICON_PREVIEW_FONT_SIZE))
                        }
                        
                        Spacer()
                    }
                    .padding(.vertical)
                    .listRowBackground(ColorScheme.BACKGROUND_COLOR(colorScheme))
                    .frame(maxHeight: Constants.ICON_CONTAINER_SIZE)
                    
                    Section("Name") {
                        TextField("Name", text: $workout.name)
                    }
                    
                    Section("Symbol") {
                        SymbolPicker(width: geometry.size.width - Constants.ICON_SECTION_PADDING, selectedSymbol: $workout.sfSymbol)
                    }
                    
                    Section("Color") {
                        ColorPicker(width: geometry.size.width - Constants.ICON_SECTION_PADDING, selectedColorIndex: $workout.colorIndex)
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button(action: {
                        doneCallback()
                        isSheetPresented = false
                    }) {
                        Text("Done")
                    }
                }
                
                ToolbarItem(placement: .cancellationAction) {
                    Button(action: {
                        isSheetPresented = false
                    }) {
                        Text("Cancel")
                    }
                }
            }
        }
    }
}

struct WorkoutEditSheetPreview: PreviewProvider {
    @State
    static var workout = CurrentWorkout(name: "A Workout", sfSymbol: "calendar", colorIndex: 0)
    @State
    static var isEditSheetPresented = true
    
    static var previews: some View {
        WorkoutEditSheet($workout, $isEditSheetPresented) {}
    }
}
