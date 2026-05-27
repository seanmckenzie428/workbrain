import Foundation
import SwiftData

@Model
final class NoteTemplate {
    var id: UUID
    var content: String      // Markdown template content
    var updatedAt: Date

    init(content: String) {
        self.id = UUID()
        self.content = content
        self.updatedAt = Date()
    }

    /// Default template applied to every new daily note.
    static var `default`: String {
        """
        ## Tasks
        - [ ] 

        ## Notes

        """
    }
}