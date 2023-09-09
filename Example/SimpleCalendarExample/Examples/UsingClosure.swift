//
// Created by Paul Peelen
// Copyright © 2023 AppTrix AB. All rights reserved.
//

import SwiftUI
import SimpleCalendar

struct UsingClosure: View {
    private let dataModel = DataModel()

    @State private var selectedEvent: (any EventRepresentable)?

    var body: some View {
        NavigationStack {
            if let selectedEvent {
                Text("**\(selectedEvent.activity.title)**, \(selectedEvent.startDate.relativeDateDisplay())")
                    .padding()
                    .font(.caption)
                    .background(
                        RoundedRectangle(cornerRadius: 30, style: .continuous)
                            .fill(selectedEvent.activity.type.color.opacity(0.3))
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
                events: dataModel.getEvents(),
                selectionAction: .inform { event in
                    self.selectedEvent = event
                }
            )
            .navigationTitle("Using closure")
        }
    }
}

#Preview {
    UsingClosure()
}

private extension Date {
    func relativeDateDisplay() -> String {
        RelativeDateTimeFormatter().localizedString(for: self, relativeTo: Date())
    }
}
