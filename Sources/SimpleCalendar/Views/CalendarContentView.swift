//
// Created by Paul Peelen
// Copyright © 2023 AppTrix AB. All rights reserved.
//

import SwiftUI

public struct CalendarContentView: View {
    @Binding var events: [any EventRepresentable]
    let selectionAction: SelectionAction

    private let leadingPadding = 70.0
    private let boxSpacing = 5.0

    public var body: some View {
        GeometryReader { geo in
            let width = (geo.size.width - leadingPadding)

            ForEach(events, id:\.id) { event in
                let boxWidth = (width / Double(event.columnCount + 1)) - boxSpacing
                EventView(event: event, selectionAction: selectionAction)
                    .offset(CGSize(width: boxWidth * Double(event.column) + (boxSpacing * Double(event.column)), height: (event.coordinates?.minY ?? 0)))
                    .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 5)
                    .frame(width: boxWidth, height: event.coordinates?.height ?? 20)
            }
            .padding(.top, 12)
            .padding(.leading, leadingPadding)
        }
    }
}

struct CalendarContentView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarContentView(
            events: .constant([]),
            selectionAction: .none
        )
    }
}
