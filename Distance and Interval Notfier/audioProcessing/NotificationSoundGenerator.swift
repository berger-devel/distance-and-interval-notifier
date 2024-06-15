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
    
    func generateNotificationSound(_ uuid: UUID, _ seconds: Double, _ minutes: Double?, _ hours: Double?) async -> UNNotificationSound {
        return await generateNotificationSoundFromURLs(uuid, generateTimeSoundURLs(seconds, minutes, hours))
    }
    
    func generateNotificationSound(_ uuid: UUID, _ meters: Double, _ kilometers: Double?) async -> UNNotificationSound {
        return await generateNotificationSoundFromURLs(uuid, generateDistanceSoundURLs(meters, kilometers))
    }
    
    func generateNotificationSound(_ uuid: UUID, _ meters: Double, _ kilometers: Double?, _ seconds: Double, _ minutes: Double?, _ hours: Double?) async -> UNNotificationSound {
        let audioFileUrls = generateTimeSoundURLs(seconds, minutes, hours) + generateDistanceSoundURLs(meters, kilometers)
        return await generateNotificationSoundFromURLs(uuid, audioFileUrls)
    }
    
    func generateNotificationSound(_ uuid: UUID, _ seconds: Double, _ minutes: Double?, _ hours: Double?, _ meters: Double, _ kilometers: Double?) async -> UNNotificationSound {
        let audioFileUrls = generateDistanceSoundURLs(meters, kilometers) + generateTimeSoundURLs(seconds, minutes, hours)
        return await generateNotificationSoundFromURLs(uuid, audioFileUrls)
    }
    
    func generateOpenAppSound(_ uuid: UUID) async -> UNNotificationSound {
        return await generateNotificationSoundFromURLs(uuid, [createAudioFileUrl("openapp")])
    }
    
    private func generateNotificationSoundFromURLs(_ uuid: UUID, _ audioFileUrls: [NSURL]) async -> UNNotificationSound {
        await audioProcessor.mix(uuid: uuid, audioFileUrls: audioFileUrls)
        return UNNotificationSound(named: UNNotificationSoundName("notification-\(uuid.uuidString).m4a"))
    }
    
    private func generateTimeSoundURLs(_ seconds: Double, _ minutes: Double?, _ hours: Double?) -> [NSURL] {
        var audioFileUrls: [NSURL] = []
        
        if seconds > 0 {
            createAmountSoundUrls(amount: seconds, unit: .SECOND, audioFileUrls: &audioFileUrls)
        }
        
        if let minutes = minutes {
            if minutes > 0 {
                createAmountSoundUrls(amount: minutes, unit: .MINUTE, audioFileUrls: &audioFileUrls)
            }
            
            if let hours = hours {
                createAmountSoundUrls(amount: hours, unit: .HOUR, audioFileUrls: &audioFileUrls)
            }
        }
        
        return audioFileUrls
    }
    
    private func generateDistanceSoundURLs(_ meters: Double, _ kilometers: Double?) -> [NSURL] {
        var audioFileUrls: [NSURL] = []
        
        if meters > 0 {
            createAmountSoundUrls(amount: meters, unit: .METER, audioFileUrls: &audioFileUrls)
        }
        
        if let kilometers {
            createAmountSoundUrls(amount: kilometers, unit: .KILOMETER, audioFileUrls: &audioFileUrls)
        }
        
        return audioFileUrls
    }
    
    private func createAmountSoundUrls(amount: Double, unit: Unit, audioFileUrls: inout [NSURL]) {
        
        var filename = String(describing: unit).lowercased()
        if amount == 1 {
            filename = String(filename.prefix(filename.count - 1))
        }
        audioFileUrls.append(createAudioFileUrl(filename))
        
        if amount <= 100 {
            audioFileUrls.append(createAudioFileUrl("\(Int(amount))"))
        } else {
            let modulo100 = Int(amount.truncatingRemainder(dividingBy: 100))
            if modulo100 != 0 {
                audioFileUrls.append(createAudioFileUrl("\(modulo100)"))
            }
            
            for i in 2...3 {
                let position = pow(10, Double(i))
                let digit = getDigit(amount, at: position)
                if digit != 0 {
                    audioFileUrls.append(createDigitAudioFileUrl(digit, at: Int(position)))
                }
            }
        }
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
