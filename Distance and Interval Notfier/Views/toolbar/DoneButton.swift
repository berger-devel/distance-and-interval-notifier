//
//  DoneButton.swift
//  Distance and Interval Notfier
//
//  Created by Stefan Berger on 16.05.24.
//

import Foundation
import SwiftUI

struct DoneButton: ToolbarContent {
    
    private var onDone: () -> ()
    
    init(onDone: @escaping () -> Void) {
        self.onDone = onDone
    }
    
    var body: some ToolbarContent {
        ToolbarItem(placement: .confirmationAction) {
            Button(action: onDone) {
                Text("Done")
            }
        }
    }
}
