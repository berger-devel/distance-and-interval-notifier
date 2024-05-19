//
//  AudioProcessor.swift
//  Distance and Interval Notfier
//
//  Created by Stefan Berger on 12.05.24.
//

import Foundation
import AVFoundation

class AudioProcessor {
    
    func mix(uuid: UUID, audioFileUrls: [NSURL]) async {
        do {
            let composition = AVMutableComposition()
            guard let composition = await createTracks(composition, audioFileUrls, compositionDuration: .zero) else {
                throw OptionalError.from("composition")
            }
            await exportNotificationSound(uuid: uuid, composition: composition)
        } catch {
            Log.error("Error mixing audio files", error)
        }
    }
    
    private func createTracks(_ composition: AVMutableComposition, _ audioFileUrls: [NSURL], compositionDuration: CMTime) async -> AVMutableComposition? {
        var urls = audioFileUrls
        let url = urls.removeLast()
        
        do {
            guard let audioTrack = composition.addMutableTrack(withMediaType: AVMediaType.audio, preferredTrackID: CMPersistentTrackID()) else {
                throw OptionalError.from("audioTrack")
            }
            
            let avAsset = AVURLAsset(url: url as URL, options: nil)
            
            let tracks = try await avAsset.loadTracks(withMediaType: .audio)
            
            guard let assetTrack = tracks.first else {
                throw OptionalError.from("assetTrack")
            }
            
            let duration = try await assetTrack.load(.timeRange).duration
            let timeRange = CMTimeRangeMake(start: CMTime.zero, duration: duration)
            
            try audioTrack.insertTimeRange(timeRange, of: assetTrack, at: compositionDuration)
            
            if urls.isEmpty {
                return composition
            } else {
                return await createTracks(composition, urls, compositionDuration: CMTimeAdd(duration, compositionDuration))
            }
        } catch {
            Log.error("Error creating audio tracks", error)
            return nil
        }
        
    }
    
    private func exportNotificationSound(uuid: UUID, composition: AVMutableComposition) async {
        let fileDestinationUrl = SoundsDirectoryManager.soundsDirectory.appending(component: "notification-\(uuid.uuidString).m4a")
        
        if (FileManager.default.fileExists(atPath: fileDestinationUrl.path)) {
            do {
                try FileManager.default.removeItem(at: fileDestinationUrl)
            } catch {
                Log.error("Error deleting notification file", error)
            }
        }
        
        let assetExport = AVAssetExportSession(asset: composition, presetName: AVAssetExportPresetAppleM4A)
        assetExport?.outputFileType = AVFileType.m4a
        assetExport?.outputURL = fileDestinationUrl
        
        await assetExport?.export()
        if assetExport?.status == .failed {
            Log.error("Error exporting audio file", assetExport?.error)
        } else if assetExport?.status == .cancelled {
            Log.error("Audio file export cancelled", assetExport?.error)
        }
    }
}
