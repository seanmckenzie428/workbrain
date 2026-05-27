import SwiftUI
import SwiftData

struct DayBar: View {
    let days: [Date]
    let selectedDate: Date
    let onSelect: (Date) -> Void

    @State private var showCalendar = false

    var body: some View {
        HStack(spacing: 8) {
            // Calendar expand button
            Button {
                showCalendar.toggle()
            } label: {
                Image(systemName: "calendar")
                    .font(.subheadline)
            }
            .buttonStyle(.plain)
            .foregroundStyle(.secondary)
            .popover(isPresented: $showCalendar, arrowEdge: .bottom) {
                CalendarPicker(selectedDate: selectedDate, onSelect: { date in
                    onSelect(date)
                    showCalendar = false
                })
            }

            // Day pills
            ForEach(days, id: \.self) { day in
                DayPill(
                    date: day,
                    isSelected: Calendar(identifier: .iso8601).isDate(day, inSameDayAs: selectedDate),
                    isToday: Calendar(identifier: .iso8601).isDateInToday(day)
                )
                .onTapGesture {
                    onSelect(day)
                }
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 4)
    }
}

// MARK: - Day Pill

private struct DayPill: View {
    let date: Date
    let isSelected: Bool
    let isToday: Bool

    var body: some View {
        VStack(spacing: 2) {
            Text(dayName)
                .font(.caption2)
                .textCase(.uppercase)
                .foregroundStyle(isSelected ? .white : .primary)
            Text(dayNumber)
                .font(.callout)
                .fontWeight(isSelected ? .bold : .medium)
                .foregroundStyle(isSelected ? .white : .primary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 4)
        .contentShape(Rectangle())
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(isSelected ? Color.accentColor : Color.clear)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(isToday && !isSelected ? Color.accentColor : Color.clear, lineWidth: 2)
        )
    }

    private var dayName: String {
        let f = DateFormatter()
        f.dateFormat = "EEE"
        return f.string(from: date)
    }

    private var dayNumber: String {
        let f = DateFormatter()
        f.dateFormat = "d"
        return f.string(from: date)
    }
}

// MARK: - Calendar Picker Popover

struct CalendarPicker: View {
    let selectedDate: Date
    let onSelect: (Date) -> Void

    @State private var displayedMonth = Date()

    private var calendar: Calendar { Calendar(identifier: .iso8601) }

    var body: some View {
        VStack(spacing: 8) {
            // Month navigation
            HStack {
                Button { moveMonth(-1) } label: {
                    Image(systemName: "chevron.left")
                }
                .buttonStyle(.plain)
                Spacer()
                Text(monthTitle)
                    .font(.headline)
                Spacer()
                Button { moveMonth(1) } label: {
                    Image(systemName: "chevron.right")
                }
                .buttonStyle(.plain)
            }

            // Weekday headers — reorder to Monday-first for ISO 8601
            let rawSymbols = calendar.veryShortWeekdaySymbols
            let mondayFirstSymbols = Array(rawSymbols.dropFirst()) + [rawSymbols.first!] // Mon..Sat, Sun
            HStack(spacing: 4) {
                ForEach(mondayFirstSymbols.indices, id: \.self) { i in
                    Text(mondayFirstSymbols[i])
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                        .frame(maxWidth: .infinity)
                }
            }

            // Day grid
            let weeks = weeksForMonth()
            ForEach(weeks.indices, id: \.self) { weekIdx in
                HStack(spacing: 4) {
                    ForEach(weeks[weekIdx], id: \.self) { date in
                        if let date {
                            let isSelected = calendar.isDate(date, inSameDayAs: selectedDate)
                            let isToday = calendar.isDateInToday(date)
                            let isWeekday = isWeekdayDate(date)

                            Text("\(calendar.component(.day, from: date))")
                                .font(.caption)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 4)
                                .background(
                                    RoundedRectangle(cornerRadius: 4)
                                        .fill(isSelected ? Color.accentColor : Color.clear)
                                )
                                .foregroundStyle(
                                    isSelected ? .white :
                                    isWeekday ? .primary : Color.gray.opacity(0.35)
                                )
                                .overlay(
                                    RoundedRectangle(cornerRadius: 4)
                                        .stroke(isToday ? Color.accentColor : Color.clear, lineWidth: 1.5)
                                )
                                .onTapGesture { onSelect(date) }
                        } else {
                            Text("")
                                .font(.caption)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 4)
                        }
                    }
                }
            }
        }
        .padding(12)
        .frame(width: 260)
    }

    private var monthTitle: String {
        let f = DateFormatter()
        f.dateFormat = "MMMM yyyy"
        return f.string(from: displayedMonth)
    }

    private func moveMonth(_ delta: Int) {
        if let new = calendar.date(byAdding: .month, value: delta, to: displayedMonth) {
            displayedMonth = new
        }
    }

    private func isWeekdayDate(_ date: Date) -> Bool {
        let wd = calendar.component(.weekday, from: date)
        return wd >= 2 && wd <= 6 // Mon=2 ... Fri=6
    }

    private func weeksForMonth() -> [[Date?]] {
        guard let monthStart = calendar.date(from: calendar.dateComponents([.year, .month], from: displayedMonth)),
              let range = calendar.range(of: .day, in: .month, for: monthStart) else {
            return []
        }

        let firstWeekday = calendar.component(.weekday, from: monthStart)
        var offset = firstWeekday - 2
        if offset < 0 { offset = 6 }

        var days: [Date?] = Array(repeating: nil, count: offset)
        for day in range {
            if let date = calendar.date(byAdding: .day, value: day - 1, to: monthStart) {
                days.append(date)
            }
        }
        while days.count % 7 != 0 {
            days.append(nil)
        }

        return stride(from: 0, to: days.count, by: 7).map { idx in
            Array(days[idx..<(idx + 7)])
        }
    }
}