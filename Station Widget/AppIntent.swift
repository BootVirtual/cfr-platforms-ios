//
//  AppIntent.swift
//  Station Widget
//
//  Created by Marc-Tudor Ghencea on 14.07.26.
//

import AppIntents

struct ConfigurationAppIntentV2: WidgetConfigurationIntent {
    static var title: LocalizedStringResource { "CFR Arrivals/Departures" }
    static var description: IntentDescription { "Display live arrivals and departures from CFR stations." }

    @Parameter(title: "Station")
    var station: StationEntity?
    
    @Parameter(title: "Board")
    var board: BoardType?
    
    static var parameterSummary: some ParameterSummary {
        Summary("Configure the board"){
            \.$station
            \.$board
        }
    }
}
