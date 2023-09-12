//
// Created by Paul Peelen
// Copyright © 2023 AppTrix AB. All rights reserved.
//

import SwiftUI
import SimpleCalendar

struct UsingDestination: View {
    @Binding var events: [any CalendarEventRepresentable]
    @Binding var selectedDate: Date

    var body: some View {
        NavigationStack {
            SimpleCalendarView(
                events: $events,
                selectedDate: $selectedDate,
                selectionAction: .destination({ event in
                    CustomSheetContentView(event: event)
                })
            )
            .navigationTitle("Using custom sheet")
        }
    }
}

private struct CustomSheetContentView: View {
    let event: any CalendarEventRepresentable

    var body: some View {
        VStack {
            Text("Selected Event")
            Text(event.calendarActivity.title)
        }
    }
}
