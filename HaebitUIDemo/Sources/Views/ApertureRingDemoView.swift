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
    @StateObject var viewModel = ViewModel()
    
    var body: some View {
        VStack {
            Spacer()
            Text(String(format: "%.1f", viewModel.selection))
                .font(.largeTitle)
                .fontWeight(.bold)
            VStack {
                Picker("", selection: $viewModel.color) {
                    ForEach([Color.red, Color.green, Color.blue], id: \.self) { color in
                        Text("\(color.description)")
                    }
                }
                .pickerStyle(.segmented)
                Picker("", selection: $viewModel.feedbackStyle) {
                    ForEach(FeedbackStyle.allCases) { feedbackStyle in
                        Text(feedbackStyle.rawValue).tag(feedbackStyle)
                    }
                }
                .pickerStyle(.segmented)
                Toggle(isOn: $viewModel.isMute) {
                    Text("Mute")
                }
            }
            .padding()
            VStack {
                Circle()
                    .frame(width: 5, height: 5)
                    .foregroundStyle(.red)
                HaebitApertureRing(
                    selection: $viewModel.selection,
                    entries: $viewModel.entries,
                    feedbackStyle: Binding(get: { viewModel.feedbackStyle.impactGeneraterFeedbackStyle }, set: { _ in }),
                    isMute: $viewModel.isMute
                ) { data in
                    RingView(viewModel: viewModel, data: data)
                }
                .frame(height: 30)
                .shadow(radius: 5)
            }
            Spacer()
        }
    }
}

protocol RingViewModel: ObservableObject {
    var color: Color { get set }
}

class ViewModel: ObservableObject {
    @Published var selection: Float = 22
    @Published var entries: [Float] = [1.0, 1.4, 2.0, 2.8, 4.0, 5.6, 8.0, 11, 16, 22]
    @Published var feedbackStyle: FeedbackStyle = .heavy
    @Published var isMute: Bool = false
    @Published var color: Color = .white
}

extension ViewModel: RingViewModel {}

struct RingView<ViewModel: RingViewModel>: View {
    @StateObject var viewModel: ViewModel
    let data: Float
    
    var body: some View {
        Text(String(format: "%.1f", data))
            .fontWeight(.bold)
            .foregroundStyle(viewModel.color)
            .animation(.easeInOut, value: viewModel.color)
    }
}
