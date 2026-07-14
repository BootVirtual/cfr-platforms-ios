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
            station: StationEntity(id: "BucurestiNord", name: "Bucharest North"),
            boardType: .departures,
            board: Board(arrivals: [], departures: [])
        )
    }

    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> BoardEntry {
        BoardEntry(
            date: Date(),
            station: StationEntity(id: "BucurestiNord", name: "Bucharest North"),
            boardType: .departures,
            board: Board(arrivals: [], departures: [])
        )
    }
    
    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<BoardEntry> {
        guard let apiURL = UserDefaults(suiteName: "group.com.marctg.cfr-platforms")?.string(forKey: "apiURL") else { return Timeline(entries: [], policy: .never) }
        
        let api = API(baseURL: apiURL)
                      
        guard
            let station = configuration.station,
            let boardType = configuration.board
        else {
            return Timeline(entries: [], policy: .never)
        }
        
        guard
            let board = try? await api.fetchData(for: Station(id: station.id, name: station.name))
        else{
            return Timeline(entries: [], policy: .never)
        }
        
        let entry = BoardEntry(date: Date(), station: station, boardType: boardType, board: board)
        
        return Timeline(entries: [entry], policy: .after(Date().addingTimeInterval(60)))
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
                Text(entry.station.name)
                
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
            intent: ConfigurationAppIntent.self,
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
