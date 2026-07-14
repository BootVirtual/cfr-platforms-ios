//
//  API.swift
//  CFR Platforms
//
//  Created by Marc-Tudor Ghencea on 13.07.26.
//

import Foundation

class API {
    private let baseURL: String
    private let stationsCacheKey = "cachedStations"
    
    init(baseURL: String) {
        self.baseURL = baseURL
    }
    
    func fetchStations() async throws -> [Station] {
        let url = URL(string: baseURL + "/stations")
        
        let (data, _) = try await URLSession.shared.data(from: url!)
        
        let stations = try JSONDecoder().decode([Station].self, from: data)
        
        UserDefaults.standard.set(try? JSONEncoder().encode(stations), forKey: stationsCacheKey)
        
        return stations
    }
    
    func cachedStations() -> [Station] {
        if let data = UserDefaults.standard.data(forKey: stationsCacheKey) {
            return try! JSONDecoder().decode([Station].self, from: data)
        }
        
        return []
    }
    
    func fetchData(for station: Station) async throws -> Board {
        let url = URL(string: baseURL + "/stations/" + station.id)
        
        let (data, _) = try await URLSession.shared.data(from: url!)
        
        let board = try JSONDecoder().decode(Board.self, from: data)
        
        return board
    }
}
