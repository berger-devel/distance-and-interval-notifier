//
//  ExerciseEditSheetCancelButton.swift
//  Distance and Interval Notfier
//
//  Created by Stefan Berger on 16.05.24.
//

import Foundation
import SwiftUI

struct CancelButton: ToolbarContent {
    
    private let onCancel: () -> ()
    
    init(onCancel: @escaping () -> ()) {
        self.onCancel = onCancel
    }
    
    var body: some ToolbarContent {
        ToolbarItem(placement: .cancellationAction) {
            Button(action: onCancel) {
                Text("Cancel")
            }
        }
    }
}
