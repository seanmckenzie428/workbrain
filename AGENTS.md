# WorkBrain - AI Documentation

## Project Overview

**WorkBrain** is a native macOS daily notes application built in Swift. It provides a single-window utility for capturing daily thoughts, tasks, and notes. Features include always-on-top pinning, adjustable transparency, and a modern liquid glass aesthetic.

**Development Model**: AI-first development. All code is written by AI agents based on user prompts and feedback. Human does not touch code directly.

**Commit Convention**: Use caveman-commit style. Conventional Commits format, subject ≤50 chars, body only when why isn't obvious. Commit incrementally as changes are made so we can roll back.

## Technical Requirements

### Platform
- **Target**: macOS (native Mac app)
- **Minimum Version**: macOS 14.0 (Sonoma) or latest available
- **Language**: Swift 5.9+
- **UI Framework**: SwiftUI (preferred) or AppKit where SwiftUI limitations exist

### Core Features

1. **Daily Notes System**
   - One note per day
   - Automatic note creation at start of day
   - Template-based note initialization (user-editable template)
   - Full text editing throughout the day

2. **Day Selector**
   - Calendar/date picker to select any day
   - Current day selected by default
   - Navigate to previous days for review
   - Visual indicator for days with existing notes

3. **Text Editor**
   - Markdown-based editing
   - Real-time auto-save
   - Clean, distraction-free editing experience
   - Optional live preview (future enhancement)

4. **Always-on-Top Pinning**
   - Button to toggle window pinning
   - Window stays above all other windows when pinned
   - Visual indicator for pinned state

5. **Transparency Support**
   - Adjustable window transparency/opacity
   - Slider or control for opacity adjustment
   - Real-time preview of transparency changes

6. **Liquid Glass Aesthetic**
   - Modern, frosted glass appearance
   - Use `material` modifiers (`.ultraThinMaterial`, `.thinMaterial`, etc.)
   - Subtle shadows and rounded corners
   - Clean, minimalist design language

## Coding Standards & Best Practices

### General Principles
- **Clean Code**: Readable, maintainable, well-organized
- **Swift Conventions**: Follow Swift API Design Guidelines
- **Documentation**: Inline comments for complex logic
- **Error Handling**: Proper error handling with Result types or throws
- **State Management**: Use `@State`, `@ObservedObject`, `@StateObject` appropriately

### Architecture
- **MVVM Pattern**: Preferred for SwiftUI apps
- **Separation of Concerns**: Views, ViewModels, Models separated
- **Dependency Injection**: For testability and flexibility
- **SwiftData**: Use for all data persistence

### Code Quality
- No force unwrapping (`!`) unless absolutely necessary
- Use optionals and guard statements properly
- Avoid magic numbers - use named constants
- Consistent naming conventions (camelCase for vars/funcs, PascalCase for types)

### Project Structure
```
WorkBrain/
├── WorkBrainApp.swift          # App entry point, SwiftData setup
├── Models/
│   ├── DailyNote.swift         # SwiftData model for notes
│   └── NoteTemplate.swift      # SwiftData model for template
├── ViewModels/
│   └── MainViewModel.swift     # Business logic, day selection, note management
├── Views/
│   ├── ContentView.swift       # Main window layout
│   ├── DaySelector.swift       # Date picker/calendar view
│   ├── NoteEditor.swift        # Text editing view
│   ├── PinButton.swift         # Pin toggle button
│   └── TransparencySlider.swift # Opacity control
├── Utilities/
│   ├── WindowUtils.swift       # Window manipulation helpers
│   └── DateUtils.swift         # Date handling utilities
└── Resources/
    └── Assets.xcassets         # App assets
```

## Implementation Notes

### Window Pinning (Always-on-Top)
```swift
// Use NSWindow collection behavior
window.collectionBehavior.insert(.fullScreenAuxiliary)
window.level = .floating  // For always-on-top
```

### Transparency
```swift
// Window opacity
window.alphaValue = 0.8  // 0.0 to 1.0

// Material effects
.background(.ultraThinMaterial)
```

### SwiftData Models
```swift
@Model
final class DailyNote {
    var id: UUID
    var date: Date           // The date this note represents (midnight UTC)
    var content: String      // Markdown content
    var createdAt: Date      // When note was first created
    var updatedAt: Date      // Last modification time
    
    init(date: Date, content: String = "")
}

@Model
final class NoteTemplate {
    var id: UUID
    var content: String      // Markdown template content
    var updatedAt: Date      // Last template modification
    
    init(content: String)
}
```

### Auto-Save Pattern
```swift
// Use onChange or task modifier to trigger saves
.onChange(of: noteContent) { oldValue, newValue in
    saveNote()
}
```

