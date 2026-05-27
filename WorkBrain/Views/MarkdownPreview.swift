import SwiftUI

struct MarkdownPreview: View {
    let content: String

    private var lines: [String] {
        content.components(separatedBy: .newlines)
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 2) {
                ForEach(Array(lines.enumerated()), id: \.offset) { _, line in
                    renderLine(line)
                }
            }
            .padding(12)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }

    @ViewBuilder
    private func renderLine(_ line: String) -> some View {
        let trimmed = line.trimmingCharacters(in: .whitespaces)

        if trimmed.hasPrefix("# ") {
            Text(String(trimmed.dropFirst(2)))
                .font(.title2)
                .fontWeight(.bold)
                .padding(.top, 8)
        } else if trimmed.hasPrefix("## ") {
            Text(String(trimmed.dropFirst(3)))
                .font(.title3)
                .fontWeight(.bold)
                .padding(.top, 6)
        } else if trimmed.hasPrefix("### ") {
            Text(String(trimmed.dropFirst(4)))
                .font(.headline)
                .fontWeight(.bold)
                .padding(.top, 4)
        } else if trimmed.hasPrefix("- [ ] ") {
            Text("☐ " + String(trimmed.dropFirst(6)))
        } else if trimmed.hasPrefix("- [x] ") || trimmed.hasPrefix("- [X] ") {
            Text("☑ " + String(trimmed.dropFirst(6)))
        } else if trimmed.hasPrefix("- ") {
            Text("• " + String(trimmed.dropFirst(2)))
        } else if trimmed.isEmpty {
            Text(" ")
                .font(.system(size: 4))
        } else {
            Text(trimmed)
        }
    }
}