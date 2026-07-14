//
//  StationQuery.swift
//  CFR Platforms
//
//  Created by Marc-Tudor Ghencea on 14.07.26.
//

import Foundation
import AppIntents

struct StationQuery: EntityQuery {
    func entities(for identifiers: [StationEntity.ID]) async throws -> [StationEntity] {
        let stations = try await loadStations()
        
        let entitiesByID = Dictionary(
            uniqueKeysWithValues: stations.map {
                (
                    $0.id,
                    StationEntity(
                        id: $0.id,
                        name: $0.name
                    )
                )
            }
        )
        
        let resolved = identifiers.compactMap{
            entitiesByID[$0]
        }
        
        print("StationQuery requested IDs: ", identifiers)
        print("StationQuery available IDs: ", stations.map(\.id))
        print("StationQuery resolved IDs: ", resolved.map(\.id))
        
        return resolved
    }
    
    func suggestedEntities() async throws -> [StationEntity] {
        let stations = try await loadStations()
        
        print("StationQuery suggestions: ", stations.map{ "\($0.id): \($0.name)"})
        
        return stations.map {
            StationEntity(
                id: $0.id,
                name: $0.name
            )
        }
    }
    
    func defaultResult() async -> StationEntity? {
        try? await suggestedEntities().first
    }
    
    private func loadStations() async throws -> [Station] {
        let cachedStations = StationCache.stations
        
        if !cachedStations.isEmpty {
            print("Using cached stations: ", cachedStations.map(\.id))
            
            return cachedStations
        }
        
        print("Station cache empty")
        
        guard
            let apiURL = SharedConfiguration.defaults?.string(forKey: SharedConfiguration.apiURLkey),
            !apiURL.isEmpty
        else{
            print("API URL not set")
            return []
        }
        
        let api = API(baseURL: apiURL)
        return try await api.fetchStations()
    }
}