### Liquid Glass Effect
- Combine `.background(.ultraThinMaterial)` with custom opacity
- Use `.shadow()` for depth
- Rounded corners with `.cornerRadius()`
- Consider `.blurEffect()` for additional glass effect

## Agent Workflow

1. **Read AGENTS.md** before any code changes
2. **Understand current state** - read existing files
3. **Make incremental changes** - small, testable commits
4. **Follow existing patterns** - consistency is key
5. **Document new features** - update this file as needed
6. **Test thoroughly** - ensure no regressions

## Current Status

**Status**: Phase 1 - Not Started
**Last Updated**: 2026-05-27

### Phase 1: Project Setup
- [ ] Create Xcode project structure
- [ ] Set up SwiftData container and models
- [ ] Configure minimum macOS version
- [ ] Add app entitlements for file access if needed

### Phase 2: Data Layer
- [ ] Create DailyNote SwiftData model
- [ ] Create NoteTemplate SwiftData model
- [ ] Implement CRUD operations for notes
  - [ ] Create note
  - [ ] Read note by date
  - [ ] Update note content
  - [ ] Delete note (if needed)
- [ ] Implement template management
  - [ ] Load template
  - [ ] Save template
  - [ ] Reset to default template
- [ ] Add data migration support for future schema changes

### Phase 3: Core UI
- [ ] Implement main window layout
  - [ ] Define window size constraints
  - [ ] Set up layout hierarchy
- [ ] Build day selector component
  - [ ] Date picker or calendar view
  - [ ] Highlight current day
  - [ ] Show indicator for days with notes
  - [ ] Handle date selection changes
- [ ] Build text editor component
  - [ ] Multi-line text input
  - [ ] Markdown syntax support
  - [ ] Scroll support for long notes
  - [ ] Placeholder text when empty
  - [ ] Monospace font option (for markdown editing)
- [ ] Wire up note loading/saving
  - [ ] Load note when day selected
  - [ ] Auto-save on content change
  - [ ] Handle empty states (no note for day)

### Phase 4: Window Features
- [ ] Add window pinning functionality
  - [ ] Toggle button UI
  - [ ] Implement NSWindow.level = .floating
  - [ ] Persist pin state across launches
  - [ ] Visual feedback for pinned state
- [ ] Add transparency controls
  - [ ] Slider UI for opacity (0.0 - 1.0)
  - [ ] Apply to window alphaValue
  - [ ] Persist opacity preference
  - [ ] Default opacity value (e.g., 0.9)
- [ ] Apply liquid glass aesthetic
  - [ ] .ultraThinMaterial or .thinMaterial background
  - [ ] Rounded corners
  - [ ] Subtle shadows
  - [ ] Consistent spacing and padding

### Phase 5: Polish
- [ ] Auto-create note for new days
  - [ ] Detect when viewing day without note
  - [ ] Apply template automatically
  - [ ] Prompt user or auto-create (decide behavior)
- [ ] Refine UI/UX
  - [ ] Consistent spacing
  - [ ] Keyboard shortcuts
  - [ ] Focus management
- [ ] Add visual feedback for states
  - [ ] Saving indicator
  - [ ] Empty state messages
  - [ ] Hover states on buttons
- [ ] Test edge cases
  - [ ] Very long notes
  - [ ] Rapid switching between days
  - [ ] App termination during save
  - [ ] First launch (no data)

### Phase 6: Testing & Review
- [ ] Manual testing of all features
- [ ] Verify auto-save works correctly
- [ ] Test window pinning with other apps
- [ ] Verify transparency rendering
- [ ] Check SwiftData persistence across launches

## Key Files to Reference

| File | Purpose |
|------|---------|
| `AGENTS.md` | This documentation - READ FIRST |
| `WorkBrainApp.swift` | App entry point and lifecycle |
| `ContentView.swift` | Main UI layout |
| `MainViewModel.swift` | Business logic and state |

## Common Tasks

### Adding a New Feature
1. Update AGENTS.md with feature spec
2. Create/modify ViewModel
3. Create/modify View
4. Wire up bindings
5. Test functionality

### Fixing a Bug
1. Identify root cause
2. Write minimal fix
3. Verify no side effects
4. Document if pattern changes

## Contact Pattern

User provides: Prompts, feedback, feature requests
Agent provides: Code, explanations, progress updates

**Never** ask user to write or edit code directly.

---

## Detailed Specifications

### User Stories

