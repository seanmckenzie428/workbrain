import SwiftUI

struct NoteEditor: View {
    @Binding var content: String
    let date: Date

    var body: some View {
        TextEditor(text: $content)
            .font(.system(.body, design: .monospaced))
            .scrollContentBackground(.hidden)
            .background(.clear)
            .padding(12)
    }
}