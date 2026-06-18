import SwiftUI
import AppKit

@main
struct ScratchpadApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @AppStorage(AppStorageKey.autoSaveFromClipboard) private var autoSaveFromClipboard = true

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .windowStyle(.hiddenTitleBar)
        .defaultSize(width: 640, height: 440)
        .commands {
            CommandGroup(replacing: .newItem) { }
            CommandGroup(replacing: .saveItem) { }
            CommandGroup(after: .pasteboard) {
                Toggle("Auto Save From Clipboard", isOn: $autoSaveFromClipboard)
            }
        }
    }
}

class AppDelegate: NSObject, NSApplicationDelegate, NSWindowDelegate {
    func applicationDidFinishLaunching(_ notification: Notification) {
        NSApp.setActivationPolicy(.regular)
        NSApp.activate(ignoringOtherApps: true)

        DispatchQueue.main.async {
            guard let window = NSApp.windows.first else { return }
            self.configureWindow(window)
            WindowTitleBar.install(on: window)
        }
    }

    @MainActor
    private func configureWindow(_ window: NSWindow) {
        window.delegate = self
        window.titleVisibility = .hidden
        window.titlebarAppearsTransparent = true
        window.styleMask.insert(.fullSizeContentView)
        window.isMovableByWindowBackground = true
        window.isOpaque = true
        window.hasShadow = true
        window.backgroundColor = NSColor(srgbRed: 0.08, green: 0.08, blue: 0.09, alpha: 1.0)

        let closeBtn = window.standardWindowButton(.closeButton)
        let miniBtn = window.standardWindowButton(.miniaturizeButton)
        let zoomBtn = window.standardWindowButton(.zoomButton)
        [closeBtn, miniBtn, zoomBtn].forEach { $0?.isHidden = false }
    }

    @MainActor
    func windowDidBecomeKey(_ notification: Notification) {
        guard let window = notification.object as? NSWindow else { return }
        WindowTitleBar.install(on: window)
        if let editor = findTextView(in: window.contentView) {
            window.makeFirstResponder(editor)
        }
        NotificationCenter.default.post(name: .scratchpadShouldSyncClipboard, object: nil)
    }

    @MainActor private func findTextView(in view: NSView?) -> NSTextView? {
        guard let view = view else { return nil }
        if let textView = view as? NSTextView { return textView }
        for subview in view.subviews {
            if let found = findTextView(in: subview) { return found }
        }
        return nil
    }

    @MainActor
    func windowWillClose(_ notification: Notification) {
        guard let window = notification.object as? NSWindow else { return }
        WindowTitleBar.uninstall(from: window)
    }

    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        true
    }
}
