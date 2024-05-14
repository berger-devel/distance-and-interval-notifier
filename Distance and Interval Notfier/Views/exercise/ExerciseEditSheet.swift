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
    
    @Binding
    private var selectedExercise: UIExercise
    
    private let formerValues: UIExercise?
    
    init(_ selectedExercise: Binding<UIExercise>, formerValues: UIExercise?) {
        self._selectedExercise = selectedExercise
        self.formerValues = formerValues
    }
    
    private var availableAmounts: [Double] {
        switch(selectedExercise.unit) {
        case .SECOND:
            return Constants.TIME_AMOUNTS_SECOND
        case .MINUTE:
            return Constants.TIME_AMOUNTS_MINUTE
        case .HOUR:
            return Constants.TIME_AMOUNTS_HOUR
        case .METER:
            return Constants.DISTANCE_AMOUNTS_METER
        case .KILOMETER:
            return Constants.DISTANCE_AMOUNTS_KILOMETER
        case .MILE:
            return Constants.DISTANCE_AMOUNTS_MILES
        }
    }
    
    private var defaultAmount: Double {
        switch(selectedExercise.unit) {
        case .SECOND:
            return Constants.TIME_AMOUNTS_SECOND[0]
        case .MINUTE:
            return Constants.TIME_AMOUNTS_MINUTE[0]
        case .HOUR:
            return Constants.TIME_AMOUNTS_HOUR[0]
        case .METER:
            return Constants.DISTANCE_AMOUNTS_METER[0]
        case .KILOMETER:
            return Constants.DISTANCE_AMOUNTS_KILOMETER[0]
        case .MILE:
            return Constants.DISTANCE_AMOUNTS_MILES[0]
        }
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ColorScheme.BACKGROUND_COLOR(colorScheme)
                    .ignoresSafeArea(.all)
                Form {
                    HStack(spacing: 0) {
                        Spacer()
                        
                        ZStack {
                            Circle()
                                .fill(ColorScheme.ICON_COLOR(selectedExercise.colorIndex))
                                .frame(width: Constants.ICON_PREVIEW_SIZE, height: Constants.ICON_PREVIEW_SIZE)
                            
                            Image(systemName: selectedExercise.sfSymbol)
                                .foregroundColor(Color(.systemBackground))
                                .font(.system(size: Constants.ICON_PREVIEW_FONT_SIZE))
                        }
                        
                        Spacer()
                    }
                    .padding(.vertical)
                    .listRowBackground(ColorScheme.BACKGROUND_COLOR(colorScheme))
                    .frame(maxHeight: Constants.ICON_CONTAINER_SIZE)
                    
                    Section("Name") {
                        TextField("Name", text: $selectedExercise.name)
                    }
                    .listRowBackground(ColorScheme.LIST_ROW_BACKGROUND(colorScheme))
                    
                    Section("Options") {
                        QuantityPicker(selectedQuantity: $selectedExercise.quantity.animation(.easeInOut))
                        UnitPicker(selectedExercise: $selectedExercise)
                        AmountPicker(selectedExercise: $selectedExercise, formerValues: formerValues, availableAmounts: availableAmounts)
                    }
                    .listRowBackground(ColorScheme.LIST_ROW_BACKGROUND(colorScheme))
                    .onChange(of: selectedExercise.unit, initial: false) {
                        selectedExercise.amount = defaultAmount
                    }
                    
                    Section("Notifications") {
                        NotificationFrequencyPicker(selectedNotificationFrequency: $selectedExercise.notificationFrequency)
                        Toggle(isOn: $selectedExercise.announceBothQuantities) {
                            Text("Also announce \(selectedExercise.quantity == .TIME ? "distance" : "time")")
                        }
                    }
                    .listRowBackground(ColorScheme.LIST_ROW_BACKGROUND(colorScheme))
                    
                    Section("Symbol") {
                        SymbolPicker(
                            width: geometry.size.width - Constants.ICON_SECTION_PADDING,
                            selectedSymbol: Binding(
                                get: { selectedExercise.sfSymbol },
                                set: { sfSymbol in selectedExercise.sfSymbol = sfSymbol }
                            ))
                    }
                    .listRowBackground(ColorScheme.LIST_ROW_BACKGROUND(colorScheme))
                    
                    Section("Color") {
                        ColorPicker(width: geometry.size.width - Constants.ICON_SECTION_PADDING, selectedColorIndex: $selectedExercise.colorIndex)
                    }
                    .listRowBackground(ColorScheme.LIST_ROW_BACKGROUND(colorScheme))
                }
            }
        }
    }
}

struct ExerciseEditSheet_Previews: PreviewProvider {
    @State
    private static var selectedExercise = UIExercise()
    
    static var previews: some View {
        ExerciseEditSheet($selectedExercise, formerValues: UIExercise())
    }
}
