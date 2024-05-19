//
//  OptionsSection.swift
//  Distance and Interval Notfier
//
//  Created by Stefan Berger on 14.09.22.
//

import Foundation
import SwiftUI

struct OptionsSection: View {
    
    @Environment(\.colorScheme)
    private var colorScheme
    
    @Binding
    private var exercise: Exercise
    
    private let formerValues: Exercise?
    
    @State
    private var selectedQuantity: Quantity
    
    init(exercise: Binding<Exercise>) {
        self._exercise = exercise
        selectedQuantity = exercise.unit.quantity.wrappedValue
        self.formerValues = Exercise()
    }
    
    var body: some View {
        Section("Options") {
            VStack() {
                Spacer()
                QuantityPicker(quantity: $selectedQuantity)
                UnitPicker(unit: $exercise.unit, selectedQuantity: selectedQuantity)
                AmountPicker(amount: $exercise.amount, unit: exercise.unit, selectedQuantity: $selectedQuantity)
                Spacer()
            }
        
            HStack {
                Picker(selection: $exercise.repetitionFrequency, label: Text("Perform")) {
                    ForEach(Constants.REPETITION_AMOUNTS, id: \.self) { repetitionFrequency in
                        Text(String(describing: repetitionFrequency)).tag(repetitionFrequency)
                    }
                }
                .pickerStyle(.automatic)
                Text("times")
            }
            
            .listRowBackground(ColorScheme.LIST_ROW_BACKGROUND(colorScheme))
            .onChange(of: exercise.unit, initial: false) {
                exercise.amount = Constants.DEFAULT_AMOUNT(exercise.unit)
            }
        }
    }
}
