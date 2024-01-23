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
    private var selectedQuantity: Quantity
    
    init(selectedQuantity: Binding<Quantity>) {
        self._selectedQuantity = selectedQuantity
    }
    
    var body: some View {
        Picker(selection: $selectedQuantity, label: Text("")) {
            Text("Time").tag(Quantity.TIME)
            Text("Distance").tag(Quantity.DISTANCE)
        }
        .pickerStyle(.segmented)
    }
}

enum Quantity: Int, CustomStringConvertible {
    case TIME, DISTANCE
    
    var description: String {
        return self == .TIME ? "time" : "distance"
    }
}
