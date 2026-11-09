# Changelog

## 0.6.0-beta

### New: Home

- Initia now opens on a **Home** screen: a summary of your tmux sessions, windows, Claude sessions and background sessions, then a card for every session with a live preview, plus Quick start cards for presets that aren't running
- Every session shows where it is open: in Initia (green), in another terminal (blue), or only in the background (gray)
- **Claude Code detection**: Initia finds Claude in each tmux window (also over SSH) and shows whether it is working or waiting for you

### New: Claude notifications

- Get a macOS notification when Claude finishes working in a session you aren't looking at, with the task name. Click it to jump straight to that session
- Finished sessions you haven't viewed yet get a bell on their tab, sidebar row and card, and the Dock icon shows how many there are
- Turn notifications or their sound off in Settings → General

### New: automatic updates

- Initia checks for new versions (every 6 hours) and shows an **Update** button at the bottom of the sidebar. One click downloads the release, verifies its checksum, replaces the app and restarts it
- Your tmux sessions keep running through the update, and the tabs you had open come back
- Settings → General → Updates: check now, turn automatic checks off, or skip beta versions. Also in the app menu: Initia → Check for Updates…

### New: SSH hosts

- The sidebar lists the hosts from `~/.ssh/config`. Connect to one to see and open its tmux sessions, with previews and Claude detection
- Works with key and password logins: if a host needs a password, you type it once in a terminal tab and Initia reuses that connection
- Add, rename, edit and delete hosts in the app. Initia only changes the lines you edit, keeps your comments and other options, and backs up the previous file to `~/.ssh/config.initia-backup`
- Presets can now start sessions on an SSH host

### New: terminals without tmux

- Open a plain terminal (⌘T), locally or on an SSH host. New sessions still use tmux by default

### New: Exit and snippets

- **Exit** quits Claude with `/exit`, waits for it to finish, then ends the session. The menu next to it has "Quit Claude only", "Detach" and "Kill session"
- **Snippets**: a row of buttons under the terminal that types text for you (`/clear`, `/compact`, `continue`, Esc by default). Edit them or add your own

### Changes

- Selecting a session always shows its terminal first. Detaching shows a Reconnect button instead of switching to Overview
- Closing a tab moves to the next tab, or back to Home

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
