//
//  StationEntity.swift
//  CFR Platforms
//
//  Created by Marc-Tudor Ghencea on 14.07.26.
//

import Foundation
import AppIntents

struct StationEntity: AppEntity, Identifiable, Hashable {
    typealias ID = String
    
    static var typeDisplayRepresentation: TypeDisplayRepresentation {
        TypeDisplayRepresentation(name: "Station")
    }
    
    static var defaultQuery = StationQuery()
    
    let id: String
    let name: String
    
    var displayRepresentation: DisplayRepresentation {
        DisplayRepresentation(title: "\(name)")
    }
    
    init(id: String, name: String){
        self.id = id
        self.name = name
    }
}
