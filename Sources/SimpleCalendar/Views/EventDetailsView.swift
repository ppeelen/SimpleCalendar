
//
// Created by Paul Peelen
// Copyright © 2023 AppTrix AB. All rights reserved.
//

import SwiftUI

struct EventDetailsView: View {
    let event: any CalendarEventRepresentable

    var body: some View {
        VStack(alignment: .leading) {
            ZStack {
                VStack(alignment: .leading, spacing: 0) {
                    Text(event.activity.activityType.name)
                        .font(.caption)
                        .foregroundColor(event.activity.activityType.color)
                        .fontWeight(.light)
                    HStack {
                        Circle()
                            .fill(event.activity.activityType.color)
                            .frame(width: 7)
                        Text(event.activity.title)
                            .font(.title)
                    }
                    .padding(.bottom, 8)
                    HStack {
                        Text(event.startDate.formatted())
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Spacer()
                        Text(event.startDate.relativeDateDisplay())
                            .font(.caption)
                    }
                    Text(event.activity.description)
                        .padding(.vertical, 20)
                        .font(.body)
                        .fontWeight(.light)
                        .dynamicTypeSize(DynamicTypeSize.small ... DynamicTypeSize.large)
                    if !event.activity.mentors.isEmpty {
                        Text("Mentors")
                            .font(.footnote)
                            .foregroundColor(.secondary)
                        ForEach(event.activity.mentors, id: \.self) { mentor in
                            Text(mentor)
                        }
                    }
                    Spacer()
                }
            }
        }
        .padding()
    }
}

struct EventDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            EventDetailsView(event: CalendarEvent.forPreview())
                .previewDisplayName("Light")
                .preferredColorScheme(.light)
            EventDetailsView(event: CalendarEvent.forPreview())
                .previewDisplayName("Dark")
                .preferredColorScheme(.dark)
        }
    }
}


//#Preview {
//    SwiftUIView()
//}
