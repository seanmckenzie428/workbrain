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
            if !viewModel.isClickThrough {
                DayBar(
                    days: viewModel.weekdayBar,
                    selectedDate: viewModel.selectedDate,
                    onSelect: { viewModel.selectDate($0) }
                )

                Divider()
            }

            NoteEditor(
                content: $viewModel.noteContent,
                date: viewModel.selectedDate
            )
            .frame(maxWidth: .infinity, maxHeight: .infinity)

            if !viewModel.isClickThrough {
                Divider()

                BottomBar(
                    isPinned: $viewModel.isPinned,
                    opacity: $viewModel.opacity,
                    appearance: $viewModel.appearance,
                    isClickThrough: $viewModel.isClickThrough
                )
            }
        }
        .background(.clear)
        .preferredColorScheme(viewModel.appearance.preferredColorScheme)
        .background(WindowFinder { window in
            WindowManager.shared.setup(for: window)
            WindowManager.shared.setOpacity(viewModel.opacity)
            WindowManager.shared.setFloating(viewModel.isPinned)
            WindowManager.shared.setClickThrough(viewModel.isClickThrough)
            WindowManager.shared.setAppearance(effectiveColorScheme)
        })
        .onChange(of: effectiveColorScheme) { _, scheme in
            WindowManager.shared.setAppearance(scheme)
        }
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
        // Auto click-through: lose focus → ON, gain focus → OFF
        .onReceive(NotificationCenter.default.publisher(for: NSWindow.didResignKeyNotification)) { _ in
            withAnimation(.easeInOut(duration: 0.2)) {
                viewModel.isClickThrough = true
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: NSWindow.didBecomeKeyNotification)) { _ in
            withAnimation(.easeInOut(duration: 0.2)) {
                viewModel.isClickThrough = false
            }
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