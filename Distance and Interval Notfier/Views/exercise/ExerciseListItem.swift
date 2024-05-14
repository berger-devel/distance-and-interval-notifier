//
//  Exercise.swift
//  Distance and Interval Notfier
//
//  Created by Stefan Berger on 16.08.22.
//

import Foundation
import SwiftUI

struct ExerciseListItem: View {
    
    @Binding
    private var exercise: UIExercise
    
    @Binding
    private var progress: Double
    
    @State
    private var isSelected = false
    
    init(_ exercise: Binding<UIExercise>, _ progress: Binding<Double>) {
        self._exercise = exercise
        self._progress = progress
    }
    
    var body: some View {
        HStack {
            Icon(sfSymbol: exercise.sfSymbol, color: ColorScheme.ICON_COLOR(exercise.colorIndex))
            VStack(alignment: .leading) {
                Text(exercise.name).font(.title)
                HStack(spacing: 0) {
                    Text("\(AmountFormatter().string(from: exercise.amount))\(exercise.unit.shortDescription)  ")
                    .font(.system(.headline))
                    .fontWeight(.medium)
                    
                    if exercise.announceBothQuantities {
                        AnnounceIcon(quantity: .TIME)
                        AnnounceIcon(quantity: .DISTANCE)
                    } else {
                        switch exercise.unit {
                        case .SECOND, .MINUTE, .HOUR:
                            AnnounceIcon(quantity: .TIME)
                        default:
                            AnnounceIcon(quantity: .DISTANCE)
                        }
                    }
                    if exercise.notificationFrequency != .ONCE {
                        Image(systemName: String(exercise.notificationFrequency.rawValue + 1) + ".circle.fill")
                            .font(.system(size: 20))
                            .symbolRenderingMode(.multicolor)
                            .foregroundStyle(Color(UIColor.systemBlue))
                    }
                    
                    Spacer()
                    
                    Text("\(Int(progress))")
                }
            }
        }
    }
}

struct ExerciseListItemPreview: PreviewProvider {
    
    static var exercise = {
        var exercise = UIExercise()
        
        exercise.unit = .KILOMETER
        exercise.notificationFrequency = NotificationFrequency.FIVE
        exercise.announceBothQuantities = false
        return exercise
    }()
    
    static var previews: some View {
        ExerciseListItem(Binding(get: { exercise }, set: { _ in }), Binding(get: { 12.3 }, set: { _ in }))
            .previewLayout(.sizeThatFits)
    }
}
