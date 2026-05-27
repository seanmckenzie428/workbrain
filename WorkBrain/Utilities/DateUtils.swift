import Foundation

enum DateUtils {

    // MARK: - Weekday Bar

    /// Returns the 4 weekdays: 3 preceding weekdays + today.
    /// Weekends (Sat/Sun) are skipped entirely.
    /// Today is always the last element.
    static func weekdayBar(today: Date = Date()) -> [Date] {
        let cal = Calendar(identifier: .iso8601)
        var days: [Date] = []
        var cursor = cal.startOfDay(for: today)

        // Walk backwards collecting weekdays until we have 4 total
        // (today + 3 preceding weekdays)
        while days.count < 4 {
            let weekday = cal.component(.weekday, from: cursor)
            // weekday: 1=Sun, 2=Mon, ..., 6=Sat, 7=Sat in iso8601?
            // Actually iso8601: 1=Mon, 2=Tue, ..., 5=Fri, 6=Sat, 7=Sun
            // But Calendar.identifier.iso8601 still uses gregorian weekday numbers
            // in Calendar.component. Sunday=1, Saturday=7.
            // Let's just check: Mon-Fri = weekday 2..6
            if weekday >= 2 && weekday <= 6 {
                days.insert(cursor, at: 0)
            }
            cursor = cal.date(byAdding: .day, value: -1, to: cursor)!
        }

        return days
    }

    // MARK: - Formatting

    /// ISO 8601 date string: "2026-05-27"
    static func isoDateString(_ date: Date) -> String {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withYear, .withMonth, .withDay, .withDashSeparatorInDate]
        return formatter.string(from: date)
    }

    /// Short display: "Mon 27" or "Wed 15"
    static func shortDayString(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE d"
        return formatter.string(from: date)
    }
}