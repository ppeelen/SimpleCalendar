//
// Created by Paul Peelen
// Copyright © 2023 AppTrix AB. All rights reserved.
//

import SwiftUI

/// Defines the type of action preformed on an event selection
public enum SelectionAction {
    /// Shows the Activity Sheet for Simple Calendar
    ///
    /// Example of implementation
    /// ```swift
    /// SimpleCalendarView(
    ///     events: eventList,
    ///     selectionAction: .sheet
    /// )
    /// ```
    case sheet
    
    /// Shows a custom `View` as a sheet
    ///
    /// Example of implementation
    /// ```swift
    /// SimpleCalendarView(
    ///     events: eventList,
    ///     selectionAction: .customSheet({ event in
    ///           Text("An event was selected with id: \(event.id)")
    ///     })
    /// )
    /// ```
    case customSheet((any EventRepresentable) -> any View)

    /// Shows a destination view using `NavigationLink`
    ///
    /// Example of implementation
    /// ```swift
    /// SimpleCalendarView(
    ///     events: eventList,
    ///     selectionAction: .destination({ event in
    ///           Text("An event was selected with id: \(event.id)")
    ///     })
    /// )
    /// ```
    case destination((any EventRepresentable) -> any View)

    /// Uses a closure to inform about the selection,
    ///
    /// Example of implementation
    /// ```swift
    /// SimpleCalendarView(
    ///     events: eventList,
    ///     selectionAction: .inform { event in
    ///           debugPrint("An event was selected with id: \(event.id)")
    ///     }
    /// )
    /// ```
    case inform((any EventRepresentable) -> Void)

    /// Does nothing when the user selects an event
    ///
    /// Example of implementation
    /// ```swift
    /// SimpleCalendarView(
    ///     events: eventList,
    ///     selectionAction: .none
    /// )
    /// ```
    case none
}

/// A Simple Calendar view containing the events and activities send in
public struct SimpleCalendarView: View {
    /// The events the calendar should show
    let events: [any EventRepresentable]

    @State private var visibleEvents: [any EventRepresentable]
    @State private var selectedDate: Date
    @State private var hourHeight: Double
    @State private var hourSpacing: Double
    private let startHourOfDay: Int
    private let selectionAction: SelectionAction
    private let dateSelectionStyle: DateSelectionStyle

    /// Simple Calendar should be initialised with events. The remaining have a default value.
    /// - Parameters:
    ///   - events: The list of events that the calendar should show. Should be a list of ``EventRepresentable``, such as ``Event``.
    ///   - selectedDate: The date the calendar show show, defaults to todays date
    ///   - selectionAction: The action the calendar should perform when a user selects an event. Defaults to `.sheet`
    ///   - dateSelectionStyle: The type of date selection in the toolbar, default is `.datePicker`
    ///   - hourHeight: The height for each hour label.  Defaults to `25.0`
    ///   - hourSpacing: The vstack spacing between each hour label. Defaults to `24`
    ///   - startHourOfDay: The first hour of the day to show. Defaults to `6` as 6 in the morning / 6 am
    public init(
        events: [any EventRepresentable],
        selectedDate: Date = Date(),
        selectionAction: SelectionAction = .sheet,
        dateSelectionStyle: DateSelectionStyle = .datePicker,
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
        self.dateSelectionStyle = dateSelectionStyle
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

    /// The date selection style added to the navigation bar
    public enum DateSelectionStyle {
        /// The system default date picker
        case datePicker

        /// A range of dates provided by the app
        case selectedDates([Date])
    }

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
                    ZStack {
                        switch dateSelectionStyle {
                        case .datePicker:
                            DatePicker("", selection: $selectedDate, displayedComponents: [.date])
                                .labelsHidden()
                        case .selectedDates(let dates):
                            Picker(selection: $selectedDate) {
                                ForEach(dates, id:\.self) { date in
                                    Text(date, style: .date)
                                }
                            } label: {
                                Text("")
                            }
                        }
                    }
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
