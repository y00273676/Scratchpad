import SwiftUI
import AppKit

struct ContentView: View {
    @AppStorage(AppStorageKey.autoSaveFromClipboard) private var autoSaveFromClipboard = true
    @State private var text: String = ""
    @State private var isEditing: Bool = false
    @State private var hasUserModifiedContent = false
    @State private var suppressUserEditTracking = false
    @State private var lastAppliedClipboardChangeCount = -1

    var body: some View {
        TextEditorView(
            text: $text,
            isEditing: $isEditing,
            suppressUserEditTracking: $suppressUserEditTracking,
            onUserEdit: { hasUserModifiedContent = true }
        )
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background {
                WindowTitleBarInstaller()
            }
            .overlay(alignment: .topLeading) {
                if text.isEmpty && !isEditing {
                    Text("在这里随便记录东西...")
                        .font(.system(size: 14, weight: .regular))
                        .foregroundColor(Color(red: 0.35, green: 0.35, blue: 0.38))
                        .padding(.top, 20)
                        .padding(.leading, 16)
                        .allowsHitTesting(false)
                }
            }
            .onAppear {
                syncClipboardFromPasteboard(force: true)
            }
            .onReceive(
                NotificationCenter.default.publisher(for: .scratchpadShouldSyncClipboard)
            ) { _ in
                syncClipboardFromPasteboard(force: true)
            }
            .onReceive(
                NotificationCenter.default.publisher(for: NSApplication.didBecomeActiveNotification)
            ) { _ in
                syncClipboardFromPasteboard(force: true)
            }
            .task(id: autoSaveFromClipboard) {
                guard autoSaveFromClipboard else { return }
                try? await Task.sleep(for: .milliseconds(200))
                syncClipboardFromPasteboard(force: true)
                while !Task.isCancelled {
                    try? await Task.sleep(for: .milliseconds(500))
                    guard !Task.isCancelled else { return }
                    syncClipboardFromPasteboard()
                }
            }
    }

    private func syncClipboardFromPasteboard(force: Bool = false) {
        guard autoSaveFromClipboard else { return }

        let pasteboard = NSPasteboard.general
        let changeCount = pasteboard.changeCount
        if !force, changeCount == lastAppliedClipboardChangeCount { return }

        guard let clipText = ClipboardReader.latestString(from: pasteboard) else { return }

        switch ClipboardSyncPolicy.shouldApply(
            clipboardText: clipText,
            editorText: text,
            isEditing: isEditing,
            hasUserModifiedContent: hasUserModifiedContent
        ) {
        case .alreadySynced:
            lastAppliedClipboardChangeCount = changeCount
        case .apply:
            applyClipboard(clipText, changeCount: changeCount)
        case .skipUserContent:
            break
        }
    }

    private func applyClipboard(_ clipText: String, changeCount: Int) {
        suppressUserEditTracking = true
        hasUserModifiedContent = false
        lastAppliedClipboardChangeCount = changeCount
        text = clipText
        DispatchQueue.main.async {
            suppressUserEditTracking = false
        }
    }
}

#Preview {
    ContentView()
}
