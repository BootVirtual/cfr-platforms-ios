//
//  Board.swift
//  CFR Platforms
//
//  Created by Marc-Tudor Ghencea on 13.07.26.
//

import Foundation

struct Board: Decodable {
    let arrivals: [Train]
    let departures: [Train]
}
