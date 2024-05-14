//
//  PersistenceManager.swift
//  Distance and Interval Notfier
//
//  Created by Stefan Berger on 01.10.22.
//

import Foundation
import CoreData

class PersistenceHelper {
    static func commit(_ context: NSManagedObjectContext, errorLogMessage: String) {
        do {
            try context.save()
        } catch {
            Log.error(errorLogMessage, error)
        }
    }
}
