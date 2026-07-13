//
//  Train.swift
//  CFR Platforms
//
//  Created by Marc-Tudor Ghencea on 13.07.26.
//

import Foundation

struct Train: Identifiable, Decodable {
    var id: String {
        number
    }
    
    let type: String
    let number: String
    let destination: String
    let `operator`: String
    let time: String
    let delay: String
    let platform: String
}
