# Changelog

## 0.6.8-beta

### New: tmux inside docker containers

- Initia now also reads the tmux sessions running **inside** each docker container on a machine (this Mac or over SSH). They appear under the machine as "🐳 container" with their sessions, on Home, and on the machine page, with live previews and Claude detection
- Open one and Initia runs `docker exec -it <container> tmux attach -t <session>` in its own terminal. Notifications, Exit, rename and the other session actions work the same way
- Container tmux is checked every 15 seconds over the machine's existing SSH session, so it adds no logins

### Changes

- **Clearer close actions**, each named after what it does: **Close window (Ctrl-b d)** closes only Initia's tab and keeps the tmux session running, **Quit Claude (/exit)** ends only Claude, and **End tmux session…** ends the session (quitting Claude with /exit first). There is no longer a one-click default, so nothing ends by accident
- Container buttons show the exact command: **docker exec** opens a shell without tmux, **tmux + docker exec** starts a tmux session on the machine that enters the container

## 0.6.7-beta

### New: Claude usage limit

- Initia notices when Claude stops at its usage limit ("Usage limit reached · limit resets 8:50pm") and shows a ⚠ **Limit** badge with the reset time on the session's card, sidebar row, tab and window card
- You get one notification when a session hits the limit ("Claude hit its usage limit · Resets at 8:50pm") instead of a "Claude finished" one, and the Home summary counts sessions at the limit
- Works on this Mac, on SSH machines and inside docker containers

## 0.6.6-beta

### New: docker containers

- **Claude inside docker is detected.** When a tmux pane runs `docker exec` into a container, Claude's processes are not under the pane, so Initia now also recognizes Claude from its window title and screen. Working/waiting, notifications and Exit work as usual
- **Sessions and presets can enter a container.** Pick a running container (or type its name) in New session or a preset: tmux stays on the machine and Initia runs `docker exec -it -w <folder> <container> bash -lc '<command>; exec bash -l'` for you
- Machine pages list running containers with **New session** and **Shell** buttons, and session cards, rows and window cards show the container a session is in (🐳)

### New

- Sessions started with `happy claude` show a **Happy** badge. In Happy's remote mode, where Claude's screen is hidden, the badge says so
- "Device" is now "Machine" in the session and preset forms, and crowded session cards shrink the status chip to an icon

## 0.6.5-beta

### Changes

- **Machines.** The sidebar now has one Machines section: this Mac and your SSH machines side by side. Expand a machine to see its tmux sessions; click the machine itself for its page (open a shell, start a session, and for SSH machines, connection and config). This Mac gets its own machine page too
- The sidebar no longer uses the system disclosure control, which could misdraw selection and indentation; sessions under a machine are indented and no longer repeat the machine name
- **Sessions open in Initia by default** everywhere, including a preset's Open and "Open a specific window". External terminals stay one click away under their own names. Existing settings are switched to Initia once
- README: why Initia exists, and new screenshots

## 0.6.4-beta

### Fixes

- **SSH to a Mac: tmux sessions now show up.** macOS's SSH server starts sessions without a language setting, and in that case tmux replaces tabs and non-ASCII text with "_" in its output, so Initia couldn't read the session list. Initia now runs tmux with `-u` (UTF-8 output) on every host, which also keeps Korean and box-drawing characters intact when you attach to a remote session

## 0.6.3-beta

### Fixes

- **SSH: Initia no longer logs in to your server every few seconds.** It now keeps one SSH session open per host and streams the session list, Claude status and screen previews over it, so a login monitor (or Tailscale SSH's session log) sees a single login while Initia is connected. Before, every refresh and every preview was a new SSH command, and on Macs where connection sharing failed (see below) each one was a full new login
- **SSH: fixed "path … too long for Unix domain socket".** Connection sharing failed on Macs with a long user name, which broke password logins (for example from a MacBook to another Mac) and forced a new login for every request. Initia now uses a short per-host socket name, and falls back to a private folder in /tmp when the home folder path is too long
- Smart Exit sends its keys to a remote host in one SSH command and waits on the streamed status instead of polling

## 0.6.2-beta

### Fixes

- **Claude finished notifications now work inside tmux.** Current Claude Code keeps its window title fixed (starting with ✳) when it runs in tmux, so Initia could not tell when it was working and rarely sent a notification. Initia now reads the bottom of each Claude pane and treats Claude as working while it shows "esc to interrupt". Checked end to end on a real remote server: working → finished → notification → Exit
- Claude is now detected when its process is named `claude.exe` (recent npm installs on Linux), not only `claude`

## 0.6.1-beta

### Changes

- New installs start with an `example` preset (Claude Code in your home folder)

### Fixes

- **SSH: connecting no longer closes right away when a host can't be reached.** Before, if Initia couldn't connect with your SSH key for any reason (Tailscale off, address not found, network unreachable), it opened a login tab that closed at once. Now a login tab opens only when the host needs a password or a host-key confirmation; otherwise you see the actual error
- SSH terminal tabs stay open after the connection ends, showing the last output and exit code, with **Reconnect** and **Close** buttons

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
