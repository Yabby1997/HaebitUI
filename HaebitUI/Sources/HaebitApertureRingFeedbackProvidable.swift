//
//  ApertureRingFeedbackProvidable.swift
//  HaebitUI
//
//  Created by Seunghun on 12/2/23.
//  Copyright © 2023 seunghun. All rights reserved.
//

import UIKit
import AVFoundation

/// A protocol that enables providing feedback for ``HaebitApertureRing``.
public protocol HaebitApertureRingFeedbackProvidable {
    /// A method that is invoked when clicking feedback is needed.
    func generateClickingFeedback()
}

/// Default implementation of ``HaebitApertureRingFeedbackProvidable``.
public class DefaultFeedbackProvidable: HaebitApertureRingFeedbackProvidable {
    private let feedbackGenerator = UIImpactFeedbackGenerator(style: .heavy)
    
    /// Creates a new instance of the `DefaultFeedbackProvidable`.
    public init() {}

    public func generateClickingFeedback() {
        feedbackGenerator.prepare()
        feedbackGenerator.impactOccurred()
        AudioServicesPlaySystemSound(1157)
    }
}
