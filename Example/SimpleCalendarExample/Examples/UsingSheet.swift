//
// Created by Paul Peelen
// Copyright © 2023 AppTrix AB. All rights reserved.
//

import SwiftUI
import SimpleCalendar

struct UsingSheet: View {
    private let dataModel = DataModel()
    
    var body: some View {
        NavigationStack {
            SimpleCalendarView(
                events: dataModel.getEvents(),
                selectionAction: .sheet
            )
            .navigationTitle("Using standard sheet")
        }
    }
}

#Preview {
    UsingSheet()
}
