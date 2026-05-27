import SwiftUI
import SwiftData

struct ContentView: View {
    @ObservedObject var viewModel: MainViewModel
    @Environment(\.modelContext) private var modelContext
    @Environment(\.colorScheme) private var colorScheme

    private var effectiveColorScheme: ColorScheme {
        switch viewModel.appearance {
        case .system: return colorScheme
        case .light: return .light
        case .dark: return .dark
        }
    }

    var body: some View {
        VStack(spacing: 0) {
            DayBar(
                days: viewModel.weekdayBar,
                selectedDate: viewModel.selectedDate,
                onSelect: { viewModel.selectDate($0) }
            )

            Divider()

            NoteEditor(
                content: $viewModel.noteContent,
                date: viewModel.selectedDate
            )
            .frame(maxWidth: .infinity, maxHeight: .infinity)

            Divider()

            BottomBar(
                isPinned: $viewModel.isPinned,
                opacity: $viewModel.opacity,
                appearance: $viewModel.appearance,
                isClickThrough: $viewModel.isClickThrough
            )
        }
        .background(.clear)
        .preferredColorScheme(viewModel.appearance.preferredColorScheme)
        .background(WindowFinder { window in
            WindowManager.shared.setup(for: window)
            WindowManager.shared.setOpacity(viewModel.opacity)
            WindowManager.shared.setFloating(viewModel.isPinned)
        })
        .onAppear {
            viewModel.configure(modelContext: modelContext)
        }
        .onChange(of: viewModel.opacity) { _, opacity in
            WindowManager.shared.setOpacity(opacity)
        }
        .onChange(of: viewModel.isPinned) { _, pinned in
            WindowManager.shared.setFloating(pinned)
        }
        .onChange(of: viewModel.isClickThrough) { _, clickThrough in
            WindowManager.shared.setClickThrough(clickThrough)
        }
    }
}

// MARK: - Window Finder

struct WindowFinder: NSViewRepresentable {
    let onFound: (NSWindow) -> Void

    func makeNSView(context: Context) -> NSView {
        let view = NSView()
        DispatchQueue.main.async {
            if let window = view.window {
                onFound(window)
            }
        }
        return view
    }

    func updateNSView(_ nsView: NSView, context: Context) {}
}