//
//  HaebitShutterButton.swift
//  HaebitUI
//
//  Created by Seunghun on 1/9/24.
//  Copyright © 2024 seunghun. All rights reserved.
//

import SwiftUI

public struct HaebitShutterButton: View {
    @EnvironmentObject private var dependencies: HaebitShutterButtonDependencies
    @State private var isTaskRunning: Bool = false
    @Binding private var shutterSpeed: UInt64
    private let maximumShutterSpeed: UInt64
    private let shutterLag: UInt64
    private let completion: () -> Void
    
    public var body: some View {
        Button {
            Task {
                isTaskRunning = true
                dependencies.feedbackProvidable.generateClickingFeedback()
                try? await Task.sleep(nanoseconds: shutterLag)
                dependencies.feedbackProvidable.generateOpeningFeedback()
                try? await Task.sleep(nanoseconds: min(shutterSpeed, maximumShutterSpeed))
                dependencies.feedbackProvidable.generateClosingFeedback()
                completion()
                isTaskRunning = false
            }
        } label: {
            Circle()
                .frame(width: 50, height: 50)
                .foregroundStyle(.red)
        }
        .disabled(isTaskRunning)
    }
    
    public init(
        shutterSpeed: Binding<UInt64>,
        maximumShutterSpeed: UInt64 = 1_000_000_000,
        shutterLag: UInt64 = 50_000_000,
        completion: @escaping () -> Void
    ) {
        self._shutterSpeed = shutterSpeed
        self.maximumShutterSpeed = maximumShutterSpeed
        self.shutterLag = shutterLag
        self.completion = completion
    }
}

#Preview {
    HaebitShutterButton(shutterSpeed: .constant(1_000_000_000)) {
        print("!!")
    }
    .environmentObject(
        HaebitShutterButtonDependencies(
            feedbackProvidable: DefaultShutterButtonFeedbackProvider()
        )
    )
}
