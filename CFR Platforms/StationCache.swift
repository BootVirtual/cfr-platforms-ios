//
//  StationCache.swift
//  CFR Platforms
//
//  Created by Marc-Tudor Ghencea on 14.07.26.
//

import Foundation

struct StationCache {
    private static let key = "cachedStations"
    
    static var stations: [Station] {
        guard
            let data = UserDefaults(suiteName: "group.com.marctg.cfr-platforms")?.data(forKey: key),
            let stations = try? JSONDecoder().decode([Station].self, from: data)
        else { return [] }
        
        return stations
    }
    
    static func save(_ stations: [Station]) {
        guard let data = try? JSONEncoder().encode(stations) else { return }
        UserDefaults(suiteName: "group.com.marctg.cfr-platforms")?.set(data, forKey: key)
    }
}
