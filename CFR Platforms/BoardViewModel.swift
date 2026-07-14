//
//  BoardViewModel.swift
//  CFR Platforms
//
//  Created by Marc-Tudor Ghencea on 13.07.26.
//

import Foundation
internal import Combine
import SwiftUI

@MainActor
class BoardViewModel: ObservableObject {
    
    @Published var stations: [Station] = []
    @Published var arrivals: [Train] = []
    @Published var departures: [Train] = []
    
    @AppStorage("selectedStationID")
    private var selectedStationID: String = ""
    
    @Published var selectedStation: Station? {
        didSet {
            selectedStationID = selectedStation?.id ?? ""
        }
    }
    
    @AppStorage("apiURL", store: SharedConfiguration.defaults)
    var apiURL = SharedConfiguration.defaultAPIURL
    
    func loadStations() async {
        let api = API(baseURL: apiURL)
        
        stations = api.cachedStations()
        selectedStation = stations.first(where: {$0.id == selectedStationID}) ?? stations.first
        
        do {
            stations = try await api.fetchStations()
            
            selectedStation = stations.first(where: {$0.id == selectedStationID}) ?? stations.first
        } catch {
            print("Error: ", error)
        }
    }
    
    func load() async {
        let station = selectedStation!
        
        do{
            let api = API(baseURL: apiURL)
            
            let board = try await api.fetchData(for: station)
            
            arrivals = board.arrivals
            departures = board.departures
        } catch {
            print("Error: ", error)
        }
    }
}
