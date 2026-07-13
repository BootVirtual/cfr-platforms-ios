//
//  ArrivalsView.swift
//  CFR Platforms
//
//  Created by Marc-Tudor Ghencea on 13.07.26.
//

import SwiftUI

struct ArrivalsView: View {
    @ObservedObject var viewModel: BoardViewModel
    
    var body: some View {
        TrainList(trains: viewModel.arrivals)
            .refreshable {
                await viewModel.load()
            }
            .navigationTitle(Text("Arrivals"))
            .toolbar {
                ToolbarItem(placement: .principal){
                    StationPicker(viewModel: viewModel)
                }
            }
    }
}
