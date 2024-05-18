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
    
    private let unit: Unit
    private let amountFormatter = AmountFormatter()
    
    @Binding
    private var amount: Double

    @Binding
    private var selectedQuantity: Quantity
    
    init(amount: Binding<Double>, unit: Unit, selectedQuantity: Binding<Quantity>) {
        self.unit = unit
        
        self._amount = amount
        self._selectedQuantity = selectedQuantity
    }
    
    var body: some View {
        ZStack {
            ColorScheme.LIST_ROW_BACKGROUND(colorScheme)
                        
            Picker(
                selection: $amount,
                label: Text("")
            ) {
                ForEach(Constants.AVAILABLE_AMOUNTS(unit), id: \.self) { amount in
                    Text(self.amountFormatter.string(from: amount))
                }
            }
            .pickerStyle(.wheel)
            
            if selectedQuantity != unit.quantity {
                ColorScheme.GRAY_OVERLAY(colorScheme)
            }
        }
    }
}
