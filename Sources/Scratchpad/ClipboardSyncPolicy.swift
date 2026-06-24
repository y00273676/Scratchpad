import Foundation

enum ClipboardSyncDecision: Equatable {
    case alreadySynced
    case apply
    case skipUserContent
}

enum ClipboardSyncPolicy {
    /// Whether clipboard text should replace the editor contents.
    ///
    /// - Empty editor: always apply (scratchpad is ready for new clipboard content).
    /// - User is typing (focused): never overwrite.
    /// - User has edited since the last clipboard apply: never overwrite.
    /// - Otherwise: content still mirrors the last clipboard apply; safe to update.
    static func shouldApply(
        clipboardText: String,
        editorText: String,
        isEditing: Bool,
        hasUserModifiedContent: Bool
    ) -> ClipboardSyncDecision {
        if clipboardText == editorText {
            return .alreadySynced
        }
        if editorText.isEmpty {
            return .apply
        }
        if isEditing || hasUserModifiedContent {
            return .skipUserContent
        }
        return .apply
    }
}
