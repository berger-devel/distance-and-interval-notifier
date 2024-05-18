//
//  Exercise.swift
//  Distance and Interval Notfier
//
//  Created by Stefan Berger on 16.08.22.
//

import Foundation
import SwiftUI

struct ExerciseListItem: View {
    
    @State
    private var exercise: Exercise
    
    @Binding
    private var progress: Double
    
    @State
    private var isSelected = false
    
    init(_ exercise: Exercise, _ progress: Binding<Double>) {
        self.exercise = exercise
        self._progress = progress
    }
    
    var body: some View {
        HStack {
            Icon(sfSymbol: exercise.sfSymbol, color: ColorScheme.ICON_COLOR(exercise.colorIndex))
            VStack(alignment: .leading) {
                Text(exercise.name).font(.title)
                GeometryReader { geometry in
                    HStack() {
                        HStack() {
                            Text("\(AmountFormatter().string(from: exercise.amount))\(exercise.unit.shortDescription)")
                                .font(.system(.headline))
                                .fontWeight(.medium)
                            
                            HStack(spacing: 0) {
                                if exercise.announceBothQuantities {
                                    AnnounceIcon(quantity: .TIME)
                                    AnnounceIcon(quantity: .DISTANCE)
                                } else {
                                    if exercise.unit.quantity == .TIME {
                                        AnnounceIcon(quantity: .TIME)
                                    } else {
                                        AnnounceIcon(quantity: .DISTANCE)
                                    }
                                }
                                
                                if exercise.notificationFrequency != .ONCE {
                                    Image(systemName: String(exercise.notificationFrequency.rawValue + 1) + ".circle.fill")
                                        .font(.system(size: 20))
                                        .symbolRenderingMode(.multicolor)
                                        .foregroundStyle(Color(UIColor.systemBlue))
                                }
                            }
                        }
                        
                        Spacer()
                        
                        Text("\(Int(progress))")
                    }
                }
            }
            .foregroundColor(ColorScheme.LIST_ITEM_TEXT_COLOR)
        }
    }
}
