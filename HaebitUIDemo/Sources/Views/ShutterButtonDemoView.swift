//
//  ShutterButtonDemoView.swift
//  HaebitUI
//
//  Created by Seunghun on 1/9/24.
//  Copyright © 2024 seunghun. All rights reserved.
//

import SwiftUI
import HaebitUI

struct ShutterButtonDemoView: View {
    @State var shutterSpeed: UInt64 = 1_000_000_000
    let shutterSpeeds: [UInt64] = [
        16_666_667,
        33_333_333,
        66_666_667,
        125_000_000,
        250_000_000,
        500_000_000,
        1_000_000_000,
        2_000_000_000,
        4_000_000_000
    ]
    
    var body: some View {
        VStack {
            Picker("", selection: $shutterSpeed) {
              ForEach(shutterSpeeds, id: \.self) { speed in
                  Text(speed.description)
              }
            }
            .pickerStyle(.wheel)
            HaebitShutterButton(shutterSpeed: $shutterSpeed) {
                print("!!")
            }
        }
    }
}

#Preview {
    ShutterButtonDemoView()
}
