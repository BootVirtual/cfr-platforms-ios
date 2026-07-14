//
//  AppIntent.swift
//  Station Widget
//
//  Created by Marc-Tudor Ghencea on 14.07.26.
//

import WidgetKit
import AppIntents

struct ConfigurationAppIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource { "CFR Arrivals/Departures" }
    static var description: IntentDescription { "Display live arrivals and departures from CFR stations." }

    @Parameter(title: "Station")
    var station: Station?
    
    @Parameter(title: "Board")
    var board: BoardType?
}
