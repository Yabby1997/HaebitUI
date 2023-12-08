//
//  HaebitUIDemoApp.swift
//  HaebitUI
//
//  Created by Seunghun on 11/30/23.
//  Copyright © 2023 seunghun. All rights reserved.
//

import SwiftUI
import HaebitUI

@main
struct HaebitUIDemoApp: App {
    var body: some Scene {
        WindowGroup {
            ApertureRingDemoView()
                .environmentObject(
                    HaebitApertureRingDependencies(
                        feedbackProvidable: DefaultFeedbackProvidable()
                    )
                )
        }
    }
}
