import SwiftUI

struct BottomBar: View {
    @Binding var isPinned: Bool
    @Binding var opacity: Double
    @Binding var appearance: AppAppearance
    @Binding var isClickThrough: Bool

    var body: some View {
        HStack(spacing: 16) {
            // Pin toggle
            Button {
                isPinned.toggle()
            } label: {
                Label(isPinned ? "Unpin" : "Pin",
                      systemImage: isPinned ? "pin.fill" : "pin")
                    .font(.subheadline)
            }
            .buttonStyle(.plain)
            .foregroundStyle(isPinned ? Color.accentColor : .secondary)

            // Click-through toggle
            Button {
                isClickThrough.toggle()
            } label: {
                Label("Click-through",
                      systemImage: isClickThrough ? "hand.raised.fill" : "hand.raised")
                    .font(.subheadline)
            }
            .buttonStyle(.plain)
            .foregroundStyle(isClickThrough ? Color.accentColor : .secondary)
            .help("When on, clicks pass through to apps behind this window")

            // Opacity slider
            HStack(spacing: 8) {
                Text("Opacity")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Slider(value: $opacity, in: 0.1...1.0, step: 0.05)
                    .frame(width: 120)
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