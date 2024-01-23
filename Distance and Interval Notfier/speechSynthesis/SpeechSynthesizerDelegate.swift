//
//  SpeechSynthesizerDelegate.swift
//  Distance and Interval Notfier
//
//  Created by Stefan Berger on 15.08.22.
//

import Foundation
import AVFAudio

class SpeechSynthesizerDelegate: NSObject, AVSpeechSynthesizerDelegate {
    
    private var onFinish: () -> Void = { }
    
    func setFinishCallback(finishCallback: @escaping () -> Void) {
        onFinish = finishCallback
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        onFinish()
    }
}
