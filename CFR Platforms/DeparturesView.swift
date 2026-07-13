//
//  DeparturesView.swift
//  CFR Platforms
//
//  Created by Marc-Tudor Ghencea on 13.07.26.
//

import SwiftUI

struct DeparturesView: View {
    @ObservedObject var viewModel: BoardViewModel
    
    var body: some View {
        TrainList(trains: viewModel.departures)
            .navigationTitle(Text("Departures"))
            .toolbar {
                ToolbarItem(placement: .principal){
                    StationPicker(viewModel: viewModel)
                }
            }
    }
}
