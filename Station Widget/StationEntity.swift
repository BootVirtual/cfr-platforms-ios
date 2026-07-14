//
//  StationEntity.swift
//  CFR Platforms
//
//  Created by Marc-Tudor Ghencea on 14.07.26.
//

import Foundation
import AppIntents

struct StationEntity: AppEntity, Hashable {
    typealias ID = String
    
    static let typeDisplayRepresentation = TypeDisplayRepresentation(name: "Station")
    
    static var defaultQuery = StationQuery()
    
    let id: String
    
    @Property(title: "Name")
    var name: String?
    
    init(id: String, name: String){
        self.id = id
        self.name = name
    }
    
    var displayRepresentation: DisplayRepresentation {
        DisplayRepresentation(title: "\(name ?? id)")
    }
    
    static func == (
        lhs: StationEntity,
        rhs: StationEntity
    ) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher){
        hasher.combine(id)
    }
}
