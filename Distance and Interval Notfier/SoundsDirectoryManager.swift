//
//  SoundsDirectoryManager.swift
//  Distance and Interval Notfier
//
//  Created by Stefan Berger on 15.08.22.
//

import Foundation
import os

struct SoundsDirectoryManager {
    private static var timer: Timer? = nil
    
    static var soundsDirectory: URL {
        get { FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask).last!.appendingPathComponent("Sounds") }
    }
    
    static func createSoundsDirectory() {
        let fileUrl = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask).last!.appendingPathComponent("Sounds")
        if !FileManager.default.fileExists(atPath: fileUrl.path) {
            do {
                try FileManager.default.createDirectory(at: fileUrl, withIntermediateDirectories: true)
            } catch {
                Logger().error("Error creating sounds directory: \(error.localizedDescription)")
            }
        }
    }
    
    static func initCleanupTimer() {
        cleanupSounds()
        timer = Timer.scheduledTimer(withTimeInterval: 60, repeats: true) { timer in
           cleanupSounds()
       }
    }
    
    private static func cleanupSounds() {
        do {
            let fileUrls = try FileManager.default.contentsOfDirectory(at: soundsDirectory, includingPropertiesForKeys: [.contentModificationDateKey])
            let tenSecondsAgo = Date() - 10
            
            if fileUrls.count != 0 {
                var counter = 0
                try fileUrls.forEach { url in
                    let resourceValues: URLResourceValues = try url.resourceValues(forKeys: [.contentModificationDateKey])
                    if Calendar.current.compare(tenSecondsAgo, to: resourceValues.contentModificationDate!, toGranularity: .second) == .orderedDescending {
                        try FileManager.default.removeItem(at: url)
                        counter += 1
                    }
                }
                
                
                Logger().info("Deleted \(counter) of \(fileUrls.count) sound files created before \(ISO8601DateFormatter().string(from: tenSecondsAgo))")
            }
        } catch {
            Logger().error("Could not clean up sounds directory: \(error.localizedDescription)")
        }
    }
}
