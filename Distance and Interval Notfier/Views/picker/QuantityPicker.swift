//
//  QuantityPicker.swift
//  Distance and Interval Notfier
//
//  Created by Stefan Berger on 24.03.23.
//

import Foundation
import SwiftUI

struct QuantityPicker: View {
    
    @Binding
    private var quantity: Quantity
    
    init(quantity: Binding<Quantity>) {
        self._quantity = quantity
    }
    
    var body: some View {
        Picker(
            selection: $quantity,
            label: Text("")
        ) {
            Text(Quantity.TIME.description).tag(Quantity.TIME)
            Text(Quantity.DISTANCE.description).tag(Quantity.DISTANCE)
        }
        .pickerStyle(.segmented)
    }
}
