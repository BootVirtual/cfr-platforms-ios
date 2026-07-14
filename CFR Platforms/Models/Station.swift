//
//  Station.swift
//  CFR Platforms
//
//  Created by Marc-Tudor Ghencea on 13.07.26.
//

import Foundation
import AppIntents

struct StationQuery: EntityQuery {
    func entities(for identifiers: [String]) async throws -> [Station] {
        let stations = StationCache.stations
        
        return stations.filter{
            identifiers.contains($0.id)
        }
    }
    
    func suggestedEntities() async throws -> [Station] {
        StationCache.stations
    }
}

struct Station: Identifiable, Hashable, Codable, AppEntity {
    let id: String
    let name: String
    
    static var typeDisplayRepresentation = TypeDisplayRepresentation(name: "Station")
    
    var displayRepresentation: DisplayRepresentation {
        DisplayRepresentation(title: "\(name)")
    }
    
    static var defaultQuery = StationQuery()
}
