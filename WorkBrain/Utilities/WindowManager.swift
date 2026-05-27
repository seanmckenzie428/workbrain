import AppKit
import SwiftUI

@MainActor
final class WindowManager {
    static let shared = WindowManager()

    private weak var contentWindow: NSWindow?
    private var backgroundWindow: NSWindow?
    private var visualEffectView: NSVisualEffectView?
    private var tintView: NSView?
    private var storedOpacity: Double = 0.95

    func setup(for contentWindow: NSWindow) {
        guard self.contentWindow !== contentWindow || backgroundWindow == nil else { return }

        backgroundWindow?.close()
        self.contentWindow = contentWindow

        let container = NSView(frame: contentWindow.contentView?.bounds ?? .zero)
        container.autoresizingMask = [.width, .height]
        container.wantsLayer = true
        container.layer?.cornerRadius = 10
        container.layer?.masksToBounds = true

        let visualEffect = NSVisualEffectView()
        visualEffect.material = .underWindowBackground
        visualEffect.blendingMode = .behindWindow
        visualEffect.state = .active
        visualEffect.autoresizingMask = [.width, .height]

        let tint = NSView()
        tint.autoresizingMask = [.width, .height]
        tint.wantsLayer = true

        container.addSubview(visualEffect)
        container.addSubview(tint)

        let bgWindow = NSWindow(
            contentRect: contentWindow.frame,
            styleMask: [.borderless],
            backing: .buffered,
            defer: false
        )
        bgWindow.isOpaque = false
        bgWindow.backgroundColor = .clear
        bgWindow.hasShadow = false
        bgWindow.contentView = container
        bgWindow.level = contentWindow.level
        bgWindow.alphaValue = storedOpacity

        contentWindow.isOpaque = false
        contentWindow.backgroundColor = .clear
        contentWindow.addChildWindow(bgWindow, ordered: .below)

        self.backgroundWindow = bgWindow
        self.visualEffectView = visualEffect
        self.tintView = tint

        updateMaterial(for: .light) // default, will be overridden by ContentView

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
    }

    func updateMaterial(for colorScheme: ColorScheme) {
        visualEffectView?.material = .underWindowBackground

        let tintColor: NSColor = colorScheme == .dark
            ? NSColor(white: 0.1, alpha: 0.6)
            : NSColor(white: 1.0, alpha: 0.45)
        tintView?.layer?.backgroundColor = tintColor.cgColor
    }
}
