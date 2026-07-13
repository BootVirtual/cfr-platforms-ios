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
        List(viewModel.arrivals) { train in
            VStack(alignment: .leading) {
                Text(
                    "\(train.type) \(train.number)"
                )
                .font(.headline)
                
                Text(train.destination)
                
                Text(train.time)
                    .foregroundStyle(.secondary)
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
