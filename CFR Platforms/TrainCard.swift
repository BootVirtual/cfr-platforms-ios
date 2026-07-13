//
//  TrainCard.swift
//  CFR Platforms
//
//  Created by Marc-Tudor Ghencea on 13.07.26.
//

import SwiftUI

struct TrainCard: View {
    let train: Train
    
    var body: some View {
        HStack{
            VStack(alignment: .leading){
                HStack{
                    Image(systemName: "tram.fill")
                    Text(train.type + " " + train.number)
                }
                Text(train.destination)
                    .font(.title2)
                Text("operated by " + train.operator)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            VStack(alignment: .trailing){
                if(!train.delay.isEmpty){
                    Text("+" + train.delay + " min")
                        .foregroundStyle(Color(.systemRed))
                }
                else{
                    Text("On time")
                        .foregroundStyle(Color(.systemGreen))
                }
                Text(train.time)
                    .font(.title2)
                Text(train.platform.isEmpty ? "" : "Platform " + train.platform)
            }
            
        }
        .padding()
    }
}

#Preview {
    TrainCard(train: Train(type: "IR", number: "1234", destination: "Giurgiu", operator: "Transferoviar", time: "12:34", delay: "", platform: ""))
}
