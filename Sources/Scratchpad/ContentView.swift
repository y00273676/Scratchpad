import SwiftUI

struct ContentView: View {
    @State private var text: String = ""
    @State private var isEditing: Bool = false

    var body: some View {
        TextEditorView(text: $text, isEditing: $isEditing)
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
    }
}

#Preview {
    ContentView()
}
