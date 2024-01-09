//
//  DefaultShutterButtonFeedbackProvider.swift
//  HaebitUI
//
//  Created by Seunghun on 1/10/24.
//  Copyright © 2024 seunghun. All rights reserved.
//

import UIKit

public class DefaultShutterButtonFeedbackProvider: HaebitShutterButtonFeedbackProvidable {
    private let lightFeedbackGenerator = UIImpactFeedbackGenerator(style: .light)
    private let rigidFeedbackGenerator = UIImpactFeedbackGenerator(style: .rigid)
    private let heavyFeedbackGenerator = UIImpactFeedbackGenerator(style: .heavy)
    
    public init() {}

    public func generateClickingFeedback() {
        lightFeedbackGenerator.prepare()
        lightFeedbackGenerator.impactOccurred()
    }
    
    public func generateOpeningFeedback() {
        rigidFeedbackGenerator.prepare()
        rigidFeedbackGenerator.impactOccurred()
    }
    
    public func generateClosingFeedback() {
        heavyFeedbackGenerator.prepare()
        heavyFeedbackGenerator.impactOccurred()
        heavyFeedbackGenerator.impactOccurred()
    }
}
