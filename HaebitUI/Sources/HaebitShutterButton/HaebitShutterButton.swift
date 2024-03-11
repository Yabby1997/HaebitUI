//
//  HaebitShutterButton.swift
//  HaebitUI
//
//  Created by Seunghun on 1/9/24.
//  Copyright © 2024 seunghun. All rights reserved.
//

import SwiftUI

/// A shutter button styled button.
public struct HaebitShutterButton: View {
    @EnvironmentObject private var dependencies: HaebitShutterButtonDependencies
    @State private var isTaskRunning: Bool = false
    @Binding private var shutterSpeed: UInt64
    private let maximumShutterSpeed: UInt64
    private let shutterLag: UInt64
    private let action: () -> Void
    private let completion: (() -> Void)?
    
    public var body: some View {
        Button {
            Task {
                action()
                isTaskRunning = true
                dependencies.feedbackProvidable.generateClickingFeedback()
                try? await Task.sleep(nanoseconds: shutterLag)
                dependencies.feedbackProvidable.generateOpeningFeedback()
                try? await Task.sleep(nanoseconds: min(shutterSpeed, maximumShutterSpeed))
                dependencies.feedbackProvidable.generateClosingFeedback()
                isTaskRunning = false
                completion?()
            }
        } label: {
            Circle()
                .frame(width: 50, height: 50)
                .foregroundStyle(.red)
                .overlay(
                    Circle()
                        .fill(.shadow(.inner(color: .black.opacity(0.5), radius: 10, x: 7, y: 7)))
                        .frame(width: 44, height: 44)
                        .foregroundStyle(.red)
                )
        }
        .disabled(isTaskRunning)
    }
    
    /// Creates an shutter button.
    ///
    /// - Parameters:
    ///     - shutterSpeed: Shutter speed value to generate feedback in nano seconds.
    ///     - maximumShutterSpeed: Upper limit for `shutterSpeed` to generate feedback in nano seconds.
    ///     - shutterLag: A shutter lag value in nano seconds.
    ///     - action: A closure to handle the button's tap action.
    ///     - completion: A completion handler which called at the completion of shutter feedback.
    public init(
        shutterSpeed: Binding<UInt64>,
        maximumShutterSpeed: UInt64 = 1_000_000_000,
        shutterLag: UInt64 = 50_000_000,
        action: @escaping () -> Void,
        completion: (() -> Void)? = nil
    ) {
        self._shutterSpeed = shutterSpeed
        self.maximumShutterSpeed = maximumShutterSpeed
        self.shutterLag = shutterLag
        self.action = action
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
