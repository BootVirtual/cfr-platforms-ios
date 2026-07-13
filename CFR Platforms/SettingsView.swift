//
//  SettingsView.swift
//  CFR Platforms
//
//  Created by Marc-Tudor Ghencea on 13.07.26.
//

import SwiftUI

struct SettingsView: View {
    @ObservedObject var viewModel: BoardViewModel
    
    var body: some View {
        Form{
            Section("API") {
                TextField("API URL", text: $viewModel.apiURL)
                    .textInputAutocapitalization(.never)
                    .keyboardType(.URL)
            }
        }
        .navigationTitle(Text("Settings"))
    }
}
