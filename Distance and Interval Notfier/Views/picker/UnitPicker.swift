//
//  UnitPicker.swift
//  Distance and Interval Notfier
//
//  Created by Stefan Berger on 14.09.22.
//

import Foundation
import SwiftUI

struct UnitPicker: View {
    
    @Binding
    private var selectedExercise: UIExercise
    
    init(selectedExercise: Binding<UIExercise>) {
        self._selectedExercise = selectedExercise
    }
    
    var body: some View {
        VStack {
            Picker(
                selection: $selectedExercise.unit,
                label: Text("")
            ) {
                if(selectedExercise.quantity == .TIME) {
                    Text("Seconds").tag(Unit.SECOND)
                    Text("Minutes").tag(Unit.MINUTE)
                    Text("Hours").tag(Unit.HOUR)
                } else {
                    Text("Meters").tag(Unit.METER)
                    Text("Kilometers").tag(Unit.KILOMETER)
                    Text("Miles").tag(Unit.MILE)
                }
            }
            .pickerStyle(.segmented)
        }
    }
}

enum Unit: Int, CustomStringConvertible {
    
    case SECOND, MINUTE, HOUR,
         METER, KILOMETER, MILE
    
    var quantity: Quantity {
        get {
            if [Unit.SECOND, Unit.MINUTE, Unit.HOUR].contains(self) {
                return .TIME
            } else {
                return .DISTANCE
            }
        }
        set { }
    }
    
    var description: String {
        switch self {
        case .SECOND: return "Seconds"
        case .MINUTE: return "Minutes"
        case .HOUR: return "Hours"
        case .METER: return "Meters"
        case .KILOMETER: return "Kilometers"
        case .MILE: return "Miles"
        }
    }
}
