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
        get {
            do {
                guard let url = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask).last else {
                    throw OptionalError.from("url")
                }
                
                return url.appendingPathComponent("Sounds")
            } catch {
                Log.error("Error getting sounds directory", error)
                return URL(filePath: "")
            }
        }
    }
    
    static func createSoundsDirectory() {
        do {
            guard let libraryUrl = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask).last else {
                throw OptionalError.from("fileUrl")
            }
            
            let soundsUrl = libraryUrl.appendingPathComponent("Sounds")
            if !FileManager.default.fileExists(atPath: soundsUrl.path) {
                do {
                    try FileManager.default.createDirectory(at: soundsUrl, withIntermediateDirectories: true)
                } catch {
                    Logger().error("Error creating sounds directory: \(error.localizedDescription)")
                }
            }
        } catch {
            Log.error("Error creating sounds directory", error)
        }
    }
    
    static func initCleanupTimer() {
        cleanupSounds()
        timer = Timer.scheduledTimer(withTimeInterval: 60 * 60 * 6, repeats: true) { _ in
           cleanupSounds()
       }
    }
    
    private static func cleanupSounds() {
        do {
            let fileUrls = try FileManager.default.contentsOfDirectory(at: soundsDirectory, includingPropertiesForKeys: [.contentModificationDateKey])
            guard let sixHoursAgo = Calendar.current.date(byAdding: .hour, value: -6, to: Date()) else {
                throw OptionalError.from("sixHoursAgo")
            }
            
            if fileUrls.count != 0 {
                var counter = 0
                try fileUrls.forEach { url in
                    let resourceValues: URLResourceValues = try url.resourceValues(forKeys: [.contentModificationDateKey])
                    guard let contentModificationDate = resourceValues.contentModificationDate else {
                        throw OptionalError.from("contentModificationDate")
                    }
                    if Calendar.current.compare(sixHoursAgo, to: contentModificationDate, toGranularity: .second) == .orderedDescending {
                        try FileManager.default.removeItem(at: url)
                        counter += 1
                    }
                }
                
                
                Logger().info("Deleted \(counter) of \(fileUrls.count) sound files created before \(ISO8601DateFormatter().string(from: sixHoursAgo))")
            }
        } catch {
            Logger().error("Error cleaning up sounds directory: \(error.localizedDescription)")
        }
    }
}
