//
//  UnitPicker.swift
//  Distance and Interval Notfier
//
//  Created by Stefan Berger on 15.05.24.
//

import Foundation
import SwiftUI

struct UnitPicker: View {
    
    @Binding
    private var unit: Unit
    
    private var selectedQuantity: Quantity
    
    init(unit: Binding<Unit>, selectedQuantity: Quantity) {
        self._unit = unit
        self.selectedQuantity = selectedQuantity
    }
    
    var body: some View {
        Picker(
            selection: $unit,
            label: Text("")
        ) {
            if(selectedQuantity == .TIME) {
                Text(Unit.SECOND.description).tag(Unit.SECOND)
                Text(Unit.MINUTE.description).tag(Unit.MINUTE)
                Text(Unit.HOUR.description).tag(Unit.HOUR)
            } else {
                Text(Unit.METER.description).tag(Unit.METER)
                Text(Unit.KILOMETER.description).tag(Unit.KILOMETER)
                Text(Unit.MILE.description).tag(Unit.MILE)
            }
        }
        .pickerStyle(.segmented)
    }
}
