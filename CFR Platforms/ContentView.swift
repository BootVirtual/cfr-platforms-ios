//
//  ContentView.swift
//  CFR Platforms
//
//  Created by Marc-Tudor Ghencea on 13.07.26.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = BoardViewModel()
    
    var body: some View {
        TabView{
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
        }
        .task {
            await viewModel.load()
        }
    }
}

#Preview {
    ContentView()
}
