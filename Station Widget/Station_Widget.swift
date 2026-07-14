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
    
    @Environment(\.widgetFamily) private var widgetFamily

    var body: some View {
        let trains = entry.boardType == .arrivals ? entry.board.arrivals : entry.board.departures
        
        let trainCount = widgetFamily == .systemMedium ? 3 : 8
        
        VStack (alignment: .leading, spacing: 5){
            HStack{
                Text(entry.station.name)
                    .font(.headline)
                    .lineLimit(1)
                    
                Spacer(minLength: 4)
                if entry.boardType == .arrivals {
                    Label("Arrivals", systemImage: "arrow.down.right")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.secondary)
                        .labelStyle(.titleAndIcon)
                } else {
                    Label("Departures", systemImage: "arrow.up.right")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.secondary)
                        .labelStyle(.titleAndIcon)
                }
            }
            if trains.isEmpty {
                // TODO
            } else {
                VStack(spacing: 0) {
                    ForEach(
                        Array(trains.prefix(trainCount).enumerated()),
                        id: \.element.id
                    ) { index, train in
                        let delay = Int(train.delay) ?? 0
                        HStack (spacing: 10) {
                            Text(train.time)
                                .font(.system(.body, design: .monospaced, weight: .semibold))
                                .monospacedDigit()
                                .frame(width: 56, alignment: .leading)
                            VStack(alignment: .leading, spacing: 1) {
                                Text(train.destination)
                                    .font(.subheadline.weight(.semibold))
                                    .lineLimit(1)
                                Text(train.type + " " + train.number)
                                    .font(.system(.caption, design: .monospaced))
                                    .foregroundStyle(.secondary)
                                    .lineLimit(1)
                            }
                            
                            Spacer()
                            
                            VStack (alignment: .trailing, spacing: 2){
                                if delay > 0 {
                                    Text("+\(delay) min")
                                        .font(.caption.weight(.bold))
                                        .foregroundStyle(.red)
                                } else {
                                    Text("On time")
                                        .font(.caption.weight(.semibold))
                                        .foregroundStyle(.green)
                                }
                                
                                if !train.platform.isEmpty {
                                    Text("Pl. " + train.platform)
                                        .font(.system(.caption, design: .monospaced))
                                        .foregroundStyle(.secondary)

                                }
                            }
                            .frame(minWidth: 60, alignment: .trailing)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 2)
                        
                        if index < min(trains.count, trainCount) - 1 {
                            Divider()
                        }
                    }
                }
            }
        }
        .containerBackground(.white, for: .widget)
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
        .supportedFamilies([.systemMedium, .systemLarge])
        .configurationDisplayName("Arrivals")
        .description("Shows the next arrivals at a chosen station.")
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
        .supportedFamilies([.systemMedium, .systemLarge])
        .configurationDisplayName("Departures")
        .description("Shows the next departures at a chosen station.")
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
            departures: [
                Train(
                    type: "IR",
                    number: "1234",
                    destination: "Craiova",
                    operator: "Transferoviar",
                    time: "12:34",
                    delay: "15",
                    platform: "1"
                ),
                Train(
                    type: "RE",
                    number: "56789",
                    destination: "Giurgiu",
                    operator: "Transferoviar",
                    time: "12:50",
                    delay: "",
                    platform: "12"
                ),
                Train(
                    type: "IC",
                    number: "17",
                    destination: "Suceava",
                    operator: "Transferoviar",
                    time: "13:00",
                    delay: "",
                    platform: "14"
                ),
            ]
        )
    )
}
