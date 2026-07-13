//
//  TrainList.swift
//  CFR Platforms
//
//  Created by Marc-Tudor Ghencea on 13.07.26.
//

import SwiftUI

struct TrainList: View {
    let trains: [Train]
    
    var body: some View {
        List (trains) { train in
            VStack(alignment: .leading) {
                TrainCard(train: train)
            }
        }
    }
}
