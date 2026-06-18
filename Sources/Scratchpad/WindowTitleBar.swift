import AppKit
import SwiftUI

enum WindowTitleBar {
    @MainActor private static var savedFrames: [ObjectIdentifier: NSRect] = [:]
    @MainActor private static var handlers: [ObjectIdentifier: WindowEventHandler] = [:]

    private static let titleBarHeight: CGFloat = 38
    private static let trafficLightWidth: CGFloat = 78

    @MainActor
    static func install(on window: NSWindow) {
        let key = ObjectIdentifier(window)
        if handlers[key] == nil {
            handlers[key] = WindowEventHandler(window: window)
        }
    }

    @MainActor
    static func uninstall(from window: NSWindow) {
        let key = ObjectIdentifier(window)
        handlers[key]?.remove()
        handlers.removeValue(forKey: key)
        savedFrames.removeValue(forKey: key)
    }

    @MainActor
    static func toggleMaximize(_ window: NSWindow) {
        guard let screen = window.screen else { return }
        let maximizedFrame = screen.visibleFrame
        let key = ObjectIdentifier(window)

        if isFrameMaximized(window.frame, comparedTo: maximizedFrame),
           let saved = savedFrames[key] {
            window.setFrame(saved, display: true, animate: true)
            savedFrames.removeValue(forKey: key)
        } else {
            savedFrames[key] = window.frame
            window.setFrame(maximizedFrame, display: true, animate: true)
        }
    }

    @MainActor
    fileprivate static func isInTitleBar(_ location: NSPoint, window: NSWindow) -> Bool {
        guard let contentView = window.contentView else { return false }
        let top = contentView.bounds.height
        return location.y >= top - titleBarHeight &&
            location.x >= trafficLightWidth
    }

    private static func isFrameMaximized(_ frame: NSRect, comparedTo target: NSRect) -> Bool {
        abs(frame.origin.x - target.origin.x) < 2 &&
        abs(frame.origin.y - target.origin.y) < 2 &&
        abs(frame.width - target.width) < 2 &&
        abs(frame.height - target.height) < 2
    }
}

@MainActor
private final class WindowEventHandler {
    private weak var window: NSWindow?
    private nonisolated(unsafe) var monitor: Any?

    init(window: NSWindow) {
        self.window = window
        monitor = NSEvent.addLocalMonitorForEvents(matching: .leftMouseDown) { event in
            guard let window = self.window, event.window === window else { return event }
            let location = event.locationInWindow
            guard WindowTitleBar.isInTitleBar(location, window: window) else { return event }

            if event.clickCount >= 2 {
                WindowTitleBar.toggleMaximize(window)
                return nil
            }

            return event
        }
    }

    func remove() {
        if let monitor {
            NSEvent.removeMonitor(monitor)
            self.monitor = nil
        }
    }
}

struct WindowTitleBarInstaller: NSViewRepresentable {
    func makeNSView(context: Context) -> NSView {
        NSView(frame: .zero)
    }

    func updateNSView(_ nsView: NSView, context: Context) {
        guard let window = nsView.window else { return }
        Task { @MainActor in
            WindowTitleBar.install(on: window)
        }
    }
}
