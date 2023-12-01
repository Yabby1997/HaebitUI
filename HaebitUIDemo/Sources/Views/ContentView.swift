//
//  ContentView.swift
//  HaebitUI
//
//  Created by Seunghun on 11/30/23.
//  Copyright © 2023 seunghun. All rights reserved.
//

import SwiftUI
import HaebitUI

struct ContentView: View {
    @State var selection: DialEntry = .init(title: "1.4")
    var data: [DialEntry] = [1.0, 1.4, 2.0, 2.8, 4.0, 5.6, 8.0, 11, 16, 22].map { DialEntry(title: "\($0)") }
    
    var body: some View {
        VStack {
            Text("Hello HaebitUIDemo")
            VStack {
                Circle()
                    .frame(width: 5, height: 5)
                HaebitDial(data: data, selection: $selection)
                    .frame(maxHeight: 30)
                Text(selection.title)
            }
        }
    }
}

#Preview {
    ContentView()
}
