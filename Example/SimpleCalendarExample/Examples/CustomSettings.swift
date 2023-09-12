//
// Created by Paul Peelen
// Copyright © 2023 AppTrix AB. All rights reserved.
//

import SwiftUI
import SimpleCalendar

struct CustomSettings: View {
    @Binding var events: [any CalendarEventRepresentable]
    @Binding var selectedDate: Date

    var body: some View {
        NavigationStack {
            SimpleCalendarView(
                events: $events,
                selectedDate: $selectedDate,
                selectionAction: .none,
                hourHeight: 50,
                hourSpacing: 48,
                startHourOfDay: 0
            )
            .navigationTitle("+10 days from now")
        }
        .onAppear {
            selectedDate = Date(timeIntervalSinceNow: (24 * 3600) * 10)
        }
    }
}
