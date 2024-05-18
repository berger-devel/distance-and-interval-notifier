//
//  NameSection.swift
//  Distance and Interval Notfier
//
//  Created by Stefan Berger on 16.05.24.
//

import Foundation
import SwiftUI

struct NameSection: View {
    
    @Environment(\.colorScheme)
    private var colorScheme
    
    @Binding
    private var name: String
    
    init(name: Binding<String>) {
        self._name = name
    }
    
    var body: some View {
        
        Section("Name") {
            TextField("Name", text: $name)
        }
        .listRowBackground(ColorScheme.LIST_ROW_BACKGROUND(colorScheme))
    }
}
