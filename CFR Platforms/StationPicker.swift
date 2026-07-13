//
//  StationPicker.swift
//  CFR Platforms
//
//  Created by Marc-Tudor Ghencea on 13.07.26.
//

import SwiftUI

struct StationPicker: View {
    @ObservedObject var viewModel: BoardViewModel
    
    var body: some View {
        Menu {
            ForEach(viewModel.stations) { station in
                Button {
                    viewModel.selectedStation = station
                    Task {
                        await viewModel.load()
                    }
                } label: {
                        Text(station.name)
                }
            }
        } label: {
            HStack {
                Text(viewModel.selectedStation?.name ?? "Loading...")
                    .font(.headline)
                Image(systemName: "chevron.down")
                    .font(.caption)
            }
        }
    }
}

