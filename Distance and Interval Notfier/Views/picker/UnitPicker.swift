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
                Text(String(describing: Unit.SECOND)).tag(Unit.SECOND)
                Text(String(describing: Unit.MINUTE)).tag(Unit.MINUTE)
                Text(String(describing: Unit.HOUR)).tag(Unit.HOUR)
            } else {
                Text(String(describing: Unit.METER)).tag(Unit.METER)
                Text(String(describing: Unit.KILOMETER)).tag(Unit.KILOMETER)
            }
        }
        .pickerStyle(.segmented)
    }
}
