import SwiftUI

struct BottomBar: View {
    @Binding var isPinned: Bool
    @Binding var opacity: Double
    @Binding var appearance: AppAppearance
    @Binding var isClickThrough: Bool

    var body: some View {
        HStack(spacing: 20) {
            // Pin toggle — icon only
            Button {
                isPinned.toggle()
            } label: {
                Image(systemName: isPinned ? "pin.fill" : "pin")
                    .font(.subheadline)
            }
            .buttonStyle(.plain)
            .foregroundStyle(isPinned ? Color.accentColor : .secondary)
            .help(isPinned ? "Unpin window" : "Pin window on top")

            // Click-through toggle — icon only
            Button {
                isClickThrough.toggle()
            } label: {
                Image(systemName: isClickThrough ? "hand.raised.fill" : "hand.raised")
                    .font(.subheadline)
            }
            .buttonStyle(.plain)
            .foregroundStyle(isClickThrough ? Color.accentColor : .secondary)
            .help("Toggle click-through (Cmd+T)")
            .keyboardShortcut("t", modifiers: .command)

            Divider()
                .frame(height: 20)

            // Opacity slider
            HStack(spacing: 8) {
                Image(systemName: "circle.lefthalf.filled")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                Slider(value: $opacity, in: 0.1...1.0, step: 0.05)
                    .frame(width: 100)
                Text("\(Int(opacity * 100))%")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .monospacedDigit()
                    .frame(width: 32, alignment: .trailing)
            }

            Spacer()

            // Appearance toggle
            Menu {
                ForEach(AppAppearance.allCases, id: \.self) { mode in
                    Button {
                        appearance = mode
                    } label: {
                        Label(mode.label, systemImage: appearanceIcon(for: mode))
                    }
                }
            } label: {
                Image(systemName: appearanceIcon(for: appearance))
                    .font(.subheadline)
            }
            .buttonStyle(.plain)
            .foregroundStyle(.secondary)
            .help("Appearance")
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .background(.ultraThinMaterial)
    }

    private func appearanceIcon(for mode: AppAppearance) -> String {
        switch mode {
        case .system: "circle.lefthalf.filled"
        case .light: "sun.max"
        case .dark: "moon"
        }
    }
}