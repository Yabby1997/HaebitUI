//
//  HaebitApertureRingDependencies.swift
//  HaebitUI
//
//  Created by Seunghun on 12/2/23.
//  Copyright © 2023 seunghun. All rights reserved.
//

import Foundation

/// Dependencies for ``HaebitApertureRing``.
public final class HaebitApertureRingDependencies: ObservableObject {
    /// A ``HaebitApertureRingFeedbackProvidable`` instance for aperture ring dependency.
    let feedbackProvidable: HaebitApertureRingFeedbackProvidable
    
    /// Creates a new instance of `HaebitApertureRingDependencies`.
    ///
    /// - Parameters:
    ///     - feedbackProvidable: An instance of implementation of ``HaebitApertureRingFeedbackProvidable``.
    public init(feedbackProvidable: HaebitApertureRingFeedbackProvidable) {
        self.feedbackProvidable = feedbackProvidable
    }
}
