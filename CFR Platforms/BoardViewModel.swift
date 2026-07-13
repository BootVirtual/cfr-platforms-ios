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
    
    private let api = API()
    
    func load() async {
        let board = try! await api.fetchData()
        
        arrivals = board.arrivals
        departures = board.departures
    }
}
