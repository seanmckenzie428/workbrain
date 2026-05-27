import SwiftUI
import SwiftData

@MainActor
final class MainViewModel: ObservableObject {

    // MARK: - Published State

    @Published var selectedDate: Date = Date()
    @Published var noteContent: String = ""
    @Published var isPinned: Bool = false
    @Published var opacity: Double = 0.95
    @Published var appearance: AppAppearance = .system
    @Published var isClickThrough: Bool = false
    @Published var showCalendar: Bool = false

    // MARK: - Persistence

    private var modelContext: ModelContext?
    private var saveTask: Task<Void, Never>?

    // MARK: - Weekday Bar

    var weekdayBar: [Date] {
        DateUtils.weekdayBar(today: Date())
    }

    var selectedDateString: String {
        DateUtils.isoDateString(selectedDate)
    }

    func configure(modelContext: ModelContext) {
        self.modelContext = modelContext
        loadNote(for: selectedDate)
    }

    // MARK: - Note Management

    func selectDate(_ date: Date) {
        saveCurrentNote()
        selectedDate = date
        loadNote(for: date)
    }

    func onNoteContentChange() {
        saveTask?.cancel()
        saveTask = Task {
            try? await Task.sleep(for: .milliseconds(500))
            saveCurrentNote()
        }
    }

    // MARK: - Private

    private func loadNote(for date: Date) {
        guard let ctx = modelContext else { return }
        let normalized = DailyNote.normalize(date)

        let descriptor = FetchDescriptor<DailyNote>(
            predicate: #Predicate { $0.date == normalized }
        )

        if let existing = try? ctx.fetch(descriptor).first {
            noteContent = stripTitleHeader(existing.content)
        } else {
            let templateContent = fetchTemplateContent()
            let note = DailyNote(date: normalized, content: templateContent)
            ctx.insert(note)
            try? ctx.save()
            noteContent = templateContent
        }
    }

    private func saveCurrentNote() {
        guard let ctx = modelContext else { return }
        let normalized = DailyNote.normalize(selectedDate)

        let descriptor = FetchDescriptor<DailyNote>(
            predicate: #Predicate { $0.date == normalized }
        )

        if let note = try? ctx.fetch(descriptor).first {
            note.content = noteContent
            note.updatedAt = Date()
            try? ctx.save()
        }
    }

    private func fetchTemplateContent() -> String {
        guard let ctx = modelContext else { return NoteTemplate.default }

        let descriptor = FetchDescriptor<NoteTemplate>()
        if let template = try? ctx.fetch(descriptor).first {
            // Migrate old templates that had # {date} header
            if template.content.contains("# {date}") || template.content.contains("{date}") {
                template.content = NoteTemplate.default
                template.updatedAt = Date()
                try? ctx.save()
                return NoteTemplate.default
            }
            return template.content
        }

        let template = NoteTemplate(content: NoteTemplate.default)
        ctx.insert(template)
        try? ctx.save()
        return template.content
    }

    /// Strip legacy `# YYYY-MM-DD` header from old notes.
    private func stripTitleHeader(_ content: String) -> String {
        let lines = content.split(separator: "\n", omittingEmptySubsequences: false)
        guard let first = lines.first, first.hasPrefix("# ") else { return content }
        let rest = lines.dropFirst().joined(separator: "\n")
        return rest.isEmpty ? content : rest
    }
}

// MARK: - Appearance Enum

enum AppAppearance: String, CaseIterable {
    case system = "system"
    case light = "light"
    case dark = "dark"

    var label: String {
        switch self {
        case .system: "System"
        case .light: "Light"
        case .dark: "Dark"
        }
    }

    var preferredColorScheme: ColorScheme? {
        switch self {
        case .system: nil
        case .light: .light
        case .dark: .dark
        }
    }
}