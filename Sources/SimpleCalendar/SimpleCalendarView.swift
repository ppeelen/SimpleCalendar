//
// Created by Paul Peelen
// Copyright © 2023 AppTrix AB. All rights reserved.
//

import SwiftUI

public enum SelectionAction {
    case sheet
    case customSheet((any EventRepresentable) -> any View)
    case destination((any EventRepresentable) -> any View)
    case inform((any EventRepresentable) -> Void)
    case none
}

public struct SimpleCalendarView: View {
    let events: [any EventRepresentable]

    @State private var visibleEvents: [any EventRepresentable]
    @State private var selectedDate: Date
    @State private var hourHeight: Double
    @State private var hourSpacing: Double
    private let startHourOfDay: Int
    private let selectionAction: SelectionAction

    public init(
        events: [any EventRepresentable],
        selectedDate: Date = Date(),
        selectionAction: SelectionAction = .sheet,
        hourHeight: Double = 25.0,
        hourSpacing: Double = 24.0,
        startHourOfDay: Int = 6
    ) {
        self.events = events
        _visibleEvents = State(initialValue: events)
        _selectedDate = State(initialValue: selectedDate)
        _hourHeight = State(initialValue: hourHeight)
        _hourSpacing = State(initialValue: hourSpacing)

        self.startHourOfDay = startHourOfDay
        self.selectionAction = selectionAction
    }

    private var hours: [String] {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Locale.is24Hour ? "HH:mm" : "h a"

        var hours: [String] = []

        for hour in startHourOfDay...24 {
            if let date = Date().atHour(hour) {
                hours.append(dateFormatter.string(from: date))
            }
        }

        return hours
    }
    private let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.setLocalizedDateFormatFromTemplate("MMMdd")
        return dateFormatter
    }()

    public var body: some View {
        ScrollView {
            ZStack {
                CalendarPageView(
                    hours: hours,
                    hourSpacing: $hourSpacing,
                    hourHeight: $hourHeight
                )

                let calendar = Calendar.current
                if calendar.isDateInToday(selectedDate) {
                    CalendarTimelineView(
                        startHourOfDay: startHourOfDay,
                        hourSpacing: $hourSpacing,
                        hourHeight: $hourHeight
                    )
                }

                CalendarContentView(
                    events: $visibleEvents,
                    selectionAction: selectionAction
                )
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    DatePicker("", selection: $selectedDate, displayedComponents: [.date])
                        .labelsHidden()
                }
            }
        }
        .onChange(of: selectedDate) { _ in
            updateContent()
        }
        .onAppear {
            updateContent()
        }
    }

    private func updateContent() {
        let calendar = Calendar.current
        let selectedEvents = events.filter {
            calendar.isDate($0.startDate, inSameDayAs: selectedDate)
            || calendar.isDate($0.startDate.addingTimeInterval($0.activity.duration), inSameDayAs: selectedDate)
        }

        calculateCoordinates(forEvents: selectedEvents)
    }

    private func calculateCoordinates(forEvents events: [any EventRepresentable]) {
        var eventList: [any EventRepresentable] = []

        var pos: [EventPositions] = []

        let actualHourHeight = hourHeight + hourSpacing
        let heightPerSecond = (actualHourHeight / 60) / 60

        // Go over each event and check if there is another event ongoing at the same time
        events.forEach { event in
            let activity = event.activity
            var event = event

            let secondsSinceStartOfDay = abs(selectedDate.atHour(startHourOfDay)?.timeIntervalSince(event.startDate) ?? 0)

            let frame = CGRect(x: 0, y: secondsSinceStartOfDay * heightPerSecond, width: 60, height: activity.duration * heightPerSecond)
            event.coordinates = frame

            let positionedEvents = pos.filter {
                ($0.position.minY >= frame.origin.y && $0.position.minY < frame.maxY) ||
                ($0.position.maxY > frame.origin.y && $0.position.maxY <= frame.maxY)
            }

            event.column = positionedEvents.count
            event.columnCount = positionedEvents.count

            let returnList = eventList.map {
                var event = $0
                if positionedEvents.contains(where: { $0.id == event.id }) {
                    event.columnCount += 1
                }
                return event
            }
            eventList = returnList
            eventList.append(event)

            pos.append(EventPositions(id: event.id, sharePositionWith: positionedEvents.map { $0.id }, position: frame))
        }

        self.visibleEvents = eventList
    }

    private func calculateOffset(event: Event) -> Double {
        guard let startHour = event.startDate.hour, let dateHour = Date().atHour(startHour) else { return 0 }

        let actualHourHeight = hourHeight + hourSpacing
        let heightPerSecond = (actualHourHeight / 60) / 60
        let secondsSinceStartOfDay = abs(Date().atHour(0)?.timeIntervalSince(dateHour) ?? 0)
        return secondsSinceStartOfDay * heightPerSecond
    }
}

