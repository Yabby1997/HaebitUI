//
//  HaebitDial.swift
//  HaebitUI
//
//  Created by Seunghun on 12/2/23.
//  Copyright © 2023 seunghun. All rights reserved.
//

import SwiftUI

/// An aperture ring styled value picker.
public struct HaebitApertureRing<Indicator, Content, Entry>: View where Indicator: View, Content: View, Entry: Hashable {
    @Binding private var selection: Entry
    private let entries: [Entry]
    private let centerIndicator: () -> Indicator
    private let content: (Entry) -> Content
    @EnvironmentObject private var dependencies: HaebitApertureRingDependencies
    
    /// Creates an aperture ring that displays center indicator and each entry's content.
    ///
    /// - Note: Provide ``HaebitApertureRingDependencies`` as using ``environmentObject(_:)``.
    ///
    /// - Parameters:
    ///     - selection: The value that determines the currently selected entry.
    ///     - entries: An array of values used as the entries for aperture ring.
    ///     - centerIndicator: A view that indicates the center point of aperture ring.
    ///     - content: A view that describes each entry of aperture ring.
    public init(
        selection: Binding<Entry>,
        entries: [Entry],
        @ViewBuilder centerIndicator: @escaping () -> Indicator = { EmptyView() },
        @ViewBuilder content: @escaping (Entry) -> Content
    ) {
        self._selection = selection
        self.entries = entries
        self.centerIndicator = centerIndicator
        self.content = content
    }
    
    public var body: some View {
        VStack(spacing: .zero) {
            centerIndicator()
            ZStack {
                EmptyView()
                ApertureRing(
                    selection: $selection,
                    entries: entries,
                    feedbackProvidable: dependencies.feedbackProvidable,
                    content: content
                )
                .frame(maxHeight: 30)
            }
        }
    }
}

extension HaebitApertureRing: Equatable {
    public static func == (
        lhs: HaebitApertureRing<Indicator, Content, Entry>,
        rhs: HaebitApertureRing<Indicator, Content, Entry>
    ) -> Bool {
        lhs.entries == rhs.entries && lhs.selection == rhs.selection
    }
}

#Preview {
    HaebitApertureRing(
        selection: .constant("복숭아"),
        entries: ["사과", "딸기", "포도", "망고", "키위", "참외", "수박", "메론", "감귤"]
    ){
        Color(.green)
            .frame(width: 5, height: 5)
    } content: { data in
        Text(data)
    }
    .environmentObject(
        HaebitApertureRingDependencies(
            feedbackProvidable: DefaultApertureRingFeedbackProvider()
        )
    )
}
