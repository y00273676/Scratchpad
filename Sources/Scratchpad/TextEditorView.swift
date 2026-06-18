import SwiftUI
import AppKit

private final class FocusableTextView: NSTextView {
    var onFocusChange: ((Bool) -> Void)?

    override func viewDidMoveToWindow() {
        super.viewDidMoveToWindow()
        guard let window, window.isKeyWindow else { return }
        DispatchQueue.main.async {
            window.makeFirstResponder(self)
        }
    }

    override func becomeFirstResponder() -> Bool {
        let became = super.becomeFirstResponder()
        if became { onFocusChange?(true) }
        return became
    }

    override func resignFirstResponder() -> Bool {
        let resigned = super.resignFirstResponder()
        if resigned { onFocusChange?(false) }
        return resigned
    }
}

struct TextEditorView: NSViewRepresentable {
    @Binding var text: String
    @Binding var isEditing: Bool

    func makeNSView(context: Context) -> NSScrollView {
        let scrollView = NSScrollView()
        scrollView.hasVerticalScroller = true
        scrollView.hasHorizontalScroller = false
        scrollView.autohidesScrollers = true
        scrollView.drawsBackground = false
        scrollView.borderType = .noBorder

        let textView = FocusableTextView()
        textView.isRichText = false
        textView.isEditable = true
        textView.isSelectable = true
        textView.allowsUndo = true
        textView.drawsBackground = false
        textView.isVerticallyResizable = true
        textView.isHorizontallyResizable = false
        textView.autoresizingMask = [.width]

        textView.font = NSFont.systemFont(ofSize: 14, weight: .regular)
        textView.textColor = NSColor(srgbRed: 0.75, green: 0.75, blue: 0.78, alpha: 1.0)
        textView.insertionPointColor = NSColor(srgbRed: 0.55, green: 0.55, blue: 0.60, alpha: 1.0)
        textView.textContainerInset = NSMakeSize(16, 20)

        textView.textContainer?.widthTracksTextView = true
        textView.textContainer?.containerSize = NSMakeSize(
            scrollView.contentSize.width, CGFloat.greatestFiniteMagnitude
        )
        textView.textContainer?.heightTracksTextView = false

        textView.isAutomaticSpellingCorrectionEnabled = false
        textView.isAutomaticQuoteSubstitutionEnabled = false
        textView.isAutomaticDashSubstitutionEnabled = false

        textView.delegate = context.coordinator
        textView.onFocusChange = { [coordinator = context.coordinator] focused in
            Task { @MainActor in
                coordinator.setEditing(focused)
            }
        }
        context.coordinator.textView = textView
        textView.string = text

        scrollView.documentView = textView

        return scrollView
    }

    func updateNSView(_ scrollView: NSScrollView, context: Context) {
        guard let textView = scrollView.documentView as? NSTextView else { return }
        if textView.string != text {
            let selections = textView.selectedRanges
            if let _ = textView.string.range(of: text) {
                textView.string = text
                textView.selectedRanges = selections
            } else {
                textView.string = text
            }
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

    @MainActor
    final class Coordinator: NSObject, NSTextViewDelegate {
        let parent: TextEditorView
        weak var textView: NSTextView?

        init(parent: TextEditorView) {
            self.parent = parent
        }

        func setEditing(_ focused: Bool) {
            parent.isEditing = focused
        }

        func textDidChange(_ notification: Notification) {
            guard let textView = notification.object as? NSTextView else { return }
            parent.text = textView.string
        }
    }
}