| ID | Story | Acceptance Criteria |
|----|-------|---------------------|
| US-01 | As a user, I want a new note created automatically each day | Note is created with today's date when first accessed; template content is applied |
| US-02 | As a user, I want to edit my daily note throughout the day | Changes are auto-saved; no manual save required |
| US-03 | As a user, I want to view previous days' notes | Can select any past date; note content loads correctly |
| US-04 | As a user, I want to customize the note template | Can edit template; changes apply to future notes |
| US-05 | As a user, I want to keep the window always visible | Toggle button pins window above all others; visual indicator shows pinned state |
| US-06 | As a user, I want to adjust window transparency | Slider controls opacity; setting persists across launches |
| US-07 | As a user, I want a clean, modern interface | Liquid glass aesthetic; minimal distractions |

### Markdown Support

**Decision**: All notes are stored as Markdown.

**Rationale**:
- Portable and future-proof plain text format
- Easy to parse and render
- Supports rich formatting (headers, lists, code blocks, etc.)
- Compatible with external editors and tools
- Easy export/import and backup
- No vendor lock-in

**Implementation Options**:
1. **Plain text editor with Markdown syntax** (Phase 3 - initial)
   - Simple `TextEditor` with markdown hints
   - No live preview initially

2. **Live preview** (Future enhancement)
   - Split view: edit | preview
   - Use MarkdownUI or similar library

**Recommended Libraries** (for future enhancement):
- `MarkdownUI` - SwiftUI Markdown rendering
- `Ink` - Markdown parser by John Sundell
- `SwiftyMarkdown` - Alternative markdown parser

### Data Models (SwiftData)

#### DailyNote
```swift
@Model
final class DailyNote {
    var id: UUID
    var date: Date           // The date this note represents (midnight UTC)
    var content: String      // Markdown content
    var createdAt: Date      // When note was first created
    var updatedAt: Date      // Last modification time
    
    init(date: Date, content: String = "")
}
```

#### NoteTemplate
```swift
@Model
final class NoteTemplate {
    var id: UUID
    var content: String      // Markdown template content
    var updatedAt: Date      // Last template modification
    
    init(content: String)
}
```

**Default Template** (if none exists):
```markdown
# Daily Notes - [Date]

## Tasks
- [ ] 

## Notes


```

### UI Layout Specification

```
┌─────────────────────────────────────────────────────┐
│  WorkBrain                              [-][□][×]   │
├─────────────────────────────────────────────────────┤
│  ┌─────────────┐  ┌──────────────────────────────┐  │
│  │             │  │                              │  │
│  │   Day       │  │        Note Editor           │  │
│  │  Selector   │  │                              │  │
│  │             │  │   (multi-line text area)     │  │
│  │  [Calendar  │  │                              │  │
│  │   or Date   │  │                              │  │
│  │   Picker]   │  │                              │  │
│  │             │  │                              │  │
│  └─────────────┘  └──────────────────────────────┘  │
├─────────────────────────────────────────────────────┤
│  🔓 Pin    Opacity: [━━━━━●━━━━━]  90%             │
└─────────────────────────────────────────────────────┘
```

**Layout Details**:
- Window default size: 800x600 points
- Minimum size: 400x300 points
- Day selector: ~200pt width (collapsible on small windows)
- Editor: Remaining width
- Bottom bar: ~40pt height for controls

### Keyboard Shortcuts

| Shortcut | Action |
|----------|--------|
| Cmd+N | New note (today) |
| Cmd+P | Toggle pin |
| Cmd+, | Open settings (future) |
| Esc | Unpin window |

### Markdown Syntax Support

**Minimum Supported Syntax** (Phase 3):
- Headers (`#`, `##`, `###`)
- Bold (`**text**`)
- Italic (`*text*`)
- Lists (`-`, `*`, `1.`)
- Checkboxes (`- [ ]`, `- [x]`)
- Code blocks (``` ```, ``` ```swift ```)
- Links (`[text](url)`)

**Future Enhancements**:
- Tables
- Blockquotes
- Images
- Syntax highlighting in code blocks

### Edge Cases to Handle

1. **No note exists for selected date**
   - Auto-create with template content
   - Or show "No note - click to create" prompt

2. **Multiple rapid date changes**
   - Ensure saves complete before switching
   - Use debouncing for auto-save

3. **App terminates during save**
   - SwiftData handles transactions atomically
   - Verify data integrity on next launch

4. **System date changes**
   - Handle timezone changes gracefully
   - Store dates in UTC, display in local time

5. **Very long notes**
   - Editor scrolls properly
   - No performance degradation

6. **First launch**
   - Create default template
   - Show today's note (empty or templated)

### Persistence Requirements

- All data stored via SwiftData
- Window pin state: UserDefaults or AppStorage
- Opacity preference: UserDefaults or AppStorage
- Last selected date: UserDefaults (restore on launch)

### Performance Requirements

- Note load time: < 100ms
- Auto-save trigger: 500ms after last keystroke (debounced)
- UI responsiveness: 60fps during scrolling
- App launch time: < 2 seconds
