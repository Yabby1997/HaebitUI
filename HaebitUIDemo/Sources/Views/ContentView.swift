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
    @State var selection: Float = 1.4
    var data: [Float] = [1.0, 1.4, 2.0, 2.8, 4.0, 5.6, 8.0, 11, 16, 22]
    
    var body: some View {
        VStack {
            Spacer()
            Text(String(format: "%.1f", selection))
                .font(.largeTitle)
                .fontWeight(.bold)
            Spacer()
            HaebitDial(data: data, selection: $selection) {
                Circle().foregroundStyle(.red)
            } contentLabel: { data in
                Text(String(format: "%.1f", data))
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
            }
            .shadow(radius: 5)
            Spacer()
        }
        .onAppear {
            Task { @MainActor in
                try? await Task.sleep(nanoseconds: 1_000_000_000)
                selection = 11
            }
        }
    }
}

#Preview {
    ContentView()
}
