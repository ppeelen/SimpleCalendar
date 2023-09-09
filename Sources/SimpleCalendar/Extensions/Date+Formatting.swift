//
//  File.swift
//  
//
//  Created by Paul Peelen on 2023-09-09.
//

import Foundation

extension Date {
    func relativeDateDisplay() -> String {
        RelativeDateTimeFormatter().localizedString(for: self, relativeTo: Date())
    }

    func atHour(_ hour: Int, minute: Int = 0, second: Int = 0) -> Date? {
        let calendar = Calendar.current
        var components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: self)

        components.hour = hour
        components.minute = minute
        components.second = second

        return calendar.date(from: components)
    }

    var hour: Int? {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: self)

        return components.hour
    }
}
