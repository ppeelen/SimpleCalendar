//
// Created by Paul Peelen
// Copyright © 2023 AppTrix AB. All rights reserved.
//

import SwiftUI
import SimpleCalendar

struct UsingSheet: View {
    @Binding var events: [any CalendarEventRepresentable]
    @Binding var selectedDate: Date

    var body: some View {
        NavigationStack {
            SimpleCalendarView(
                events: $events,
                selectedDate: $selectedDate,
                selectionAction: .sheet
            )
            .navigationTitle("Using standard sheet")
        }
    }
}
