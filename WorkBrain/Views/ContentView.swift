import SwiftUI
import SwiftData

struct ContentView: View {
    @StateObject private var viewModel = MainViewModel()
    @Environment(\.modelContext) private var modelContext

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
                appearance: $viewModel.appearance,
                isClickThrough: $viewModel.isClickThrough
            )
        }
        .background(.ultraThinMaterial.opacity(viewModel.opacity))
        .preferredColorScheme(viewModel.appearance.preferredColorScheme)
        .environment(\.viewModelOpacity, viewModel.opacity)
        .onAppear {
            viewModel.configure(modelContext: modelContext)
        }
        .onChange(of: viewModel.noteContent) { _, _ in
            viewModel.onNoteContentChange()
        }
        .onChange(of: viewModel.isPinned) { _, pinned in
            setWindowFloating(pinned)
        }
        .onChange(of: viewModel.isClickThrough) { _, clickThrough in
            setWindowClickThrough(clickThrough)
        }
    }

    // MARK: - Window Manipulation

    private func setWindowFloating(_ floating: Bool) {
        guard let window = NSApplication.shared.keyWindow else { return }
        window.level = floating ? .floating : .normal
    }

    private func setWindowClickThrough(_ clickThrough: Bool) {
        guard let window = NSApplication.shared.keyWindow else { return }
        window.ignoresMouseEvents = clickThrough
    }
}