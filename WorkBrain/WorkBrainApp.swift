import SwiftUI
import SwiftData

@main
struct WorkBrainApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: [DailyNote.self, NoteTemplate.self])
        .windowStyle(.hiddenTitleBar)
        .defaultSize(width: 800, height: 600)
    }
}