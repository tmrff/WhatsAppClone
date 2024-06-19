//
//  TimeInterval+Extensions.swift
//  WhatsAppClone
//
//  Created by Thomas on 19/06/2024.
//

import Foundation

extension TimeInterval {
    var formatElapsedTime: String {
        let minuites = Int(self) / 60
        let seconds = Int(self) % 60
        return String(format: "%02d:%02d", minuites, seconds)
    }
    
    static var stubTimeInterval: TimeInterval {
        return TimeInterval()
    }
}
