//
// Created by Paul Peelen
// Copyright © 2023 AppTrix AB. All rights reserved.
//

import SwiftUI
import SimpleCalendar

struct CustomSettings: View {
    private let dataModel = DataModel()

    var body: some View {
        NavigationStack {
            SimpleCalendarView(
                events: dataModel.getEvents(),
                selectedDate: Date(timeIntervalSinceNow: (24 * 3600) * 10),
                selectionAction: .none,
                hourHeight: 50,
                hourSpacing: 48,
                startHourOfDay: 0
            )
            .navigationTitle("+10 days from now")
        }
    }
}

#Preview {
    CustomSettings()
}
