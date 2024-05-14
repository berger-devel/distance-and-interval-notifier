//
//  NotificationSoundGenerator.swift
//  Distance and Interval Notfier
//
//  Created by Stefan Berger on 13.05.24.
//

import Foundation
import UserNotifications

class NotificationSoundGenerator {
    
    private let audioProcessor = AudioProcessor()
    
    func generateNotificationSound(uuid: UUID, amount: Double, unit: Unit) async -> UNNotificationSound {
        var audioFileUrls: [NSURL] = []
        
        audioFileUrls.append(createAudioFileUrl(unit.description.lowercased()))
        
        if amount <= 100 {
            audioFileUrls.append(createAudioFileUrl("\(Int(amount))"))
        } else {
            audioFileUrls.append(createAudioFileUrl("\(Int(amount.truncatingRemainder(dividingBy: 100)))"))
            
            for i in 2...3 {
                let position = pow(10, Double(i))
                let digit = getDigit(amount, at: position)
                if digit != 0 {
                    audioFileUrls.append(createDigitAudioFileUrl(digit, at: Int(position)))
                }
            }
        }
        
        await audioProcessor.mix(uuid: uuid, audioFileUrls: audioFileUrls)
        
        return UNNotificationSound(named: UNNotificationSoundName("notification-\(uuid.uuidString).m4a"))
    }
    
    private func createAudioFileUrl(_ fileName: String) -> NSURL {
        do {
            guard let url = Bundle.main.url(forResource: fileName, withExtension: "wav") as? NSURL else {
                throw OptionalError.from("url")
            }
            
            return url
        } catch {
            Log.error("Error creating audio file URL", error)
            return NSURL()
        }
    }
    
    private func getDigit(_ amount: Double, at position: Double) -> Int {
        let remainder = amount.truncatingRemainder(dividingBy: position * 10.0)
        
        let digit: Int
        if position == 1 {
            return Int(remainder)
        } else {
            return Int(remainder / position)
        }
    }
    
    private func createDigitAudioFileUrl(_ digit: Int, at position: Int) -> NSURL {
        do {
            guard let url = Bundle.main.url(forResource: "\(digit * position)", withExtension: "wav") as? NSURL else {
                throw OptionalError.from("url")
            }
            
            return url
        } catch {
            Log.error("Error creating digit audio file URL", error)
            return NSURL()
        }
    }
}
