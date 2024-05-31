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
    
    @ObservedObject
    private var exerciseListState: ExerciseListState
    
    @State
    private var exercise: Exercise
    
    @State
    private var listItemOpacity: Double = 1.0
    
    @State
    private var progressOpacity: Double = 0.0
    
    init(_ exercise: Exercise, exerciseListState: ExerciseListState) {
        timeNumberFormatter = NumberFormatter()
        timeNumberFormatter.roundingMode = .down
        timeNumberFormatter.minimumIntegerDigits = 2
        distanceNumberFormatter = NumberFormatter()
        distanceNumberFormatter.maximumFractionDigits = 1
        
        self.exercise = exercise
        self.exerciseListState = exerciseListState
    }
    
    var body: some View {
        HStack {
            Icon(sfSymbol: exercise.appearance.sfSymbol, color: ColorScheme.ICON_COLOR(exercise.appearance.colorIndex))
            VStack(alignment: .leading) {
                Text(exercise.appearance.name).font(.title)
                
                GeometryReader { geometry in
                    
                    HStack() {
                        HStack {
                            HStack(spacing: 0) {
                                if progressOpacity != 0 {
                                    ZStack {
                                        HStack(spacing: 0) {
                                            switch exercise.unit {
                                            case .SECOND, .METER: Text("\(Int(exerciseListState.progress))")
                                            case .MINUTE: Text("\(formatTime(exerciseListState.progress / 60)):\(formatTime(exerciseListState.progress.truncatingRemainder(dividingBy: 60)))")
                                            case .HOUR: Text("\(formatTime(exerciseListState.progress / 3600)):\(formatTime(exerciseListState.progress.truncatingRemainder(dividingBy: 3600) / 60)):\(formatTime(exerciseListState.progress.truncatingRemainder(dividingBy: 60)))")
                                            case .KILOMETER: Text("\(formatDistance(exerciseListState.progress / 1000))")
                                            }
                                            Text("/")
                                        }
                                    }
                                    .opacity(progressOpacity)
                                }
                                Text("\(Int(exercise.amount))\(exercise.unit.shortDescription)")
                                    .font(.system(.headline))
                                    .fontWeight(.medium)
                            }
                            
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
                    }
                }
            }
            .foregroundColor(ColorScheme.LIST_ITEM_TEXT_COLOR)
        }
        .opacity(listItemOpacity)
        .onChange(of: exerciseListState.runningExercise) { _, newValue in
            withAnimation {
                if newValue == nil {
                    listItemOpacity = 1.0
                    progressOpacity = 0.0
                } else {
                    if newValue == exercise {
                        listItemOpacity = 1.0
                        progressOpacity = 1.0
                    } else {
                        listItemOpacity = 0.5
                        progressOpacity = 0.0
                    }
                }
            }
        }
    }
    
    private func formatTime(_ number: Double) -> String {
        return timeNumberFormatter.string(from: number as NSNumber) ?? ""
    }
    
    private func formatDistance(_ number: Double) -> String {
        return distanceNumberFormatter.string(from: number as NSNumber) ?? ""
    }
}
