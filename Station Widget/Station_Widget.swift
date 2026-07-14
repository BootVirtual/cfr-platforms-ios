//
//  Station_Widget.swift
//  Station Widget
//
//  Created by Marc-Tudor Ghencea on 14.07.26.
//

import WidgetKit
import SwiftUI

struct Provider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> BoardEntry {
        BoardEntry(
            date: Date(),
            station: StationEntity(id: "BucurestiNord", name: "București Nord"),
            boardType: .departures,
            board: Board(arrivals: [], departures: [])
        )
    }

    func snapshot(for configuration: ConfigurationAppIntentV2, in context: Context) async -> BoardEntry {
        if context.isPreview{
            return BoardEntry(
                date: Date(),
                station: configuration.station ?? StationEntity(id: "BucurestiNord", name: "București Nord"),
                boardType: configuration.board ?? .departures,
                board: Board(arrivals: [], departures: [])
            )
        }
        
        return await loadEntry(
            station: configuration.station ?? StationEntity(id: "BucurestiNord", name: "București Nord"),
            boardType: configuration.board ?? .departures,
        )
    }
    
    func timeline(for configuration: ConfigurationAppIntentV2, in context: Context) async -> Timeline<BoardEntry> {
        print("REQ STATION: ", configuration.station?.id ?? "nil")
        print("REQ BOARD: ", configuration.board ?? "nil")
        
        let fallback = placeholder(in: context)
        
        guard let station = configuration.station else {
            print("No station configured")
            
            return Timeline(
                entries: [fallback],
                policy: .after(Date().addingTimeInterval(30))
            )
        }
    
        let entry = await loadEntry(
            station: station,
            boardType: configuration.board ?? .departures
        )
        
        return Timeline(
            entries: [entry],
            policy: .after(Date().addingTimeInterval(60))
        )
        
    }
    
    private func loadEntry(station: StationEntity, boardType: BoardType) async -> BoardEntry {
        guard
            let apiURL = SharedConfiguration.defaults?.string(forKey: SharedConfiguration.apiURLkey),
            !apiURL.isEmpty
        else{
            print("apiURL not configured")
            
            return BoardEntry(
                date: Date(),
                station: station,
                boardType: boardType,
                board: Board(arrivals: [], departures: [])
            )
        }
        
        do {
            let api = API(baseURL: apiURL)
            
            let board = try await api.fetchData(
                for: Station(id: station.id, name: station.name ?? station.id)
            )
            
            return BoardEntry(
                date: Date(),
                station: station,
                boardType: boardType,
                board: board
            )
        } catch {
            print("Widget request failed: ", error)
            
            return BoardEntry(
                date: Date(),
                station: station,
                boardType: boardType,
                board: Board(arrivals: [], departures: [])
            )
        }
    }

//    func relevances() async -> WidgetRelevances<ConfigurationAppIntent> {
//        // Generate a list containing the contexts this widget is relevant in.
//    }
}

struct BoardEntry: TimelineEntry{
    let date: Date
    let station: StationEntity
    let boardType: BoardType
    let board: Board
}

struct Station_WidgetEntryView : View {
    var entry: BoardEntry

    var body: some View {
        VStack (alignment: .leading){
            HStack{
                Text(entry.station.name ?? entry.station.id)
                
                if(entry.boardType == .arrivals){
                    Text("Arrivals")
                }
                else{
                    Text("Departures")
                }
            }
            .font(.headline)
            
            let trains = entry.boardType == .arrivals ? entry.board.arrivals : entry.board.departures
            
            ForEach(trains.prefix(3)) { train in
                HStack{
                    Text(train.type + " " + train.number)
                }
            }
        }
    }
}

struct Station_Widget: Widget {
    let kind: String = "com.marctg.station-widget"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(
            kind: kind,
            intent: ConfigurationAppIntentV2.self,
            provider: Provider()) { entry in
            Station_WidgetEntryView(entry: entry)
        }
    }
}

#Preview(as: .systemMedium) {
    Station_Widget()
} timeline: {
    BoardEntry(
        date: Date(),
        station: StationEntity(id: "BucurestiNord", name: "Bucharest North"),
        boardType: .departures,
        board: Board(
            arrivals: [],
            departures: [Train(
                type: "IR",
                number: "1234",
                destination: "Craiova",
                operator: "Transferoviar",
                time: "12:34",
                delay: "15",
                platform: "12")
            ]
        )
    )
}
