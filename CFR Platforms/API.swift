//
//  API.swift
//  CFR Platforms
//
//  Created by Marc-Tudor Ghencea on 13.07.26.
//

import Foundation

class API {
    private let baseURL: String
    
    init(baseURL: String) {
        self.baseURL = baseURL
    }
    
    func fetchStations() async throws -> [Station] {
        let url = URL(string: baseURL + "/stations")
        
        let (data, _) = try await URLSession.shared.data(from: url!)
        
        let decoder = JSONDecoder()
        
        return try decoder.decode([Station].self, from: data)
    }
    
    func fetchData(for station: Station) async throws -> Board {
        let url = URL(string: baseURL + "/stations/" + station.id)
        
        let (data, _) = try await URLSession.shared.data(from: url!)
        
        let decoder = JSONDecoder()
        
        return try decoder.decode(Board.self, from: data)
    }
}
