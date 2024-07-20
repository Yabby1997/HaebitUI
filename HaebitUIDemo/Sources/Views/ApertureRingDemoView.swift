//
//  ApertureRingDemoView.swift
//  HaebitUI
//
//  Created by Seunghun on 11/30/23.
//  Copyright © 2023 seunghun. All rights reserved.
//

import SwiftUI
import HaebitUI

enum FeedbackStyle: String, CaseIterable, Identifiable {
    case heavy = "Heavy"
    case medium = "Medium"
    case light = "Light"
    case rigid = "Rigid"
    case soft = "Soft"
    
    var id: String { self.rawValue }
    var impactGeneraterFeedbackStyle: UIImpactFeedbackGenerator.FeedbackStyle {
        switch self {
        case .heavy: return .heavy
        case .medium: return .medium
        case .light: return .light
        case .rigid: return .rigid
        case .soft: return .soft
        }
    }
}

struct ApertureRingDemoView: View {
    @State var selection: Float = 1.4
    @State var entries: [Float] = [1.0, 1.4, 2.0, 2.8, 4.0, 5.6, 8.0, 11, 16, 22]
    @State var feedbackStyle: FeedbackStyle = .heavy
    @State var isMute: Bool = false
    
    var body: some View {
        VStack {
            Spacer()
            Text(String(format: "%.1f", selection))
                .font(.largeTitle)
                .fontWeight(.bold)
            VStack {
                Picker("", selection: $feedbackStyle) {
                    ForEach(FeedbackStyle.allCases) { feedbackStyle in
                        Text(feedbackStyle.rawValue).tag(feedbackStyle)
                    }
                }
                .pickerStyle(.segmented)
                Toggle(isOn: $isMute) {
                    Text("Mute")
                }
            }
            .padding()
            HaebitApertureRing(
                selection: $selection,
                entries: $entries,
                feedbackStyle: Binding(get: { feedbackStyle.impactGeneraterFeedbackStyle }, set: { _ in }),
                isMute: $isMute
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
