# Initia Guide

Initia is a home for your tmux sessions: on this Mac, on your servers over SSH, and inside docker containers on those servers. This guide walks through everything it does. For a quick overview, see the [README](README.md). 한국어: [GUIDE.ko.md](GUIDE.ko.md).

- [Install and update](#install-and-update)
- [The big picture](#the-big-picture)
- [Home](#home)
- [The sidebar](#the-sidebar)
- [Working in a session](#working-in-a-session)
- [File tree](#file-tree)
- [Editing files](#editing-files)
- [Side by side](#side-by-side)
- [Starting sessions and presets](#starting-sessions-and-presets)
- [Closing things](#closing-things)
- [Claude Code](#claude-code)
- [Machines over SSH](#machines-over-ssh)
- [Docker containers](#docker-containers)
- [Keyboard](#keyboard)
- [Settings](#settings)
- [Logs and troubleshooting](#logs-and-troubleshooting)
- [Files and privacy](#files-and-privacy)

---

## Install and update

Requirements: macOS 15 or later, and [tmux](https://github.com/tmux/tmux) (`brew install tmux`).

```sh
curl -fsSL https://raw.githubusercontent.com/hyeok-jong/Initia/beta/install.sh | bash
```

The script downloads the newest release, checks its checksum and installs Initia into `/Applications` (or `~/Applications`). Initia is not notarized yet, so if you install the zip by hand, run `xattr -dr com.apple.quarantine /Applications/Initia.app` once.

**Updates.** Initia checks for a new version when it starts and every 6 hours. When one is out, the **Update** button in the toolbar (and in the menu bar popover) says so; click it to download, verify and restart. Your tmux sessions keep running and the tabs you had open come back. You'll also get a notification, at most once a day. Settings → General → Updates lets you check now, turn automatic checks off, or skip beta versions.

**First launch.** macOS asks whether Initia may send notifications. Allow it if you want "Claude finished" alerts. You can change it later in System Settings → Notifications → Initia.

Initia lives in the menu bar and the Dock. Clicking the Dock icon (or launching it again) opens the main window, which always starts at Home.

## The big picture

Initia organizes everything as a tree:

```
Machine            this Mac, or a server from ~/.ssh/config
├─ tmux session    running on the machine
│  └─ window(s)
└─ 🐳 container    a docker container on the machine
   └─ tmux session running inside the container
```

- A **machine** is one place you log in to: this Mac, or one SSH account on a server.
- A **tmux session** keeps running whether or not you are looking at it. Initia shows it, previews it, and opens it.
- A **tab** is Initia's own terminal attached to a session. Closing a tab only detaches; the session keeps running.
- A **plain terminal** is a tab without tmux (⌘T). It ends when you close it.

Each session has a colored dot that tells you where it is open:

| Dot | Meaning |
|---|---|
| 🟢 green | Open in an Initia tab |
| 🔵 blue | Attached in another terminal (iTerm2, Terminal, …) |
| ⚪ gray | Running in the background, not open anywhere |

## Home

Home is the start screen. At the top, four tiles count your tmux sessions and windows, sessions open in Initia, Claude sessions (working, waiting, or at the usage limit), and background sessions.

Below, every machine and every container with tmux gets its own section of **session cards**. A card shows:

- the session name and folder, and where it is open
- **Claude** (or **Happy**) when Claude Code runs in it, pulsing while it works
- 🐳 the container it is in, the number of windows, and a bell when Claude finished and you haven't looked yet
- a **live preview** of the last lines on screen
- the current task title (what Claude is working on) and the last activity

Click a heading to collapse it (Expand all / Collapse all are at the top); containers sit inside their machine's section. Click a card to open it, or drag it to reorder. Presets you haven't started yet appear under **Quick start**, and machines that aren't connected are listed with a **Connect** button.

## The sidebar

```
🏠 Home
OPEN IN INITIA         sessions you have open in tabs
MACHINES (SSH)   ⤢ ⤡   expand all / collapse all
 ▾ 💻 This Mac
     session …
     ▸ 🐳 container  docker     (collapsed by default)
 ─────────
 ▾ 🖥 a100  ●
     session …
     ▾ 🐳 hyeokjong  docker
         dl
         ecg-ef
 ─────────
 ▸ 🖥 staging  ○
 ⊕ Add machine (SSH)
PRESETS
```

- Click the arrow to expand or collapse a machine or container. Containers start collapsed; their row still shows Claude and bell badges.
- Click a **machine row** for its page: a shell, new sessions, running containers, and (for SSH) the connection and its config.
- The guide lines and indentation show what belongs to what. What you expand stays expanded next time.
- Drag machines, sessions, presets or tabs to reorder them; Home uses the same order.
- Right-click anything for its actions. ⌃⌘S hides the sidebar. The search field filters sessions, machines and presets.

## Working in a session

Selecting a session opens it in Initia's terminal. The header shows its machine (or container), folder and windows, plus:

- **Terminal / Overview**: Overview shows a live preview of every window, where you can rename, add or close windows (double-click a name to rename).
- **Close**: see [Closing things](#closing-things).
- The terminal icon opens the session in your default external terminal; **⋯** has more (another terminal, copy the attach command, save as preset, rename, new window).

**Snippets** are buttons under the terminal that type text for you. The defaults (`/clear`, `/compact`, `continue`, Esc) appear when Claude runs in the session. Click the slider icon to add your own; `\e` sends Esc and `\n` a new line.

**Zoom** the terminal with ⌘= and ⌘-, and reset with ⌘0. Copy and paste work as usual.

If you detach from inside tmux (Ctrl-b d), the tab shows **Reconnect** instead of disappearing. If an SSH tab ends, it stays open with the last output and the exit code, so you can see why.

## File tree

A folder tree sits to the left of the terminal, like VS Code's Explorer. It is on by default; **⇧⌘E** (or the sidebar button in the session header) hides and shows it. It works the same on this Mac, SSH machines and docker containers.

- It **follows the session's current folder**: `cd` in the terminal and the tree moves there a few seconds later. If a window is inside a container (`docker exec`), the tree shows the container's home.
- **Click a folder** to expand it. **Click a file** to type its path into the terminal, without pressing Enter. When Claude is running, it types `@path` so Claude picks up the file.
- **Double-click a text file** (`.md`, `.html`, `.sh`, `.py`, `.json`, `.yaml`, …) to edit it right next to the terminal; see [Editing files](#editing-files). Other files (images, PDFs, spreadsheets) open in their app on this Mac, in VS Code Remote on an SSH machine if VS Code is installed, or as a downloaded copy. Double-click a folder to make it the top.
- **Right-click** for Copy Path, Copy Relative Path, cd Here, Show in Finder, **Download to Downloads** and **Upload Here…**.
- **Upload** by dropping files or folders from Finder onto a folder (or onto empty space for the top folder). Initia asks before replacing anything.
- **Progress**: big transfers show a progress bar with the size and percent under the tree, and a **Cancel** button. A cancelled download leaves nothing behind; a cancelled upload may leave a partial file on the server.
- The header has Parent folder, Go to the terminal's folder, show/hide hidden files, Upload and Refresh. Drag the divider to resize.

Nothing has to be installed on the server: transfers run over Initia's existing SSH connection, and folders work too.

## Editing files

Double-click a text file in the file tree and it opens in a pane beside the terminal, so you don't need vim for a quick change.

- **Markdown** (`.md`) opens as a rendered preview (tables, task lists, code blocks); switch to **Edit** to change it. **HTML** has a preview too. Everything else (`.sh`, `.py`, `.json`, `.yaml`, `.toml`, `Dockerfile`, dotfiles, …) opens straight in the editor.
- **⌘S** saves back to where the file lives: this Mac, an SSH machine or a container. An orange dot means unsaved changes.
- If the file changed since you opened it (another person on the server, or Claude), Initia asks before overwriting.
- The editor is made for code: no smart quotes or auto-correct. ⌘F finds.
- Closing a pane with unsaved changes asks to save. Files over 5 MB or that aren't UTF-8 text don't open in the editor; right-click → Open with Default App / Open in VS Code / Open a Copy instead.

## Side by side

Watch more than one thing at once: **drag a tab** from the tab bar onto the terminal and drop it on the highlighted area on the right. Or right-click a tab → **Open Beside Current Tab**.

- Up to four panes: the current terminal plus three terminals or files.
- Each pane has **Go to this tab** and **✕** (closes only the pane; the tab stays open).
- Tabs shown beside the current one are outlined in the tab bar. Every tab keeps its own layout.

## Starting sessions and presets

**New tmux session** (⌘N, or the ⊕ card on Home) asks for:

| Field | |
|---|---|
| Machine | this Mac or an SSH machine |
| Container | optional: a running docker container to enter (see [Docker](#docker-containers)) |
| Folder | where the session starts (inside the container, if you picked one) |
| Keep running in the background (tmux) | on by default; turn off for a plain terminal |
| Session name / Startup command | for example `claude` or `npm run dev` |

**Presets** save that recipe so a session is one click away. Start one from Home (Quick start), the sidebar, or ⌘K. Mark a preset **autostart** to bring it up with the **Autostart** button, or automatically when Initia launches (Settings → General). A new install comes with an `example` preset that opens Claude Code in your home folder.

Presets live in `~/.config/initia/config.json`:

```json
"presets": [
  { "name": "api-server", "path": "~/dev/api-server", "command": "claude", "autostart": true },
  { "name": "notebook", "path": "~/research", "command": "jupyter lab", "device": "gpu-box" },
  { "name": "train", "path": "/workspace/train", "command": "claude", "device": "gpu-box", "container": "research" }
]
```

`device` is a `Host` name from `~/.ssh/config` (leave it out for this Mac). With `container`, see below.

## Closing things

The **Close** menu in the session header (and in every session's right-click menu) has three actions, each named after what it does. Nothing happens on a plain click, so nothing ends by accident.

| Action | What happens |
|---|---|
| **Close window (Ctrl-b d)** | Closes Initia's tab. The tmux session and Claude keep running. Same as the tab's ✕ and ⌘W. |
| **Quit Claude (/exit)** | Sends `/exit` to Claude. The shell and the session stay. |
| **End tmux session…** | Ends the session. If Claude runs in it, Initia quits Claude with `/exit` first, waits for it, then ends the session. |

## Claude Code

Initia notices Claude Code in any tmux window: on this Mac, over SSH, and inside containers.

- **Working or waiting.** While Claude works, its status line says "esc to interrupt"; Initia reads the bottom of the pane every few seconds. (Inside tmux, Claude keeps its window title fixed, so the title alone can't tell.)
- **Finished.** When Claude goes from working to waiting in a session you aren't looking at, you get a notification with the task name, a bell on the session, and a Dock badge. Click the notification to jump to it.
- **Usage limit.** When Claude stops at its usage limit ("Usage limit reached · resets 8:50pm"), the session shows ⚠ **Limit · 8:50pm** and you get one notification instead of "finished".
- **Account.** Machine pages, container rows and Claude session headers show which account Claude Code is signed in with there, and its plan (for example `you@example.com · Max 5x`). Initia reads this from `~/.claude.json`; it never reads tokens.
- **Happy.** Sessions started with `happy claude` show **Happy**. In Happy's remote mode (the phone screen), Claude's own screen is hidden, so Initia can't tell when it is working; the badge says so.
- **Trust prompt.** In a folder Claude hasn't been trusted in yet, Claude waits on a "trust this folder?" prompt; Initia shows it as waiting.

Turn notifications or their sound off in Settings → General → Notifications.

## Machines over SSH

The **Machines (SSH)** section lists the hosts in your `~/.ssh/config` next to this Mac.

**Connecting.** Click a machine and **Connect**. With an SSH key, it connects in the background. If the server wants a password (or a host key confirmation), a terminal tab opens so you can type it once; Initia reuses that login while you stay connected. If the server can't be reached (Tailscale off, wrong address), Initia shows the actual SSH error instead.

**One login.** Initia keeps a single SSH session per machine and streams the session list, Claude status and previews over it every 3 seconds, so a login monitor on the server sees one login, not one every few seconds. Opening a session in a tab is its own login, as usual.

**Editing machines.** Add a machine with **Add machine (SSH)**, or edit one on its page: name (Host), address (HostName), user, port, key file and jump host. Initia only rewrites the lines you change, keeps your comments and other options, writes through symlinks (dotfiles setups), and keeps the previous file as `~/.ssh/config.initia-backup`. Hosts from `Include`d files are shown read-only.

**Notes**
- Initia runs tmux with `-u`, so it works on servers whose SSH sessions have no language setting (macOS servers in particular), and Korean or box-drawing characters show correctly.
- Renaming a machine changes its connection; connect again afterwards.

## Docker containers

Initia supports both common ways of working in containers.

**1. tmux on the machine, work inside the container.** Keep tmux on the server and `docker exec` into a container from a tmux session. Give a new session or preset a **Container**, and Initia runs

```
docker exec -it -w <folder> <container> bash -lc '<command>; exec bash -l'
```

for you, so the session lands in the container's folder with your command running, and stays in the container shell after it ends. Session cards show 🐳 and the container name. Claude inside the container is detected from its title and screen, since its processes aren't under the tmux pane.

**2. tmux inside the container.** Initia also reads the tmux sessions running *inside* each container (every 15 seconds, over the machine's existing SSH session). They appear under the machine as 🐳 container → sessions, and opening one runs `docker exec -it <container> tmux attach -t <session>` in Initia's terminal. Claude detection, notifications, Close and rename all work there too.

A machine's page lists its running containers with:
- **tmux + docker exec**: a new tmux session on the machine that enters the container
- **docker exec**: a shell in the container, without tmux

Your account needs permission to run `docker` on that machine. With it, Initia shows every container there (a docker user is effectively an admin of the machine).

## Keyboard

Hold **⌘** for half a second to see all shortcuts; the tabs show their numbers too.

| Keys | Action |
|---|---|
| ⌘K | Command palette: jump to any session, machine, preset or command |
| ⇧⌘H | Home |
| ⌘1 … ⌘8, ⌘9 | Go to a tab (⌘9 = last tab) |
| ⇧⌘] / ⇧⌘[ | Next / previous tab |
| ⌘W | Close window (Ctrl-b d) for the current tab |
| ⌘N / ⌘T / ⇧⌘N | New tmux session / new terminal (no tmux) / new preset |
| ⌘= / ⌘- / ⌘0 | Zoom the terminal in / out / reset |
| ⇧⌘E | Show or hide the file tree |
| ⌘S | Save the file open beside the terminal |
| ⌘R | Refresh |
| ⌃⌘S | Show or hide the sidebar |
| ⌃⌘F | Full screen |
| ⌘, | Settings |
| ⇧⌘L | Logs |

The **Go** menu lists the navigation shortcuts. They work while the terminal has focus.

## Settings

Open with ⌘,.

- **General**: language (English, 한국어), where clicking a session opens it (Initia by default, or your external terminal), terminal font size, Dock icon, launch at login, autostart presets, notifications, and updates.
- **Terminals**: your default external terminal (iTerm2, Terminal, cmux, Ghostty, WezTerm, kitty, Alacritty) and its options. For cmux, set its socket access to `password` in cmux Settings → Automation and enter the same password here.
- **Advanced**: tmux path and version, the log file, and the config file.

## Logs and troubleshooting

Errors and warnings are saved to `~/Library/Logs/Initia/initia.log` (it opens in Console.app too). **Show Logs** (⇧⌘L) lets you filter, search, expand details and copy. Failed commands are logged with the exact command, its exit code and its output. When something fails, the toolbar shows a red count and the message has a **Log** button.

| Problem | Try |
|---|---|
| "tmux is not installed" | `brew install tmux` |
| A machine won't connect | The machine page and the log show the SSH error. Check Tailscale/VPN, the address, and that `ssh <host>` works in a terminal. |
| A password prompt tab closes at once | Look at the tab's last line (it now stays open) or the log; usually the server is unreachable. |
| Sessions on a server don't appear | Make sure tmux is installed there and you are connected (green dot). |
| No notifications | Allow Initia in System Settings → Notifications, and check Settings → General → Notifications. In Happy's remote mode, Claude can't be tracked. |
| Claude in a container isn't detected | Use a recent Claude Code; Initia reads its title and screen, so the session should show Claude's normal screen. |

## Files and privacy

| File | |
|---|---|
| `~/.config/initia/config.json` | settings and presets |
| `~/.ssh/config` | your SSH machines (edited only when you save a machine; backup in `config.initia-backup`) |
| `~/.config/initia/ssh/` (or `/tmp/initia-<uid>`) | Initia's own SSH connection-sharing sockets |
| `~/Library/Logs/Initia/initia.log` | logs |
| `~/Downloads` | files you download from the file tree |

Initia never stores passwords. On each machine it reads tmux's state, the process list, the bottom of each pane's screen, the running containers, and the account fields of `~/.claude.json` (email and plan, not tokens). It sends nothing anywhere except the update check to GitHub.
