//
//  AnnounceIcon.swift
//  Distance and Interval Notfier
//
//  Created by Stefan Berger on 29.03.23.
//

import Foundation
import SwiftUI

struct AnnounceIcon: View {
    @Environment(\.colorScheme)
    private var colorScheme
    
    let quantity: Quantity
    
    var body: some View {
        switch quantity {
        case .TIME:
            Image(systemName: "timer")
                .symbolRenderingMode(.multicolor)
                .font(.system(size: 20))
        case .DISTANCE:
            Image(systemName: "point.topleft.down.curvedto.point.filled.bottomright.up")
                .foregroundStyle(Color(.systemGreen))
                .font(.system(size: 20))
        }
    }
}
