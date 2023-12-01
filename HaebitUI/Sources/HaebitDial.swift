//
//  HaebitDial.swift
//  HaebitUI
//
//  Created by Seunghun on 12/2/23.
//  Copyright © 2023 seunghun. All rights reserved.
//

import SwiftUI

public struct HaebitDial<CenterLabel, ContentLabel, SelectionValue>: View where CenterLabel: View, ContentLabel: View, SelectionValue: Hashable {
    var data: [SelectionValue]
    @Binding var selection: SelectionValue
    var centerLabel: () -> CenterLabel
    var contentLabel: (SelectionValue) -> ContentLabel
    
    public init(
        data: [SelectionValue],
        selection: Binding<SelectionValue>,
        centerLabel: @escaping () -> CenterLabel,
        contentLabel: @escaping (SelectionValue) -> ContentLabel
    ) {
        self._selection = selection
        self.data = data
        self.centerLabel = centerLabel
        self.contentLabel = contentLabel
    }
    
    public var body: some View {
        VStack(spacing: .zero) {
            centerLabel()
                .frame(width: 5, height: 5)
            ZStack {
                EmptyView()
                DialViewRepresentable(data: data, selection: $selection, content: contentLabel)
                    .frame(maxHeight: 30)
            }
        }
    }
}

#Preview {
    HaebitDial(
        data: ["사과", "딸기", "포도", "망고", "키위", "참외", "수박", "메론", "감귤"],
        selection: .constant("복숭아")
    ){
        Color(.green)
    } contentLabel: { data in
        Text(data)
    }
}
