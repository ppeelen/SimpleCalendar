//
// Created by Paul Peelen
// Copyright © 2023 AppTrix AB. All rights reserved.
//

import SwiftUI
import SimpleCalendar

class DataModel {
    private let activities: [Activity] = {
        // ActivityTypes
        let exerciseType = ActivityType(name: "Exercise", color: Color.red)
        let mealType = ActivityType(name: "Meal", color: Color.green)
        let studyType = ActivityType(name: "Study", color: Color.blue)
        let entertainmentType = ActivityType(name: "Entertainment", color: Color.purple)
        let relaxationType = ActivityType(name: "Relaxation", color: Color.yellow)

        // Activities based on the given ActivityType instances
        let wakeup = Activity(
            id: UUID(),
            title: "Wakeup",
            description: "Time to start a new day.",
            mentors: [""],
            type: relaxationType,
            duration: 600
        )

        let jogging = Activity(
            id: UUID(),
            title: "Morning Jog",
            description: "A brisk morning jog around the park to get the blood pumping.",
            mentors: ["John Doe"],
            type: exerciseType,
            duration: 1.0 * 3600 // 1 hour
        )

        let breakfast = Activity(
            id: UUID(),
            title: "Breakfast",
            description: "A healthy meal to start the day with energy.",
            mentors: [],
            type: mealType,
            duration: 0.5 * 3600 // 30 minutes
        )

        let reading = Activity(
            id: UUID(),
            title: "Reading",
            description: "Reading a chapter from a self-help book.",
            mentors: ["Jane Smith"],
            type: studyType,
            duration: 1.5 * 3600 // 1 hour 30 minutes
        )

        let movie = Activity(
            id: UUID(),
            title: "Watch a Movie",
            description: "Watching a classic movie.",
            mentors: [],
            type: entertainmentType,
            duration: 2.0 * 3600 // 2 hours
        )

        let meditation = Activity(
            id: UUID(),
            title: "Meditation",
            description: "A calm session of mindfulness and breathing exercises.",
            mentors: ["Guru Dan"],
            type: relaxationType,
            duration: 0.5 * 3600 // 30 minutes
        )

        return [
            wakeup,
            jogging,
            breakfast,
            reading,
            movie,
            meditation
        ]
    }()

    func getEvents() -> [Event] {
        let dateToday = Date()
        let dateTomorrow = Date(timeIntervalSinceNow: 24 * 3600)
        let dateTenDaysFromNow = Date(timeIntervalSinceNow: (24 * 3600) * 10)

        let eventsToday = [
            Event(id: "wakeup", startDate: dateToday.bySettingHour(6, minute: 10), activity: getActivities(withTitle: "Wakeup")!),
            Event(id: "1jog", startDate: dateToday.bySettingHour(6, minute: 30), activity: getActivities(withTitle: "Morning Jog")!),
            Event(id: "1breakfast", startDate: dateToday.bySettingHour(7, minute: 30), activity: getActivities(withTitle: "Breakfast")!),
            Event(id: "1Meditation", startDate: dateToday.bySettingHour(8, minute: 30), activity: getActivities(withTitle: "Meditation")!),
            Event(id: "1reading", startDate: dateToday.bySettingHour(9, minute: 30), activity: getActivities(withTitle: "Reading")!),
            Event(id: "1Meditation2", startDate: dateToday.bySettingHour(15, minute: 30), activity: getActivities(withTitle: "Meditation")!),
            Event(id: "1reading2", startDate: dateToday.bySettingHour(15, minute: 45), activity: getActivities(withTitle: "Reading")!),
            Event(id: "1movie", startDate: dateToday.bySettingHour(21, minute: 0), activity: getActivities(withTitle: "Watch a Movie")!)
        ]

        let eventTomorrow = [
            Event(id: "wakeup", startDate: dateTomorrow.bySettingHour(6, minute: 10), activity: getActivities(withTitle: "Wakeup")!),
            Event(id: "2jog", startDate: dateTomorrow.bySettingHour(6, minute: 30), activity: getActivities(withTitle: "Morning Jog")!),
            Event(id: "2breakfast", startDate: dateTomorrow.bySettingHour(7, minute: 30), activity: getActivities(withTitle: "Breakfast")!),
            Event(id: "2Meditation", startDate: dateTomorrow.bySettingHour(8, minute: 30), activity: getActivities(withTitle: "Meditation")!),
            Event(id: "2Meditation2", startDate: dateTomorrow.bySettingHour(15, minute: 30), activity: getActivities(withTitle: "Meditation")!),
            Event(id: "2reading2", startDate: dateTomorrow.bySettingHour(15, minute: 45), activity: getActivities(withTitle: "Reading")!)
        ]

        let tenDaysFromNow = [
            Event(id: "wakeup", startDate: dateTenDaysFromNow.bySettingHour(6, minute: 10), activity: getActivities(withTitle: "Wakeup")!),
            Event(id: "2jog", startDate: dateTenDaysFromNow.bySettingHour(6, minute: 30), activity: getActivities(withTitle: "Morning Jog")!)
        ]

        return eventsToday + eventTomorrow + tenDaysFromNow
    }

    private func getActivities(withTitle title: String) -> Activity? {
        activities.first(where: { $0.title == title })
    }


}

private extension Date {
    func bySettingHour(_ hour: Int, minute: Int) -> Date {
        Calendar.current.date(bySettingHour: hour, minute: minute, second: 0, of: self)!
    }
}
