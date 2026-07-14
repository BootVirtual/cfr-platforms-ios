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
            let data = SharedConfiguration.defaults?.data(forKey: key),
            let stations = try? JSONDecoder().decode([Station].self, from: data)
        else { return [] }
        
        return stations
    }
    
    static func save(_ stations: [Station]) {
        guard let data = try? JSONEncoder().encode(stations) else { return }
        SharedConfiguration.defaults?.set(data, forKey: key)
    }
}
