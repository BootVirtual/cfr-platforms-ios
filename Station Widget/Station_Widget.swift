//
//  Station_Widget.swift
//  Station Widget
//
//  Created by Marc-Tudor Ghencea on 14.07.26.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    let boardType: BoardType
    let stationIDKey: String
    
    func placeholder(in context: Context) -> BoardEntry {
        BoardEntry(
            date: Date(),
            station: Station(id: "BucurestiNord", name: "București Nord"),
            boardType: .departures,
            board: Board(arrivals: [], departures: [])
        )
    }

    func getSnapshot(in context: Context, completion: @escaping (BoardEntry) -> Void
    ) {
        completion(placeholder(in: context))
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<BoardEntry>) -> Void) {
        Task{
            let timeline = await makeTimeline(in: context)
            completion(timeline)
        }
    }
    
    private func makeTimeline(in context: Context) async -> Timeline<BoardEntry> {
        guard let selectedStationID = SharedConfiguration.defaults?.string(forKey: stationIDKey) else {
            print("No station in: ", stationIDKey)
            
            return retryTimeline(entry: placeholder(in: context))
        }
        
        guard let station = StationCache.stations.first(where: {$0.id == selectedStationID}) else {
            print("Station not in cache")
            
            return retryTimeline(entry: placeholder(in: context))
        }
        
        guard
            let apiURL = SharedConfiguration.defaults?.string(forKey: SharedConfiguration.apiURLkey),
            !apiURL.isEmpty
        else{
            print("apiURL not configured")
            
            return retryTimeline(entry: placeholder(in: context))
        }
        
        do {
            let board = try await API(baseURL: apiURL).fetchData(for: station)
            
            let entry = BoardEntry(
                date: Date(),
                station: station,
                boardType: boardType,
                board: board
            )
            
            return Timeline(
                entries: [entry],
                policy: .after(Date().addingTimeInterval(60))
            )
        } catch {
            print("Request failed: ", error)
            
            return retryTimeline(
                entry: BoardEntry(
                    date: Date(),
                    station: station,
                    boardType: boardType,
                    board: Board(arrivals: [], departures: [])
                )
            )
        }
    }
    
    private func retryTimeline(entry: BoardEntry) -> Timeline<BoardEntry> {
        Timeline(
            entries: [entry],
            policy: .after(Date().addingTimeInterval(30))
        )
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

struct ArrivalsWidget: Widget {
    let kind: String = "com.marctg.cfr-platforms.arrivals-widget"

    var body: some WidgetConfiguration {
        StaticConfiguration(
            kind: "com.marctg.cfr-platforms.arrivals-widget",
            provider: Provider(
                boardType: .arrivals,
                stationIDKey: SharedConfiguration.arrivalsWidgetStationKey
            )
        ) { entry in
            Station_WidgetEntryView(entry: entry)
        }
    }
}

struct DeparturesWidget: Widget {
    let kind: String = "com.marctg.cfr-platforms.departures-widget"

    var body: some WidgetConfiguration {
        StaticConfiguration(
            kind: "com.marctg.cfr-platforms.departures-widget",
            provider: Provider(
                boardType: .departures,
                stationIDKey: SharedConfiguration.departuresWidgetStationKey
            )
        ) { entry in
            Station_WidgetEntryView(entry: entry)
        }
    }
}

#Preview(as: .systemMedium) {
    DeparturesWidget()
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
