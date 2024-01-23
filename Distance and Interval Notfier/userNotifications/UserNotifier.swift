//
//  UserNotifier.swift
//  Distance and Interval Notfier
//
//  Created by Stefan Berger on 15.08.22.
//

import Foundation
import UserNotifications
import os
import AVFAudio

class UserNotifier {
    
    private let userNotificationCenter = UNUserNotificationCenter.current()
    
    private var speechSynthesizer: AVSpeechSynthesizer? = nil
    private var speechSynthesizerDelegate: SpeechSynthesizerDelegate? = nil
    
    private var timer: Timer? = nil
    
    private let numberFormatter = NumberFormatter()
    
    init() {
        numberFormatter.maximumFractionDigits = 1
    }
    
    private func createDelegate(finishCallback: @escaping () -> Void) -> SpeechSynthesizerDelegate {
        let speechSynthesizerDelegate = SpeechSynthesizerDelegate()
        speechSynthesizerDelegate.setFinishCallback(finishCallback: finishCallback)
        return speechSynthesizerDelegate
    }
    
    func finishCallback() {}
    
    func alert(distance: Double, unit: Unit) {
        notify(amount: distance, unit: unit, title: "Exercise completed", body: "Distance")

//        self.timer = Timer.scheduledTimer(withTimeInterval: 4.0, repeats: false, block: { timer in
//            do {
//                try AVAudioSession.sharedInstance().setActive(false, options: .notifyOthersOnDeactivation)
//            } catch {
//                Logger().error("Failed to deactivate audio session: \(error.localizedDescription)")
//            }
//        })
    }
    
    func alert(after duration: Double, unit: Unit, intervals: Int, onFinish finishCallback: @escaping () -> ()) {
        var timeInterval = duration
        if unit == .MINUTE {
            timeInterval = duration * 60
        } else if unit == .HOUR {
            timeInterval = duration * 360
        }
        
        if intervals == 1 {
            timer = Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: false) { [self] _ in
                notify(amount: timeInterval, unit: unit, title: "Exercise completed", body: "Time spent")
                finishCallback()
            }
        } else {
            timeInterval /= Double(intervals)
            var remainingIntervals = Double(intervals)
            timer = Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: true) { [self] timer in
                remainingIntervals -= 1
                if remainingIntervals == 0 {
                    timer.invalidate()
                    notify(amount: duration, unit: unit, title: "Exercise completed", body: "Time spent")
                    finishCallback()
                } else {
                    notify(amount: duration - remainingIntervals * timeInterval, unit: unit, title: "Intermediate result", body: "Time spent")
                }
            }
        }
    }
    
    func notify(amount: Double, unit: Unit, title: String, body: String) {
        self.userNotificationCenter.requestAuthorization(options: [.alert, .sound, .badge]) { [self] granted, error in
            if let error = error {
                Logger().error("Failed to authorize for speech synthesis: \(error.localizedDescription)")
            } else {
                let content = UNMutableNotificationContent()
                let amountString = numberFormatter.string(from: NSNumber(value: amount))!
                content.title = title
                content.body = "\(body): \(amountString) \(unit)"

                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 0.001, repeats: false)
                let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
                self.userNotificationCenter.add(request) { [self] error in
                    if let error = error {
                        Logger().error("Failed to schedule request: \(error.localizedDescription)")
                    } else {
                        speechSynthesizer = AVSpeechSynthesizer()
                        speechSynthesizerDelegate = createDelegate(finishCallback: finishCallback)
                        speechSynthesizer!.delegate = speechSynthesizerDelegate
                        
                        let utterance = AVSpeechUtterance(string: "\(amountString), \(unit.description)")
                        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
                        speechSynthesizer?.speak(utterance)
                    }
                }
            }
        }
    }
}
