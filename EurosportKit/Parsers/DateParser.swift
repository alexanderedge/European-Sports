//
//  DateParser.swift
//  EurosportPlayer
//
//  Created by Alexander Edge on 30/01/2017.


import Foundation

struct DateParser: JSONParsingType {

    typealias T = Date?

    enum DateError: Error {
        case invalidTechnicalDate
        case invalidTime
    }

    static let technicalDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "y-MM-dd"
        return formatter
    }()

    static let timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter
    }()

    static let calendar: Calendar = {
        var calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        calendar.locale = Locale(identifier: "en_US_POSIX")
        calendar.timeZone = TimeZone(abbreviation: "CET")!
        return calendar
    }()

    static func parse(_ json: JSONObject) throws -> Date? {
        guard let startDate = technicalDateFormatter.date(from: try json.extract("technicaldate")) else {
            throw DateError.invalidTechnicalDate
        }

        guard let startTime = timeFormatter.date(from: try json.extract("time")) else {
            throw DateError.invalidTime
        }

        let currentCalendar = NSCalendar.autoupdatingCurrent

        let year = currentCalendar.component(.year, from: startDate)
        let month = currentCalendar.component(.month, from: startDate)
        let day = currentCalendar.component(.day, from: startDate)
        let hour = currentCalendar.component(.hour, from: startTime)
        let minute = currentCalendar.component(.minute, from: startTime)

        var dateComponents = DateComponents()
        dateComponents.year = year
        dateComponents.month = month
        dateComponents.day = day
        dateComponents.hour = hour
        dateComponents.minute = minute
        return calendar.date(from: dateComponents)
    }

}
