import SwiftUI

struct DayBar: View {
    let days: [Date]
    let selectedDate: Date
    let onSelect: (Date) -> Void

    var body: some View {
        HStack(spacing: 8) {
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
        .padding(.vertical, 8)
    }
}

// MARK: - Day Pill

private struct DayPill: View {
    let date: Date
    let isSelected: Bool
    let isToday: Bool

    var body: some View {
        VStack(spacing: 2) {
            Text(DateUtils.shortDayString(date).components(separatedBy: " ").first ?? "")
                .font(.caption2)
                .textCase(.uppercase)
                .foregroundStyle(isSelected ? .white : .secondary)
            Text(DateUtils.shortDayString(date).components(separatedBy: " ").last ?? "")
                .font(.title3)
                .fontWeight(isSelected ? .bold : .regular)
                .foregroundStyle(isSelected ? .white : .primary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 6)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(isSelected ? Color.accentColor : Color.clear)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(isToday && !isSelected ? Color.accentColor : Color.clear, lineWidth: 2)
        )
    }
}