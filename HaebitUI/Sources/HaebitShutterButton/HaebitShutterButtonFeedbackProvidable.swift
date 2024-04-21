//
//  HaebitShutterButtonFeedbackProvidable.swift
//  HaebitUI
//
//  Created by Seunghun on 1/9/24.
//  Copyright © 2024 seunghun. All rights reserved.
//

import Foundation

/// A protocol that enables providing feedback for ``HaebitShutterButton``.
@MainActor
public protocol HaebitShutterButtonFeedbackProvidable {
    /// A method that is invoked when clicking feedback is needed.
    func generateClickingFeedback()
    /// A method that is invoked when opening shutter feedback is needed.
    func generateOpeningFeedback()
    /// A method that is invoked when closing shutter feedback is needed.
    func generateClosingFeedback()
}
