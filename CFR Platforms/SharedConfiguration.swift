//
//  SharedConfiguration.swift
//  CFR Platforms
//
//  Created by Marc-Tudor Ghencea on 14.07.26.
//

import Foundation

enum SharedConfiguration {
    static let appGroup = "group.com.marctg.cfr-platforms"
    static let defaultAPIURL = "http://192.168.1.247:8000"
    static let apiURLkey = "apiURL"
    
    static let arrivalsWidgetStationKey = "arrivalsWidgetStation"
    static let departuresWidgetStationKey = "departuresWidgetStation"
    
    static var defaults: UserDefaults? {
        UserDefaults(suiteName: appGroup)
    }
    
    static func installDefaults() {
        guard let defaults else {
            print("Cannot open App Group Defaults")
            return
        }
        
        if defaults.object(forKey: apiURLkey) == nil {
            defaults.set(defaultAPIURL, forKey: apiURLkey)
        }
    }
}
