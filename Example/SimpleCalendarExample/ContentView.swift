//
// Created by Paul Peelen
// Copyright © 2023 AppTrix AB. All rights reserved.
//

import SwiftUI
import SimpleCalendar

struct ContentView: View {
    private let dataModel = DataModel()

    @State private var events: [any CalendarEventRepresentable] = []
    @State private var selectedDate = Date()

    var body: some View {
        NavigationStack {
            List {
                NavigationLink {
                    UsingSheet(events: $events, selectedDate: $selectedDate)
                } label: {
                    VStack(alignment: .leading) {
                        Text("Default sheet")
                            .font(.headline)
                        Text("Full page calendar view using the default SimpleCalendar sheet when selecting an event.")
                    }
                }
                NavigationLink {
                    UsingCustomSheet(events: $events, selectedDate: $selectedDate)
                } label: {
                    VStack(alignment: .leading) {
                        Text("Using custom sheet")
                            .font(.headline)
                        Text("Full page calendar view using a custom view as sheet when selecting an event.")
                    }
                }
                NavigationLink {
                    UsingDestination(events: $events, selectedDate: $selectedDate)
                } label: {
                    VStack(alignment: .leading) {
                        Text("Using destination")
                            .font(.headline)
                        Text("Full page calendar view which \"pushes\" to a custom view when selecting an event.")
                    }
                }
                NavigationLink {
                    UsingClosure(events: $events, selectedDate: $selectedDate)
                } label: {
                    VStack(alignment: .leading) {
                        Text("Using closure")
                            .font(.headline)
                        Text("Full page calendar view using `.inform` closure when selecting an event.")
                    }
                }
                NavigationLink {
                    CustomSettings(events: $events, selectedDate: $selectedDate)
                } label: {
                    VStack(alignment: .leading) {
                        Text("Custom settings")
                            .font(.headline)
                        Text("Selects a specific date as initial date, uses increased hour spacing and height and starts at the beginning of the day.")
                    }
                }
                NavigationLink {
                    SelectiveDates(events: $events, selectedDate: $selectedDate)
                } label: {
                    VStack(alignment: .leading) {
                        Text("Selective dates")
                            .font(.headline)
                        Text("Allows the user to select a specific date.")
                    }
                }
            }
            .navigationTitle("Simple Calendar")
        }
        .onAppear {
            self.events = dataModel.getEvents()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
