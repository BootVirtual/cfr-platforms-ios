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
    
    @Published var arrivals: [Train] = []
    @Published var departures: [Train] = []
    @Published var selectedStation: Station
    
    @AppStorage("apiURL")
    var apiURL = "http://192.168.1.247:8000"
    
    let stations: [Station] = [
        Station(id: "BucurestiNord", name: "Bucharest North"),
        Station(id: "ClujNapoca", name: "Cluj Napoca"),
    ]
    
    init() {
        selectedStation = stations[0]
    }
    
    func load() async {
        let station = selectedStation
        
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
