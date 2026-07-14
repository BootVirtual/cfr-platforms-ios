//
//  StationEntity.swift
//  CFR Platforms
//
//  Created by Marc-Tudor Ghencea on 14.07.26.
//

import Foundation
import AppIntents

struct StationEntity: AppEntity, Identifiable, Hashable {
    static var typeDisplayRepresentation: TypeDisplayRepresentation {
        TypeDisplayRepresentation(name: "Station")
    }
    
    static let defaultQuery = StationQuery()
    
    let id: Station.ID
    let name: String
    
    var displayRepresentation: DisplayRepresentation {
        DisplayRepresentation(title: "\(name)")
    }
}
