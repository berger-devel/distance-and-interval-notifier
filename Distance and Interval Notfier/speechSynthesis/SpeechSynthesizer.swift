//
//  SpeechSynthesizer.swift
//  Distance and Interval Notfier
//
//  Created by Stefan Berger on 15.08.22.
//

import Foundation
import AVFAudio
import os

class SpeechSynthesizer {
    
//    private var filename: String? = nil
    private var speechSynthesizer: AVSpeechSynthesizer? = nil
    private var speechSynthesizerDelegate: SpeechSynthesizerDelegate? = nil
    
    func generateDistanceAlert(meters: Int, finishCallback: @escaping () -> Void) {
//        let fileName = "\(meters)-meters-\(Date().timeIntervalSince1970).caf"
//        let fileUrl = SoundsDirectoryManager.soundsDirectory.appendingPathComponent(fileName)
        
        speechSynthesizer = AVSpeechSynthesizer()
        speechSynthesizerDelegate = createDelegate(finishCallback: { finishCallback() })
        speechSynthesizer!.delegate = speechSynthesizerDelegate
        
        writeSound(meters: meters)
    }
    
    private func createDelegate(finishCallback: @escaping () -> Void) -> SpeechSynthesizerDelegate {
        let speechSynthesizerDelegate = SpeechSynthesizerDelegate()
        speechSynthesizerDelegate.setFinishCallback(finishCallback: finishCallback)
        return speechSynthesizerDelegate
    }
    
    private func writeSound(meters: Int) {
        let utterance: AVSpeechUtterance
        if meters > 1000 {
            utterance = AVSpeechUtterance(string: "\(meters) meters")
        } else {
            utterance = AVSpeechUtterance(string: "\(meters), meters")
        }
        
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
//        var output: AVAudioFile?
        
        speechSynthesizer?.speak(utterance)
//        speechSynthesizer!.write(utterance) { (buffer: AVAudioBuffer) in
//            guard let audioPcmBuffer = buffer as? AVAudioPCMBuffer else {
//                fatalError("Invalid buffer type: \(type(of: buffer))")
//            }
//
//            if audioPcmBuffer.frameLength != 0 {
//                do {
//                    if output == nil {
//                        output = try AVAudioFile(
//                        forWriting: fileUrl,
//                        settings: audioPcmBuffer.format.settings,
//                        commonFormat: .pcmFormatInt16,
//                        interleaved: false)
//                    }
//
//                    try output?.write(from: audioPcmBuffer)
//                } catch {
//                    Logger().error("Failed to write audio file: \(error.localizedDescription)")
//                }
//            }
//        }
    }
}
