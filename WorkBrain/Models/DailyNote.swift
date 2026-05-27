import Foundation
import SwiftData

@Model
final class DailyNote {
    var id: UUID
    var date: Date           // YYYY-MM-DD, normalized to midnight UTC
    var content: String      // Markdown content
    var createdAt: Date
    var updatedAt: Date

    init(date: Date, content: String = "") {
        self.id = UUID()
        self.date = Self.normalize(date)
        self.content = content
        self.createdAt = Date()
        self.updatedAt = Date()
    }

    /// Strip time component, keep only the date (midnight UTC).
    static func normalize(_ date: Date) -> Date {
        Calendar(identifier: .iso8601).startOfDay(for: date)
    }
}