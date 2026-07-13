//
//  BoardViewModel.swift
//  CFR Platforms
//
//  Created by Marc-Tudor Ghencea on 13.07.26.
//

import Foundation
internal import Combine

@MainActor
class BoardViewModel: ObservableObject {
    
    @Published var arrivals: [Train] = []
    @Published var departures: [Train] = []
    @Published var selectedStation: Station
    
    let stations: [Station] = [
        Station(id: "BucurestiNord", name: "Bucharest North"),
        Station(id: "ClujNapoca", name: "Cluj Napoca"),
    ]
    
    init() {
        selectedStation = stations[0]
    }
    
    private let api = API()
    
    func load() async {
        let board = try! await api.fetchData(for: selectedStation)
        
        arrivals = board.arrivals
        departures = board.departures
    }
}
