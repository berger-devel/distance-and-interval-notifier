//
//  Exercise.swift
//  Distance and Interval Notfier
//
//  Created by Stefan Berger on 16.08.22.
//

import Foundation
import SwiftUI

struct ExerciseListItem: View {
    
    private let timeNumberFormatter: NumberFormatter
    private let distanceNumberFormatter: NumberFormatter
    
    @State
    private var exercise: Exercise
    
    @Binding
    private var progress: Double
    
    @State
    private var isSelected = false
    
    init(_ exercise: Exercise, _ progress: Binding<Double>) {
        timeNumberFormatter = NumberFormatter()
        timeNumberFormatter.roundingMode = .down
        timeNumberFormatter.minimumIntegerDigits = 2
        distanceNumberFormatter = NumberFormatter()
        distanceNumberFormatter.maximumFractionDigits = 1
        
        self.exercise = exercise
        self._progress = progress
    }
    
    var body: some View {
        HStack {
            Icon(sfSymbol: exercise.appearance.sfSymbol, color: ColorScheme.ICON_COLOR(exercise.appearance.colorIndex))
            VStack(alignment: .leading) {
                Text(exercise.appearance.name).font(.title)
                GeometryReader { geometry in
                    HStack() {
                        HStack {
                            Text("\(Int(exercise.amount))\(exercise.unit.shortDescription)")
                                .font(.system(.headline))
                                .fontWeight(.medium)
                            
                            if exercise.repetitionFrequency != Constants.REPETITION_AMOUNTS[0] {
                                Text("×\(exercise.repetitionFrequency)")
                                    .foregroundStyle(ColorScheme.STARTBUTTON_TEXT_COLOR)
                                    .background(ColorScheme.REPETITION_ICON_COLOR)
                                    .clipShape(RoundedRectangle(cornerSize: CGSize(width: 5, height: 5)))
                            }
                            
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
                                        .foregroundStyle(ColorScheme.NOTIFICATION_ICON_COLOR)
                                }
                            }
                        }
                        
                        Spacer()
                        
                        switch exercise.unit {
                        case .SECOND, .METER: Text("\(Int(progress))")
                        case .MINUTE: Text("\(formatTime(progress / 60)):\(formatTime(progress.truncatingRemainder(dividingBy: 60)))")
                        case .HOUR: Text("\(formatTime(progress / 3600)):\(formatTime(progress.truncatingRemainder(dividingBy: 3600) / 60)):\(formatTime(progress.truncatingRemainder(dividingBy: 60)))")
                        case .KILOMETER: Text("\(formatDistance(progress / 1000))")
                        }
                    }
                }
            }
            .foregroundColor(ColorScheme.LIST_ITEM_TEXT_COLOR)
        }
    }
    
    private func formatTime(_ number: Double) -> String {
        return timeNumberFormatter.string(from: number as NSNumber) ?? ""
    }
    
    private func formatDistance(_ number: Double) -> String {
        return distanceNumberFormatter.string(from: number as NSNumber) ?? ""
    }
}
