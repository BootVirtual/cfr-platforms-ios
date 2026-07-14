//
//  BoardType.swift
//  CFR Platforms
//
//  Created by Marc-Tudor Ghencea on 14.07.26.
//

import Foundation
import AppIntents

enum BoardType: String, AppEnum {
    case arrivals
    case departures
    
    static var typeDisplayRepresentation = TypeDisplayRepresentation(name: "Board")
    
    static var caseDisplayRepresentations: [Self : DisplayRepresentation] = [
        .arrivals: "Arrivals",
        .departures: "Departures"
    ]
}
