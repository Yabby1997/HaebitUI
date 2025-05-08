//
//  HaebitDial.swift
//  HaebitUI
//
//  Created by Seunghun on 12/2/23.
//  Copyright © 2023 seunghun. All rights reserved.
//

import SwiftUI

/// An aperture ring styled value picker.
public struct HaebitApertureRing<Content, Entry>: View where Content: View, Entry: Hashable {
    @Binding private var selection: Entry
    @Binding private var entries: [Entry]
    private let cellWidth: CGFloat
    @Binding private var feedbackStyle: UIImpactFeedbackGenerator.FeedbackStyle
    @Binding private var isMute: Bool
    private let content: (Entry) -> Content
    
    /// Creates an aperture ring that displays a center indicator and each entry's content.
    ///
    /// - Parameters:
    ///     - selection: The value that determines the currently selected entry.
    ///     - entries: An array of values used as the entries for the aperture ring.
    ///     - feedbackStyle: A `UIImpactFeedbackGenerator.FeedbackStyle` that indicates which style to use for generating impact feedback.
    ///     - isMute: A `Bool` value that indicates whether or not to play sound feedback.
    ///     - content: A view that describes each entry of the aperture ring.
    public init(
        selection: Binding<Entry>,
        entries: Binding<[Entry]>,
        cellWidth: CGFloat = 60,
        feedbackStyle: Binding<UIImpactFeedbackGenerator.FeedbackStyle>,
        isMute: Binding<Bool>,
        @ViewBuilder content: @escaping (Entry) -> Content
    ) {
        self._selection = selection
        self._entries = entries
        self.cellWidth = cellWidth
        self._feedbackStyle = feedbackStyle
        self._isMute = isMute
        self.content = content
    }
    
    public var body: some View {
        ApertureRing(
            selection: $selection,
            entries: $entries,
            cellWidth: cellWidth,
            feedbackStyle: $feedbackStyle,
            isMute: $isMute,
            content: content
        )
    }
}

extension HaebitApertureRing: @preconcurrency Equatable {
    public static func == (
        lhs: HaebitApertureRing<Content, Entry>,
        rhs: HaebitApertureRing<Content, Entry>
    ) -> Bool {
        lhs.entries == rhs.entries && lhs.selection == rhs.selection
    }
}

#Preview {
    @State var selection = "복숭아"
    @State var entries = ["사과", "딸기", "포도", "망고", "키위", "복숭아", "참외", "수박", "메론", "감귤"]
    return HaebitApertureRing(
        selection: $selection,
        entries: $entries,
        feedbackStyle: .constant(.heavy),
        isMute: .constant(false)
    ) { data in
        Text(data)
    }
}