struct ScheduleView_Previews: PreviewProvider {
    static var previews: some View {
        // swiftlint:disable force_unwrapping
        let dateEvent1 = Calendar.current.date(bySettingHour: 9, minute: 0, second: 0, of: Date())!
        let dateEvent2 = Calendar.current.date(bySettingHour: 10, minute: 0, second: 0, of: Date())!
        let dateEvent3 = Calendar.current.date(bySettingHour: 7, minute: 15, second: 0, of: Date())!
        let dateEvent4 = Calendar.current.date(bySettingHour: 7, minute: 30, second: 0, of: Date())!
        let dateEvent5 = Calendar.current.date(bySettingHour: 8, minute: 0, second: 0, of: Date())!
        let dateEvent6 = Calendar.current.date(bySettingHour: 8, minute: 0, second: 0, of: Date())!
        let dateEvent7 = Calendar.current.date(bySettingHour: 8, minute: 0, second: 0, of: Date(timeIntervalSinceNow: 24 * (60 * 60)))!
        // swiftlint:enable force_unwrapping
        
        let events = [
            Event.forPreview(
                id: "1",
                startDate: dateEvent1,
                activity: Activity.forPreview(
                    id: UUID(),
                    type: ActivityType.forPreview(color: .yellow)
                )
            ),
            Event.forPreview(
                id: "2",
                startDate: dateEvent2,
                activity: Activity.forPreview(
                    id: UUID(),
                    type: ActivityType.forPreview(color: .blue), 
                    duration: 6 * (60 * 60)
                )
            ),
            Event.forPreview(
                id: "3",
                startDate: dateEvent3,
                activity: Activity.forPreview(
                    id: UUID(),
                    type: ActivityType.forPreview(color: .gray)
                )
            ),
            Event.forPreview(
                id: "4",
                startDate: dateEvent4,
                activity: Activity.forPreview(
                    id: UUID(),
                    type: ActivityType.forPreview(color: .red), 
                    duration: 45 * 60)
            ),
            Event.forPreview(
                id: "5",
                startDate: dateEvent5,
                activity: Activity.forPreview(
                    id: UUID(),
                    type: ActivityType.forPreview(color: .yellow)
                )
            ),
            Event.forPreview(
                id: "6",
                startDate: dateEvent6,
                activity: Activity.forPreview(
                    id: UUID(),
                    type: ActivityType.forPreview(color: .purple)
                )
            ),
            Event.forPreview(
                id: "7",
                startDate: dateEvent7,
                activity: Activity.forPreview(
                    id: UUID(),
                    type: ActivityType.forPreview(color: .red)
                )
            )
        ]

        return Group {
            NavigationStack {
                SimpleCalendarView(events: events, selectionAction: .none)
            }
            .previewDisplayName("Light")
            .preferredColorScheme(.light)

            NavigationStack {
                SimpleCalendarView(events: events, selectionAction: .none)
            }
            .previewDisplayName("Dark")
            .preferredColorScheme(.dark)
        }
    }
}

private extension Locale {
    static var is24Hour: Bool {
        guard let dateFormat = DateFormatter.dateFormat(fromTemplate: "j", options: 0, locale: Locale.current) else { return false }
        return dateFormat.firstIndex(of: "a") != nil
    }
}

private struct EventPositions {
    var id: String
    var sharePositionWith: [String] = []
    var position: CGRect
}
