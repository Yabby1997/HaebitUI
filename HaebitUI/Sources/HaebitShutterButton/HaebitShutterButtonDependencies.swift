//
//  HaebitShutterButtonDependencies.swift
//  HaebitUI
//
//  Created by Seunghun on 1/9/24.
//  Copyright © 2024 seunghun. All rights reserved.
//

import Foundation

/// Dependencies for ``HaebitShutterButton``.
public final class HaebitShutterButtonDependencies: ObservableObject {
    /// A ``HaebitShutterButtonFeedbackProvidable`` instance for shutter button dependency.
    let feedbackProvidable: HaebitShutterButtonFeedbackProvidable
    
    /// Creates a new instance of `HaebitShutterButtonDependencies`.
    ///
    /// - Parameters:
    ///     - feedbackProvidable: An instance of implementation of ``HaebitShutterButtonFeedbackProvidable``.
    public init(feedbackProvidable: HaebitShutterButtonFeedbackProvidable) {
        self.feedbackProvidable = feedbackProvidable
    }
}
