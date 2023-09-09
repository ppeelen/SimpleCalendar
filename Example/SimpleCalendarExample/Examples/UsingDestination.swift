//
// Created by Paul Peelen
// Copyright © 2023 AppTrix AB. All rights reserved.
//

import SwiftUI
import SimpleCalendar

struct UsingDestination: View {
    private let dataModel = DataModel()

    var body: some View {
        NavigationStack {
            SimpleCalendarView(
                events: dataModel.getEvents(),
                selectionAction: .destination({ event in
                    CustomSheetContentView(event: event)
                })
            )
            .navigationTitle("Using custom sheet")
        }
    }
}

#Preview {
    UsingCustomSheet()
}

private struct CustomSheetContentView: View {
    let event: any EventRepresentable

    var body: some View {
        VStack {
            Text("Selected Event")
            Text(event.activity.title)
        }
    }
}
