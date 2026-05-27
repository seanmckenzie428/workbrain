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

        let container = NSView()
        container.wantsLayer = true
        container.layer?.cornerRadius = 10
        container.layer?.masksToBounds = true
        container.autoresizingMask = [.width, .height]

        let visualEffect = NSVisualEffectView()
        visualEffect.material = .underWindowBackground
        visualEffect.blendingMode = .behindWindow
        visualEffect.state = .active
        visualEffect.autoresizingMask = [.width, .height]

        // Subtle tint overlay — accent color at low opacity everywhere
        let tintView = NSView()
        tintView.wantsLayer = true
        tintView.layer?.backgroundColor = NSColor(red: 0.24, green: 0.71, blue: 0.30, alpha: 0.08).cgColor
        tintView.autoresizingMask = [.width, .height]

        // Subtle diagonal gradient for variation (not flat)
        let gradientView = GradientAccentView()
        gradientView.autoresizingMask = [.width, .height]

        container.addSubview(visualEffect)
        container.addSubview(tintView)
        container.addSubview(gradientView)

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
        updateFocusState(isFocused: !clickThrough)
    }

    private func updateFocusState(isFocused: Bool) {
        guard let visualEffect = backgroundWindow?.contentView?.subviews.first(where: { $0 is NSVisualEffectView }) as? NSVisualEffectView else { return }

        if isFocused {
            visualEffect.material = .fullScreenUI
            backgroundWindow?.alphaValue = storedOpacity * 0.85
        } else {
            visualEffect.material = .underPageBackground
            backgroundWindow?.alphaValue = storedOpacity
        }
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

// MARK: - Gradient Accent View

private class GradientAccentView: NSView {
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        wantsLayer = true
        setupGradient()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        wantsLayer = true
        setupGradient()
    }

    private func setupGradient() {
        let gradient = CAGradientLayer()
        gradient.colors = [
            NSColor(red: 0.24, green: 0.71, blue: 0.30, alpha: 0.18).cgColor,  // #3DB64C at 18%
            NSColor.clear.cgColor,
            NSColor(red: 0.24, green: 0.71, blue: 0.30, alpha: 0.10).cgColor   // #3DB64C at 10%
        ]
        gradient.locations = [0.0, 0.5, 1.0]
        gradient.startPoint = CGPoint(x: 0.0, y: 0.0)   // top-left
        gradient.endPoint = CGPoint(x: 1.0, y: 1.0)     // bottom-right
        gradient.frame = bounds
        gradient.autoresizingMask = [.layerWidthSizable, .layerHeightSizable]
        layer?.addSublayer(gradient)
    }
}