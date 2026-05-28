# WorkBrain

A native macOS daily notes app with a frosted glass aesthetic. One note per weekday. Auto-saves. Pins on top. Fades when you're not using it.

---

## What It Does

WorkBrain gives you a single, always-visible window for your daily work notes. It's designed to sit on the edge of your screen — pinned above other apps — so you can glance at your goals and tasks without switching contexts.

---

## Core Features

### Daily Notes

- **One note per weekday** — Monday through Friday only. Weekends are skipped so you don't end up with empty notes.
- **Auto-created every morning** — The first time you open the app each day, a new note is created automatically with your template.
- **Auto-saved** — Every keystroke is saved after a 500ms debounce. No manual save needed.

### Template

Every new note starts from a template:

```markdown
# 2026-05-27

## Goals

## First tiny step

## When lost, return to

## Notes

## Completed
```

The date auto-populates. You can edit past notes but not delete them.

---

## The Weekday Bar

A horizontal strip of 4 day pills sits at the top:

- **Today** is always on the right
- **3 preceding weekdays** are to the left
- Weekends are skipped entirely
- Click any pill to jump to that day
- Click the calendar icon on the far left to open a full month picker

In the calendar picker:
- Weekdays are fully visible
- Weekends are grayed out
- Today gets a blue outline
- The selected day gets a blue fill

---

## Two Modes: Edit and Preview

WorkBrain has two modes that switch automatically based on focus.

### Edit Mode (Focused)

When WorkBrain is the active app:
- Full UI visible — day bar, text editor, bottom controls
- Window is nearly opaque (98%) for easy reading
- Text editor shows raw markdown
- Fully interactive

### Preview Mode (Unfocused)

When you click on another app:
- Day bar and bottom controls hide automatically
- Only the rendered markdown preview remains
- Window fades to your chosen opacity level
- Clicks pass through to the app behind (click-through)
- Text stays sharp and readable

This means you can keep WorkBrain pinned on top while working in another app — you'll see your formatted notes floating above, but you can still click through to the app underneath.

---

## Bottom Controls

| Icon | What It Does |
|------|-------------|
| 📌 | **Pin on top** — Window stays above all other apps |
| 🖐 | **Click-through** — Manual toggle (also auto-triggers on focus loss) |
| ◐ | **Opacity slider** — Controls transparency in preview mode (10%–100%) |
| ☀/🌙 | **Theme** — System, Light, or Dark mode |

---

## Keyboard Shortcuts

| Shortcut | Action |
|----------|--------|
| `Cmd+P` | Pin / unpin window |
| `Cmd+T` | Toggle click-through manually |

---

## Focus Behavior

The app intelligently switches between modes:

1. **Click on WorkBrain** → Edit mode, full opacity, chrome visible
2. **Click on another app** → Preview mode, chrome hides, click-through ON
3. **Click back on WorkBrain** → Edit mode restored

This happens automatically. No manual switching needed.

---

## Visual Design

- **Frosted glass background** — NSVisualEffectView with subtle green tint (`#3DB64C`)
- **Dual window architecture** — Background blur layer + content layer so text stays sharp while the glass fades
- **Rounded corners** — 10pt radius on the window
- **Traffic lights hidden in preview** — Clean, minimal appearance when not editing

---

## Data & Privacy

- All data stored via **SwiftData** (Apple's native persistence)
- Data lives in the app sandbox — no external file access
- No network calls, no telemetry, no accounts

---

## Preferences

These settings persist across app restarts:

- **Opacity** — Your preferred transparency level
- **Theme** — System, Light, or Dark

---

## Tech Stack

- **Language**: Swift 6
- **UI**: SwiftUI
- **Data**: SwiftData
- **Architecture**: MVVM
- **macOS**: 26.0+
- **Project**: Generated via [xcodegen](https://github.com/yonaskolb/XcodeGen)

---

## Development Model

AI-first. All code written by AI agents. Human provides prompts and feedback. No hand-edited code.

---

## License

MIT
