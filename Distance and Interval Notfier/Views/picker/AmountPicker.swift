//
//  AmountPicker.swift
//  Distance and Interval Notfier
//
//  Created by Stefan Berger on 11.09.22.
//

import Foundation
import SwiftUI

struct AmountPicker: View {
    
    @Environment(\.colorScheme)
    private var colorScheme
    
    @Binding
    private var selectedExercise: UIExercise
    
    @State
    private var dirty: Bool = false
    
    private let formerValues: UIExercise?
    
    private let availableAmounts: [Double]
    
    private let amountFormatter = AmountFormatter()
    
    init(selectedExercise: Binding<UIExercise>, formerValues: UIExercise?, availableAmounts: [Double]) {
        self._selectedExercise = selectedExercise
        self.formerValues = formerValues
        self.availableAmounts = availableAmounts
    }
    
    var body: some View {
        ZStack {
            Picker(
                selection: Binding(
                    get: { () -> Double in
                        if formerValues != nil && selectedExercise.unit == formerValues!.unit {
                            return selectedExercise.changedAmount
                        } else {
                            return selectedExercise.amount
                        }
                    },
                    set: { amount in
                        if formerValues != nil && selectedExercise.unit == formerValues!.unit {
                            selectedExercise.changedAmount = amount
                        } else {
                            selectedExercise.amount = amount
                        }
                    }
                ),
                label: Text("")
            ) {
                ForEach(availableAmounts, id: \.self) { amount in
                    Text(self.amountFormatter.string(from: amount))
                }
            }
            .pickerStyle(.wheel)
            
            if selectedExercise.quantity != selectedExercise.unit.quantity {
                ColorScheme.GRAY_OVERLAY(colorScheme)
            }
        }
    }
}
