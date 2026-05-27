import SwiftUI
import SwiftData

struct ContentView: View {
    @StateObject private var viewModel = MainViewModel()
    @Environment(\.modelContext) private var modelContext
    @Environment(\.colorScheme) private var systemColorScheme

    var body: some View {
        VStack(spacing: 0) {
            // Day bar
            DayBar(
                days: viewModel.weekdayBar,
                selectedDate: viewModel.selectedDate,
                onSelect: { viewModel.selectDate($0) }
            )
            .background(.bar)

            Divider()

            // Note editor
            NoteEditor(
                content: $viewModel.noteContent,
                date: viewModel.selectedDate
            )
            .frame(maxWidth: .infinity, maxHeight: .infinity)

            Divider()

            // Bottom bar
            BottomBar(
                isPinned: $viewModel.isPinned,
                opacity: $viewModel.opacity,
                appearance: $viewModel.appearance
            )
        }
        .background(.ultraThinMaterial)
        .preferredColorScheme(viewModel.appearance.preferredColorScheme)
        .opacity(viewModel.opacity)
        .onAppear {
            viewModel.configure(modelContext: modelContext)
        }
        .onChange(of: viewModel.noteContent) { _, _ in
            viewModel.onNoteContentChange()
        }
        .onChange(of: viewModel.isPinned) { _, pinned in
            setWindowFloating(pinned)
        }
    }

    // MARK: - Window Manipulation

    private func setWindowFloating(_ floating: Bool) {
        guard let window = NSApplication.shared.keyWindow else { return }
        if floating {
            window.level = .floating
        } else {
            window.level = .normal
        }
    }
}