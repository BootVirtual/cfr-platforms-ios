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
        NavigationStack{
            TabView{
                ArrivalsView(viewModel: viewModel)
                    .tabItem{
                        Label("Arrivals", systemImage: "arrow.down")
                    }
                
                DeparturesView(viewModel: viewModel)
                    .tabItem {
                        Label("Departures", systemImage: "arrow.up")
                    }
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
