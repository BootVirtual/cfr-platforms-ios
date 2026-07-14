//
//  CFR_PlatformsApp.swift
//  CFR Platforms
//
//  Created by Marc-Tudor Ghencea on 13.07.26.
//

import SwiftUI

@main
struct CFR_PlatformsApp: App {
    init() {
        SharedConfiguration.installDefaults()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
