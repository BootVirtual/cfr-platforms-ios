//
//  API.swift
//  CFR Platforms
//
//  Created by Marc-Tudor Ghencea on 13.07.26.
//

import Foundation

class API {
    func fetchData() async throws -> Board {
        let url = URL(string: "http://192.168.1.247:8000/stations/BucurestiNord")
        
        let (data, _) = try await URLSession.shared.data(from: url!)
        
        let decoder = JSONDecoder()
        
        return try decoder.decode(Board.self, from: data)
    }
}
