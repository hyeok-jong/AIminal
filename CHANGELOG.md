# Changelog

## 0.5.0-beta

### New: built-in terminal

- Initia is now a terminal too. Select a session and it opens in a real terminal inside the app (powered by [SwiftTerm](https://github.com/migueldeicaza/SwiftTerm)): full keyboard input, colors, mouse and resizing, so TUIs like Claude Code work as they do in iTerm2
- Every session you open gets a tab at the top of the window. Closing a tab only detaches; the tmux session keeps running
- Switch between **Terminal** and **Overview** (live previews of every window) per session
- New settings: where clicking a session opens it (Initia or your default terminal), and the terminal font size
- External terminals (iTerm2, Terminal, cmux and others) are still one click away

### Fixes

- Fixed iTerm2 failing to open sessions with an AppleScript error ("Expected end of line but found class name"). Initia now targets iTerm2 and Terminal by bundle identifier instead of app name.

## 0.4.0-beta

First public beta of Initia, a macOS menu bar and Dock app for working with tmux sessions.

### Highlights

- **Session browser**: every tmux session with its attach state, folder, running command, pane title (for example, what Claude Code is working on), and last activity
- **Live preview**: the terminal contents of each window, refreshed every 2 seconds
- **Open anywhere**: open a session, or one specific window, in iTerm2, Terminal, cmux, Ghostty, WezTerm, kitty or Alacritty
- **Manage tmux**: create sessions from a folder; rename sessions and windows (double-click a name); create and close windows; kill sessions
- **Presets**: save a folder and a startup command, then start it in one click or automatically at login
- **Menu bar popover** for quick access, plus a full window with a sidebar
- English and Korean UI (Settings → General → Language)

### Requirements

- macOS 15 or later, Apple Silicon or Intel
- tmux (`brew install tmux`)

### Known limitations

- The app is not notarized by Apple yet. The install script handles this for you; for a manual install, see the README.
- cmux blocks outside apps by default. See the README for how to allow Initia.
