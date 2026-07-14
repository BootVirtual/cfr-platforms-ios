//
//  ContentView.swift
//  CFR Platforms
//
//  Created by Marc-Tudor Ghencea on 13.07.26.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = BoardViewModel()
    
    @AppStorage("selectedTab")
    private var selectedTab = 0
    
    var body: some View {
        TabView (selection: $selectedTab){
            NavigationStack{
                ArrivalsView(viewModel: viewModel)
                    .toolbar{
                        ToolbarItem(placement: .topBarTrailing) {
                            NavigationLink {
                                SettingsView(viewModel: viewModel)
                            } label: {
                                Image(systemName: "gear")
                            }
                        }
                    }
            }
            .tabItem{
                Label("Arrivals", systemImage: "arrow.down")
            }
            .tag(0)
            
            NavigationStack {
                DeparturesView(viewModel: viewModel)
                    .toolbar{
                        ToolbarItem(placement: .topBarTrailing) {
                            NavigationLink {
                                SettingsView(viewModel: viewModel)
                            } label: {
                                Image(systemName: "gear")
                            }
                        }
                    }
                

            }
            .tabItem {
                Label("Departures", systemImage: "arrow.up")
            }
            .tag(1)
        }
        .task {
            await viewModel.loadStations()
            await viewModel.load()
        }
    }
}

#Preview {
    ContentView()
}
