import SwiftUI
import SwiftData

@main
struct WorkBrainApp: App {
    @StateObject private var viewModel = MainViewModel()

    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: viewModel)
        }
        .modelContainer(for: [DailyNote.self, NoteTemplate.self])
        .windowStyle(.hiddenTitleBar)
        .defaultSize(width: 800, height: 600)
        .commands {
            CommandMenu("Window") {
                Toggle("Pin on Top", isOn: $viewModel.isPinned)
                    .keyboardShortcut("p", modifiers: .command)

                Toggle("Click Through", isOn: $viewModel.isClickThrough)
                    .keyboardShortcut("t", modifiers: .command)
            }
        }
    }
}