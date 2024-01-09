//
//  HaebitShutterButtonFeedbackProvidable.swift
//  HaebitUI
//
//  Created by Seunghun on 1/9/24.
//  Copyright © 2024 seunghun. All rights reserved.
//

import Foundation

public protocol HaebitShutterButtonFeedbackProvidable {
    func generateClickingFeedback()
    func generateOpeningFeedback()
    func generateClosingFeedback()
}
