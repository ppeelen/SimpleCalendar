//
// Created by Paul Peelen
// Copyright © 2023 AppTrix AB. All rights reserved.
//

import SwiftUI
import SimpleCalendar

struct ContentView: View {
    private let dataModel = DataModel()

    var body: some View {
        NavigationStack {
            List {
                NavigationLink {
                    UsingSheet()
                } label: {
                    VStack(alignment: .leading) {
                        Text("Default sheet")
                            .font(.headline)
                        Text("Full page calendar view using the default SimpleCalendar sheet when selecting an event.")
                    }
                }
                NavigationLink {
                    UsingCustomSheet()
                } label: {
                    VStack(alignment: .leading) {
                        Text("Using custom sheet")
                            .font(.headline)
                        Text("Full page calendar view using a custom view as sheet when selecting an event.")
                    }
                }
                NavigationLink {
                    UsingDestination()
                } label: {
                    VStack(alignment: .leading) {
                        Text("Using destination")
                            .font(.headline)
                        Text("Full page calendar view which \"pushes\" to a custom view when selecting an event.")
                    }
                }
                NavigationLink {
                    UsingClosure()
                } label: {
                    VStack(alignment: .leading) {
                        Text("Using closure")
                            .font(.headline)
                        Text("Full page calendar view using `.inform` closure when selecting an event.")
                    }
                }
                NavigationLink {
                    CustomSettings()
                } label: {
                    VStack(alignment: .leading) {
                        Text("Custom settings")
                            .font(.headline)
                        Text("Selects a specific date as initial date, uses increased hour spacing and height and starts at the beginning of the day.")
                    }
                }
            }
            .navigationTitle("Simple Calendar")
        }
    }
}

#Preview {
    ContentView()
}
