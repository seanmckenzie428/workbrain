import SwiftUI

struct NoteEditor: View {
    @Binding var content: String
    let date: Date

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(DateUtils.isoDateString(date))
                .font(.caption)
                .foregroundStyle(.secondary)
                .padding(.horizontal, 12)
                .padding(.top, 8)

            TextEditor(text: $content)
                .font(.system(.body, design: .monospaced))
                .scrollContentBackground(.hidden)
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
        }
    }
}