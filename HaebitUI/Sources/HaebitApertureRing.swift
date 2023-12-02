//
//  HaebitDial.swift
//  HaebitUI
//
//  Created by Seunghun on 12/2/23.
//  Copyright © 2023 seunghun. All rights reserved.
//

import SwiftUI

public struct HaebitApertureRing<Indicator, Content, Entry>: View where Indicator: View, Content: View, Entry: Hashable {
    @Binding var selection: Entry
    let entries: [Entry]
    let centerIndicator: () -> Indicator
    let content: (Entry) -> Content
    @EnvironmentObject var dependencies: HaebitApertureRingDependencies
    
    public init(
        selection: Binding<Entry>,
        entries: [Entry],
        centerIndicator: @escaping () -> Indicator,
        content: @escaping (Entry) -> Content
    ) {
        self._selection = selection
        self.entries = entries
        self.centerIndicator = centerIndicator
        self.content = content
    }
    
    public var body: some View {
        VStack(spacing: .zero) {
            centerIndicator()
                .frame(width: 5, height: 5)
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

#Preview {
    HaebitApertureRing(
        selection: .constant("복숭아"),
        entries: ["사과", "딸기", "포도", "망고", "키위", "참외", "수박", "메론", "감귤"]
    ){
        Color(.green)
    } content: { data in
        Text(data)
    }
    .environmentObject(
        HaebitApertureRingDependencies(
            feedbackProvidable: DefaultFeedbackProvidable()
        )
    )
}
