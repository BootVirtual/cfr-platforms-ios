//
//  StationQuery.swift
//  CFR Platforms
//
//  Created by Marc-Tudor Ghencea on 14.07.26.
//

import Foundation
import AppIntents

struct StationQuery: EntityQuery {
    func entities(for identifiers: [Station.ID]) async throws -> [Station] {
        let stations = StationCache.stations
        
        return stations.filter{
            identifiers.contains($0.id)
        }
    }
    
    func suggestedEntities() async throws -> [Station] {
        let stations = StationCache.stations
        
        print("Stations: ", stations)
        
        return stations
    }
}
