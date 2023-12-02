//
//  HaebitApertureRingDependencies.swift
//  HaebitUI
//
//  Created by Seunghun on 12/2/23.
//  Copyright © 2023 seunghun. All rights reserved.
//

import Foundation

public final class HaebitApertureRingDependencies: ObservableObject {
    let feedbackProvidable: HaebitApertureRingFeedbackProvidable
    
    public init(feedbackProvidable: HaebitApertureRingFeedbackProvidable) {
        self.feedbackProvidable = feedbackProvidable
    }
}
