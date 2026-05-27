import SwiftUI

struct MarkdownPreview: View {
    let content: String

    private var attributedContent: AttributedString {
        do {
            return try AttributedString(
                markdown: content,
                options: AttributedString.MarkdownParsingOptions(
                    interpretedSyntax: .full
                )
            )
        } catch {
            return AttributedString(content)
        }
    }

    var body: some View {
        ScrollView {
            Text(attributedContent)
                .textSelection(.enabled)
                .padding(12)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}