//
// Created by Paul Peelen
// Copyright © 2023 AppTrix AB. All rights reserved.
//

import Foundation
import SwiftUI

public protocol ActivityRepresentable: Codable {
    var id: UUID { get }
    var title: String { get }
    var description: String { get }
    var mentors: [String] { get }
    var type: ActivityType { get }
    var duration: Double { get }
}

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
