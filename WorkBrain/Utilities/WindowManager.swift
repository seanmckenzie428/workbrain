import AppKit
import SwiftUI

@MainActor
final class WindowManager {
    static let shared = WindowManager()

    private weak var contentWindow: NSWindow?
    private var backgroundWindow: NSWindow?
    private var storedOpacity: Double = 0.95

    func setup(for contentWindow: NSWindow) {
        guard self.contentWindow !== contentWindow || backgroundWindow == nil else { return }

        backgroundWindow?.close()
        self.contentWindow = contentWindow

        let visualEffect = NSVisualEffectView()
        visualEffect.material = .popover
        visualEffect.blendingMode = .behindWindow
        visualEffect.state = .active
        visualEffect.wantsLayer = true
        visualEffect.layer?.cornerRadius = 10
        visualEffect.layer?.masksToBounds = true
        visualEffect.autoresizingMask = [.width, .height]

        let bgWindow = NSWindow(
            contentRect: contentWindow.frame,
            styleMask: [.borderless],
            backing: .buffered,
            defer: false
        )
        bgWindow.isOpaque = false
        bgWindow.backgroundColor = .clear
        bgWindow.hasShadow = false
        bgWindow.contentView = visualEffect
        bgWindow.level = contentWindow.level
        bgWindow.alphaValue = storedOpacity

        contentWindow.isOpaque = false
        contentWindow.backgroundColor = .clear
        contentWindow.addChildWindow(bgWindow, ordered: .below)

        self.backgroundWindow = bgWindow

        // Frame sync
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(syncFrame),
            name: NSWindow.didResizeNotification,
            object: contentWindow
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(syncFrame),
            name: NSWindow.didMoveNotification,
            object: contentWindow
        )

        syncFrame()
    }

    @objc private func syncFrame() {
        guard let content = contentWindow, let bg = backgroundWindow else { return }
        bg.setFrame(content.frame, display: true)
    }

    func setOpacity(_ opacity: Double) {
        storedOpacity = opacity
        backgroundWindow?.alphaValue = opacity
    }

    func setFloating(_ floating: Bool) {
        let level: NSWindow.Level = floating ? .floating : .normal
        contentWindow?.level = level
        backgroundWindow?.level = level
    }

    func setClickThrough(_ clickThrough: Bool) {
        contentWindow?.ignoresMouseEvents = clickThrough
        backgroundWindow?.ignoresMouseEvents = clickThrough
        setWindowButtonsHidden(clickThrough)
    }

    func setAppearance(_ colorScheme: ColorScheme) {
        let appearanceName: NSAppearance.Name = colorScheme == .dark ? .darkAqua : .aqua
        backgroundWindow?.appearance = NSAppearance(named: appearanceName)
    }

    // MARK: - Window Buttons

    private func setWindowButtonsHidden(_ hidden: Bool) {
        guard let window = contentWindow else { return }
        let buttons: [NSWindow.ButtonType] = [.closeButton, .miniaturizeButton, .zoomButton]
        for type in buttons {
            window.standardWindowButton(type)?.isHidden = hidden
        }
    }
}