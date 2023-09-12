//
// Created by Paul Peelen
// Copyright © 2023 AppTrix AB. All rights reserved.
//

import SwiftUI
import SimpleCalendar

struct UsingClosure: View {
    @Binding var events: [any CalendarEventRepresentable]
    @Binding var selectedDate: Date

    @State private var selectedEvent: (any CalendarEventRepresentable)?

    var body: some View {
        NavigationStack {
            if let selectedEvent {
                Text("**\(selectedEvent.calendarActivity.title)**, \(selectedEvent.startDate.relativeDateDisplay())")
                    .padding()
                    .font(.caption)
                    .background(
                        RoundedRectangle(cornerRadius: 30, style: .continuous)
                            .fill(selectedEvent.calendarActivity.activityType.color.opacity(0.3))
                    )
            } else {
                Text("No event selected")
                    .padding()
                    .font(.caption)
                    .background(
                        RoundedRectangle(cornerRadius: 30, style: .continuous)
                            .fill(.gray.opacity(0.3))
                    )
            }

            SimpleCalendarView(
                events: $events,
                selectedDate: $selectedDate,
                selectionAction: .inform { event in
                    self.selectedEvent = event
                }
            )
            .navigationTitle("Using closure")
        }
    }
}

private extension Date {
    func relativeDateDisplay() -> String {
        RelativeDateTimeFormatter().localizedString(for: self, relativeTo: Date())
    }
}
