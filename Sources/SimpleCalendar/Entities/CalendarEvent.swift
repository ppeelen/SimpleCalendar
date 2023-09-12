//
//  File.swift
//
//
//  Created by Paul Peelen on 2023-09-09.
//

import Foundation

/// CalendarEventRepresentable defines the content an "event" should have.
///
/// The default model Simple Calendar uses is ``CalendarEvent``, but using ``CalendarEventRepresentable`` you could give your own model the same conformance without having to translate the models to ``CalendarEvent``.
public protocol CalendarEventRepresentable: Equatable {

    /// The event identifier
    var id: String { get }

    /// The start date and time of the event
    var startDate: Date { get }

    /// The ``Activity`` this event is representing
    var activity: any CalendarActivityRepresentable { get }

    /// The coordinates of the event. Should only be set by Simple Calendar
    var coordinates: CGRect? { get set }

    /// The horizontal column location of the event. Should only be set by Simple Calendar
    var column: Int { get set }

    /// The total amount of columns available where this event is rendered. Should only be set by Simple Calendar.
    var columnCount: Int { get set }
}

/// This is the default model for an event.
///
/// An CalendarEvent is an occurrence of an ``CalendarActivity`` at a certain point in time. An event also contain logic for the positioning of the event inside the calendar.
public struct CalendarEvent: CalendarEventRepresentable {
    public let id: String
    public let startDate: Date
    public let activity: any CalendarActivityRepresentable

    public var coordinates: CGRect?
    public var column: Int = 0
    public var columnCount: Int = 0

    /// The CalendarEvent initialiser
    /// - Parameters:
    ///   - id: The event identifier
    ///   - startDate: The start date and time of the event
    ///   - activity: The ``CalendarActivity`` this event is representing
    public init(
        id: String,
        startDate: Date,
        activity: CalendarActivityRepresentable
    ) {
        self.id = id
        self.startDate = startDate
        self.activity = activity

        self.coordinates = nil
        self.column = 0
        self.columnCount = 0
    }
}

internal extension CalendarEvent {
    /// Only meant to be used for Preview purposes. Might change in the future.
    ///
    /// - Parameters:
    ///   - id: The ID of the event
    ///   - startDate: The start time of the event as `Date`
    ///   - endDate: The end time of the event as `Date`
    ///   - activity: The ``activity`` bound to the event
    ///   - duration: The duration of the event in seconds.
    /// - Returns: an ``CalendarEvent``
    static func forPreview(id: String = "1",
                           startDate: Date = Date(timeIntervalSinceNow: 60 * 60),
                           activity: CalendarActivity = CalendarActivity.forPreview()) -> CalendarEvent {
        CalendarEvent(
            id: id,
            startDate: startDate,
            activity: activity
        )
    }
}

extension CalendarEvent: Identifiable { }
extension CalendarEvent: Equatable {
    public static func == (lhs: CalendarEvent, rhs: CalendarEvent) -> Bool {
        lhs.id == rhs.id
    }
}
