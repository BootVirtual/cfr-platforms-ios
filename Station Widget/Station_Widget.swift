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
        BoardEntry(date: Date(), station: Station(id: "BucurestiNord", name: "Bucharest North"), boardType: .departures, board: Board(arrivals: [], departures: [])
        )
    }

    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> BoardEntry {
        let station = configuration.station ?? Station(id: "BucurestiNord", name: "Bucharest North")
        
        let boardType = configuration.board ?? .departures
        
        return BoardEntry(
            date: Date(),
            station: station,
            boardType: boardType,
            board: Board(arrivals: [], departures: [])
        )
    }
    
    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<BoardEntry> {
        guard
            let station = configuration.station,
            let boardType = configuration.board
        else{
            return Timeline(entries: [], policy: .never)
        }
        
        let api = API(baseURL: (UserDefaults(suiteName: "group.com.marctg.cfr-platforms")?.string(forKey: "apiURL"))!)
        
        let board = try! await api.fetchData(for: station)
        
        let entry = BoardEntry(date: Date(), station: station, boardType: boardType, board: board)
        
        return Timeline(entries: [entry], policy: .after(Date().addingTimeInterval(60)))
    }

//    func relevances() async -> WidgetRelevances<ConfigurationAppIntent> {
//        // Generate a list containing the contexts this widget is relevant in.
//    }
}

struct BoardEntry: TimelineEntry{
    let date: Date
    let station: Station
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
    let kind: String = "Station Widget"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: ConfigurationAppIntent.self, provider: Provider()) { entry in
            Station_WidgetEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
    }
}

#Preview(as: .systemMedium) {
    Station_Widget()
} timeline: {
    BoardEntry(
        date: Date(),
        station: Station(id: "BucurestiNord", name: "Bucharest North"),
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
