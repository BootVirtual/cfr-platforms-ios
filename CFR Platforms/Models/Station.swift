//
//  Station.swift
//  CFR Platforms
//
//  Created by Marc-Tudor Ghencea on 13.07.26.
//

import Foundation
import AppIntents

struct Station: Identifiable, Hashable, Codable, AppEntity {
    typealias ID = String
    
    let id: String
    let name: String
    
    static var typeDisplayRepresentation = TypeDisplayRepresentation(name: "Station")
    
    var displayRepresentation: DisplayRepresentation {
        DisplayRepresentation(title: "\(name)")
    }
    
    static var defaultQuery = StationQuery()
}
