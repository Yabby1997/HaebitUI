//
//  DefaultApertureRingFeedbackProvider.swift
//  HaebitUI
//
//  Created by Seunghun on 1/10/24.
//  Copyright © 2024 seunghun. All rights reserved.
//

import AVFoundation
import UIKit

/// Default implementation of ``HaebitApertureRingFeedbackProvidable``.
public class DefaultApertureRingFeedbackProvider: HaebitApertureRingFeedbackProvidable {
    private let feedbackGenerator = UIImpactFeedbackGenerator(style: .heavy)
    
    /// Creates a new instance of the ``DefaultApertureRingFeedbackProvider``.
    public init() {}

    public func generateClickingFeedback() {
        feedbackGenerator.prepare()
        feedbackGenerator.impactOccurred()
        AudioServicesPlaySystemSound(1157)
    }
}
