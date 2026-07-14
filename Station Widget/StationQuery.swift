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
        StationCache.stations
            .filter{identifiers.contains($0.id)}
            .map{
                StationEntity(id: $0.id, name: $0.name)
            }
    }
    
    func suggestedEntities() async throws -> [StationEntity] {
        StationCache.stations.map{
            StationEntity(id: $0.id, name: $0.name)
        }
    }
    
    func defaultResult() async -> StationEntity? {
        try? await suggestedEntities().first
    }
}
