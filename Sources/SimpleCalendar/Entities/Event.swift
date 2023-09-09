//
//  File.swift
//
//
//  Created by Paul Peelen on 2023-09-09.
//

import Foundation

public protocol EventRepresentable: Equatable {
    var id: String { get }
    var startDate: Date { get }
    var activity: any ActivityRepresentable { get }
    //    var duration: TimeInterval { get }

    var coordinates: CGRect? { get set }
    var column: Int { get set }
    var columnCount: Int { get set }
}

public struct Event: EventRepresentable {
    public let id: String
    public let startDate: Date
    public let activity: any ActivityRepresentable

    public var coordinates: CGRect?
    public var column: Int = 0
    public var columnCount: Int = 0

    public init(
        id: String,
        startDate: Date,
        activity: ActivityRepresentable
    ) {
        self.id = id
        self.startDate = startDate
        self.activity = activity

        self.coordinates = nil
        self.column = 0
        self.columnCount = 0
    }
}

internal extension Event {
    /// Only meant to be used for Preview purposes. Might change in the future.
    ///
    /// - Parameters:
    ///   - id: The ID of the event
    ///   - startDate: The start time of the event as `Date`
    ///   - endDate: The end time of the event as `Date`
    ///   - activity: The ``activity`` bound to the event
    ///   - duration: The duration of the event in seconds.
    /// - Returns: an ``Event``
    static func forPreview(id: String = "1",
                           startDate: Date = Date(timeIntervalSinceNow: 60 * 60),
                           activity: Activity = Activity.forPreview()) -> Event {
        Event(
            id: id,
            startDate: startDate,
            activity: activity
        )
    }
}

extension Event: Identifiable { }
extension Event: Equatable {
    public static func == (lhs: Event, rhs: Event) -> Bool {
        lhs.id == rhs.id
    }
}
