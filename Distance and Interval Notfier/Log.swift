//
//  Log.swift
//  Distance and Interval Notfier
//
//  Created by Stefan Berger on 12.05.24.
//

import Foundation
import os

class Log {
    private static let logger = Logger(subsystem: "me.stefan-berger", category: "din")
    
    static func debug (_ message: String) {                                   
        logger.info("\(message)")
    }
    
    static func error(_ message: String, _ error: (any Error)?) {
        logger.error("\(message): \(error)")
    }
}
