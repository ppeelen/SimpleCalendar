//
// Created by Paul Peelen
// Copyright © 2023 AppTrix AB. All rights reserved.
//

import Foundation
import SwiftUI

/// ActivityRepresentable defines theicontant of an activity
///
/// The default model Simple Calendar uses is ``Activity``, but using ``ActivityRepresentable`` you could give your own model the same conformance without having to translate
/// any models to ``Activity``. An Activity can occur multiple times inside a calendar. E.g. if you have a workshop event that is repeated throughout multiple days, you create one activity and multiple events linking
/// the same activity.
public protocol ActivityRepresentable: Codable {

    /// The Activity identifier
    var id: UUID { get }

    /// The title of the activity. E.g. `Vision Pro workshop`
    var title: String { get }

    /// Any description of the activity
    var description: String { get }

    /// The mentors or hosts of the activity. E.g. if you have someone leading the activity`John Doe`
    var mentors: [String] { get }

    /// The type of activity, defined by ``ActivityType``, giving the activity a color too.
    var type: ActivityType { get }

    /// The duration of the activity in seconds.
    var duration: Double { get }
}

/// This defines the color and naming type of an activity.
///
/// It categorises an activity so the user can easier distinguish between each activity.
public struct ActivityType: Codable {
    public let name: String
    public let color: Color

    public init(name: String, color: Color) {
        self.name = name
        self.color = color
    }
}

internal extension ActivityType {
    static func forPreview(
        name: String = "For Preview",
        color: Color = [.yellow, .red, .green, .blue].randomElement()!
    ) -> ActivityType {
        ActivityType(name: name, color: color)
    }
}

/// This is the default model for an activity
///
/// An Activity defines the item visible in the calendar which will be represented by an ``Event``.
public struct Activity: ActivityRepresentable {
    public let id: UUID
    public let title: String
    public let description: String
    public let mentors: [String]
    public let type: ActivityType
    public let duration: Double

    public init(id: UUID, title: String, description: String, mentors: [String], type: ActivityType, duration: Double) {
        self.id = id
        self.title = title
        self.description = description
        self.mentors = mentors
        self.type = type
        self.duration = duration
    }
}

extension Activity: Codable { }

internal extension Activity {
    /// Only meant to be used for Preview purposes. Might change in the future.
    /// - Parameters:
    ///   - id: The ID of the activity
    ///   - title: Activity title
    ///   - description: Activity description
    ///   - mentors: The ID's of the mentors for the activity. Can be an empty array if no Mentors are assigned
    ///   - type: The ``ActivityType`` of the activity
    ///   - duration: The duration of the activity in seconds
    /// - Returns: `Activity`
    static func forPreview(id: UUID = UUID(),
                           title: String = "Lorum Ipsum",
                           description: String = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla vestibulum maximus quam, eget egestas nisi accumsan eget. Phasellus egestas tristique tortor, vel interdum lorem porta non.",
                           mentors: [String] = [],
                           type: ActivityType = ActivityType.forPreview(),
                           duration: Double = 60 * 60) -> Activity {
        Activity(id: id,
                 title: title,
                 description: description,
                 mentors: mentors,
                 type: type,
                 duration: duration)
    }
}
