//
//  PersistenceManager.swift
//  Distance and Interval Notfier
//
//  Created by Stefan Berger on 01.10.22.
//

import Foundation
import CoreData
import os

class PersistenceHelper {
    static func commit(_ context: NSManagedObjectContext, errorLogMessage: String) {
        do {
            try context.save()
        } catch {
            logError(errorLogMessage, error)
        }
    }
    
    static func logError(_ message: String, _ error: Error) {
        Logger().error("\(message): \(error.localizedDescription)")
    }
}
