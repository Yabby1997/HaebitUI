//
//  ApertureRingFeedbackProvidable.swift
//  HaebitUI
//
//  Created by Seunghun on 12/2/23.
//  Copyright © 2023 seunghun. All rights reserved.
//

import Foundation

/// A protocol that enables providing feedback for ``HaebitApertureRing``.
public protocol HaebitApertureRingFeedbackProvidable {
    /// A method that is invoked when clicking feedback is needed.
    func generateClickingFeedback()
}
