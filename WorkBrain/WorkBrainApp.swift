import SwiftUI
import SwiftData

@main
struct WorkBrainApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .background(WindowOpacityObserver())
        }
        .modelContainer(for: [DailyNote.self, NoteTemplate.self])
        .windowStyle(.hiddenTitleBar)
        .defaultSize(width: 800, height: 600)
    }
}

/// Helper view that configures the NSWindow for real transparency.
struct WindowOpacityObserver: View {
    @Environment(\.viewModelOpacity) private var opacity

    var body: some View {
        Color.clear
            .frame(width: 0, height: 0)
            .onAppear { configureWindow() }
            .onChange(of: opacity) { _, _ in configureWindow() }
    }

    private func configureWindow() {
        guard let window = NSApplication.shared.keyWindow else { return }
        window.isOpaque = false
        window.backgroundColor = .clear
        window.hasShadow = true
        // Don't override level here — ContentView manages that
    }
}

// MARK: - Environment key for opacity

private struct ViewModelOpacityKey: EnvironmentKey {
    static let defaultValue: Double = 0.95
}

extension EnvironmentValues {
    var viewModelOpacity: Double {
        get { self[ViewModelOpacityKey.self] }
        set { self[ViewModelOpacityKey.self] = newValue }
    }
}