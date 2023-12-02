//
//  ApertureRingFeedbackProvidable.swift
//  HaebitUI
//
//  Created by Seunghun on 12/2/23.
//  Copyright © 2023 seunghun. All rights reserved.
//

import UIKit
import AVFoundation

public protocol HaebitApertureRingFeedbackProvidable {
    func generateClickingFeedback()
}

public class DefaultFeedbackProvidable: HaebitApertureRingFeedbackProvidable {
    private let feedbackGenerator = UIImpactFeedbackGenerator(style: .heavy)
    
    public init() {}

    public func generateClickingFeedback() {
        feedbackGenerator.prepare()
        feedbackGenerator.impactOccurred()
        AudioServicesPlaySystemSound(1157)
    }
}
