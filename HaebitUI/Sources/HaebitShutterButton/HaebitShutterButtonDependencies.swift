//
//  HaebitShutterButtonDependencies.swift
//  HaebitUI
//
//  Created by Seunghun on 1/9/24.
//  Copyright © 2024 seunghun. All rights reserved.
//

import Foundation

public final class HaebitShutterButtonDependencies: ObservableObject {
    let feedbackProvidable: HaebitShutterButtonFeedbackProvidable
    
    public init(feedbackProvidable: HaebitShutterButtonFeedbackProvidable) {
        self.feedbackProvidable = feedbackProvidable
    }
}
