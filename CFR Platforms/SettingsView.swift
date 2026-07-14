//
//  SettingsView.swift
//  CFR Platforms
//
//  Created by Marc-Tudor Ghencea on 13.07.26.
//

import SwiftUI
import WidgetKit

struct SettingsView: View {
    @ObservedObject var viewModel: BoardViewModel
    
    var body: some View {
        Form{
            Section("API") {
                TextField("API URL", text: $viewModel.apiURL)
                    .textInputAutocapitalization(.never)
                    .keyboardType(.URL)
            }
            Section("Widgets") {
                Picker("Arrivals Widget", selection: $viewModel.arrivalsStation) {
                    ForEach(viewModel.stations) { station in
                        Text(station.name)
                            .tag(station.id)
                    }
                }
                Picker("Departures Widget", selection: $viewModel.departuresStation) {
                    ForEach(viewModel.stations) { station in
                        Text(station.name)
                            .tag(station.id)
                    }
                }
            }
        }
        .navigationTitle(Text("Settings"))
        .onDisappear {
            Task {
                SharedConfiguration.defaults?.set(
                    viewModel.apiURL,
                    forKey: SharedConfiguration.apiURLkey
                )
                
                await viewModel.loadStations()
                await viewModel.load()
                
                WidgetCenter.shared.reloadAllTimelines()
            }
        }
    }
}
