import AppKit

enum ClipboardReader {
    static func latestString(from pasteboard: NSPasteboard = .general) -> String? {
        if let string = pasteboard.string(forType: .string), !string.isEmpty {
            return string
        }
        for item in pasteboard.pasteboardItems ?? [] {
            if let string = item.string(forType: .string), !string.isEmpty {
                return string
            }
        }
        return nil
    }
}

extension Notification.Name {
    static let scratchpadShouldSyncClipboard = Notification.Name("ScratchpadShouldSyncClipboard")
}
