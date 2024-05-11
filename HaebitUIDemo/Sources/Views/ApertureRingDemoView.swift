//
//  ApertureRingDemoView.swift
//  HaebitUI
//
//  Created by Seunghun on 11/30/23.
//  Copyright © 2023 seunghun. All rights reserved.
//

import SwiftUI
import HaebitUI

struct ApertureRingDemoView: View {
    @State var selection: Float = 1.4
    @State var entries: [Float] = [1.0, 1.4, 2.0, 2.8, 4.0, 5.6, 8.0, 11, 16, 22]
    
    var body: some View {
        VStack {
            Spacer()
            Text(String(format: "%.1f", selection))
                .font(.largeTitle)
                .fontWeight(.bold)
            Spacer()
            HaebitApertureRing(
                selection: $selection,
                entries: $entries
            ) {
                Circle()
                    .frame(width: 5, height: 5)
                    .foregroundStyle(.red)
            } content: { data in
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
    ApertureRingDemoView()
        .environmentObject(
            HaebitApertureRingDependencies(
                feedbackProvidable: DefaultApertureRingFeedbackProvider()
            )
        )
}
