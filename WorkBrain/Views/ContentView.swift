import SwiftUI
import SwiftData

struct ContentView: View {
    @ObservedObject var viewModel: MainViewModel
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        ZStack {
            // Background layer — only thing that fades
            Rectangle()
                .fill(.ultraThinMaterial)
                .opacity(viewModel.opacity)

            // Content layer — always full opacity
            VStack(spacing: 0) {
                // Day bar
                DayBar(
                    days: viewModel.weekdayBar,
                    selectedDate: viewModel.selectedDate,
                    onSelect: { viewModel.selectDate($0) }
                )

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
        }
        .preferredColorScheme(viewModel.appearance.preferredColorScheme)
        .onAppear {
            viewModel.configure(modelContext: modelContext)
            configureWindow()
        }
        .onChange(of: viewModel.isPinned) { _, pinned in
            setWindowFloating(pinned)
        }
        .onChange(of: viewModel.isClickThrough) { _, clickThrough in
            setWindowClickThrough(clickThrough)
        }
    }

    // MARK: - Window Configuration

    private func configureWindow() {
        guard let window = NSApplication.shared.keyWindow else { return }
        window.isOpaque = false
        window.backgroundColor = .clear
        window.hasShadow = true
        window.alphaValue = 1.0  // Window stays fully opaque; material layer handles fade
        setWindowFloating(viewModel.isPinned)
        setWindowClickThrough(viewModel.isClickThrough)
    }

    private func setWindowFloating(_ floating: Bool) {
        guard let window = NSApplication.shared.keyWindow else { return }
        window.level = floating ? .floating : .normal
    }

    private func setWindowClickThrough(_ clickThrough: Bool) {
        guard let window = NSApplication.shared.keyWindow else { return }
        window.ignoresMouseEvents = clickThrough
    }
}