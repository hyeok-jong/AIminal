# AIminal Guide

AIminal is a home for your tmux sessions: on this Mac, on your servers over SSH, and inside docker containers on those servers. This guide walks through everything it does. For a quick overview, see the [README](README.md). 한국어: [GUIDE.ko.md](GUIDE.ko.md).

- [Install and update](#install-and-update)
- [The big picture](#the-big-picture)
- [Home](#home)
- [Clock and machine stats](#clock-and-machine-stats)
- [The sidebar](#the-sidebar)
- [Working in a session](#working-in-a-session)
- [File tree](#file-tree)
- [Editing files](#editing-files)
- [Multi-line input](#multi-line-input)
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
curl -fsSL https://raw.githubusercontent.com/hyeok-jong/AIminal/beta/install.sh | bash
```

The script downloads the newest release, checks its checksum and installs AIminal into `/Applications` (or `~/Applications`). AIminal is not notarized yet, so if you install the zip by hand, run `xattr -dr com.apple.quarantine /Applications/AIminal.app` once.

**Updates.** AIminal checks for a new version when it starts and every 6 hours. When one is out, the **Update** button at the top right of the window (and in the menu bar popover) says so; click it, confirm, and AIminal downloads, verifies and restarts. **Updates** in the same place (**Check for Updates** in the menu bar popover and the AIminal menu) checks right away and, if there is a new version, goes straight to the same confirmation. Your tmux sessions keep running and the tabs you had open come back. You'll also get a notification, at most once a day. Settings → General → Updates lets you check now, turn automatic checks off, or skip beta versions.

**First launch.** A welcome screen checks what you already have and gives one button for each next step: install tmux if it's missing, save the tmux sessions it found as presets (or start your first one), add an SSH machine, and **Allow Notifications** for "Claude finished" alerts. Open it again any time from Help → **Welcome to AIminal…**. If macOS blocks AIminal's notifications later, Settings → General says so and links to System Settings.

AIminal lives in the menu bar and the Dock. Clicking the Dock icon (or launching it again) opens the main window, which always starts at Home.

## The big picture

AIminal organizes everything as a tree:

```
Machine            this Mac, or a server from ~/.ssh/config
├─ tmux session    running on the machine
│  └─ window(s)
└─ 🐳 container    a docker container on the machine
   └─ tmux session running inside the container
```

- A **machine** is one place you log in to: this Mac, or one SSH account on a server.
- A **tmux session** keeps running whether or not you are looking at it. AIminal shows it, previews it, and opens it.
- A **tab** is AIminal's own terminal attached to a session. Closing a tab only detaches; the session keeps running.
- A **plain terminal** is a tab without tmux (⌘T). It ends when you close it.

Each session has a colored dot that tells you where it is open:

| Dot | Meaning |
|---|---|
| 🟢 green | Open in an AIminal tab |
| 🔵 blue | Attached in another terminal (iTerm2, Terminal, …) |
| ⚪ gray | Running in the background, not open anywhere |

## Home

Home is the start screen. At the top, four tiles count your tmux sessions and windows, sessions open in AIminal, Claude sessions (working, waiting, or at the usage limit), and background sessions.

Below, every machine and every container with tmux gets its own section of **session cards**. A card shows:

- the session name and folder, and where it is open
- Claude's state when Claude Code runs in it: **Working** (orange), **Done** (green, finished and you haven't looked yet), **Waiting** (gray) or **Needs you** (red, waiting for your permission). The same badge is on the tab and in the sidebar
- 🐳 the container it is in and the number of windows
- a **live preview** of the last lines on screen
- the current task title (what Claude is working on) and the last activity

Click a heading to collapse it (**Expand All** / **Collapse All** are at the top); containers sit inside their machine's section. Click a card to open it, or drag it to reorder. Presets you haven't started yet appear under **Quick start**, and machines that aren't connected are listed with a **Connect** button.

## Clock and machine stats

The left of the toolbar, next to the AIminal name, shows the time (to the second) and date, and this Mac's **CPU**, **MEM** and **DISK** in use (disk = the volume with your home folder; hover for free space). Each remote machine's page shows that machine's **load** per core, memory, disk (where `$HOME` lives) and every **GPU** (utilization and temperature, from `nvidia-smi`), with a bar per GPU for utilization and memory. Chips turn orange at 70% and red at 90%.

Remote numbers ride along with the tmux snapshot AIminal already receives every few seconds, so they cost no extra logins. This Mac shows no GPU or temperature because macOS gives apps no public reading for them. Turn the strip off in Settings → General.

## The sidebar

```
🏠 Home
OPEN IN AIMINAL        sessions you have open in tabs (they stay listed under their machine too)
MACHINES         Expand All   (Collapse All once everything is open)
 ▾ 💻 This Mac
     session …
     ▸ 🐳 container  docker     (collapsed by default)
 ─────────
 ▾ 🖥 gpu-box  ●
     session …
     ▾ 🐳 research  docker
         train
         eval
 ─────────
 ▸ 🖥 staging  ○
 ⊕ Add Machine (SSH)…
PRESETS
```

- Click the arrow to expand or collapse a machine or container. Containers start collapsed; their row still shows the Claude badge.
- Click a **machine row** for its page: a shell, new sessions, running containers, and (for SSH) the connection and its config.
- The guide lines and indentation show what belongs to what. What you expand stays expanded next time.
- Drag machines, sessions, presets or tabs to reorder them; Home uses the same order.
- Right-click anything for its actions. ⌃⌘S (or the sidebar button at the sidebar's top-right edge, which moves with it as you resize) hides the sidebar. The search field filters sessions, machines and presets.

## Working in a session

Selecting a session opens it in AIminal's terminal. The header shows its machine (or container), folder and windows, plus:

- **Terminal / Overview**: Overview shows a live preview of every window, where you can rename, add or close windows (double-click a name to rename).
- **End…**: see [Closing things](#closing-things).
- A pencil next to the name renames the session. **Files**, **Message** and **Split** toggle the file tree (⇧⌘E), the message box (⇧⌘M) and splitting (⌘D) (just icons when the window is narrow); **⋯** has the rest (open in another terminal, copy the attach command, save as preset, new window).

Every tab says which machine it's on: 💻 **This Mac**, 🖥 the SSH machine, or 📦 *container · machine*, so two sessions with the same name never look alike.

**Snippets** are buttons under the terminal that type text for you. The defaults (`/clear`, `/compact`, `continue`, Esc) appear when Claude runs in the session. Click the slider icon to add your own; `\e` sends Esc and `\n` a new line.

**Zoom** with ⌘= and ⌘-, reset with ⌘0. They act on the kind of panel you clicked last: all terminals (including side-by-side panes), all message boxes, all editors, or the file tree. Every tab gets the same size, and new tabs open at it. The size is always shown in the panel's header (for example **13pt** next to the session name, in the message box and the editor, and under the file tree); click it for Bigger, Smaller and Default Size. ⌘= on a terminal is the same setting as **Terminal font size** in Settings. Copy and paste work as usual.

If you detach from inside tmux (Ctrl-b d), the tab shows **Reconnect** instead of disappearing. If an SSH tab ends, it stays open with the last output and the exit code, so you can see why.

## File tree

A folder tree sits to the left of the terminal, like VS Code's Explorer. It is on by default; **⇧⌘E** (or the **Files** button in the session header) hides and shows it. It works the same on this Mac, SSH machines and docker containers.

- It **follows the session's current folder**: `cd` in the terminal and the tree moves there a few seconds later. If a window is inside a container (`docker exec`), the tree shows the container's home.
- **Click a folder** to expand it. Clicking a file only selects it. After a click the tree takes the keyboard: **↑ ↓** move, **→** expands (or steps into) a folder, **←** collapses it (or goes to the parent), **↩** opens like a double-click.
- **Right-click → Insert Path** types the file's path into the terminal, without pressing Enter. When Claude is running it's **Insert as @mention**, which types `@path` so Claude picks up the file.
- **Double-click a text file** (`.md`, `.html`, `.sh`, `.py`, `.json`, `.yaml`, …) to edit it right next to the terminal; see [Editing files](#editing-files). Other files (images, PDFs, spreadsheets) open in their app on this Mac, in VS Code Remote on an SSH machine if VS Code is installed, or as a downloaded copy. Double-click a folder to make it the top.
- **Right-click** for Copy Path, Copy Relative Path, cd Here, Show in Finder, **Download To…** (pick any folder; AIminal remembers the last one), **Download to Downloads**, **Download as Zip** (folders: one `.zip` in Downloads) and **Upload Here…**. On this Mac, **Copy To…** does the same.
- **Sizes**: hover a row and click **Size**, or click **Sizes** above the tree for every item shown. Sizes are only calculated when you ask, because big folders take a while; the result appears at the right of the row.
- **Rename, move, duplicate, delete.** Right-click → **Rename…** (or **F2**), **Move To…** (type a folder, full or relative), **Duplicate** (`notes copy.md`), and **Move to Trash** on this Mac or **Delete…** on a server or container (**⌘⌫**; remote machines have no Trash, so AIminal asks first and says it can't be undone). **Drag a row onto a folder** (or onto empty space for the top folder) to move it there. An existing name is never overwritten, and an open editor follows its file to the new name.
- **Upload** by dropping files or folders from Finder onto a folder (or onto empty space for the top folder). AIminal asks before replacing anything.
- **Progress**: big transfers show a progress bar under the tree with the size, percent and current speed, when it started, how long it has run, the time left and the ETA, plus a **Cancel** button. A finished transfer keeps its start → end time, how long it took and its average speed. A cancelled download leaves nothing behind; a cancelled upload may leave a partial file on the server.
- **Refresh** next to the folder name reads the folder again. Below it is one row of buttons: **Up**, **Terminal** (back to the terminal's folder), **New ▾** (New File and New Folder in the selected folder — a new text file opens in the editor and an existing name is never overwritten — and Upload Files…) and **View ▾** (Calculate Sizes, Show Hidden Files for names starting with `.` — also **⇧⌘.** like Finder — Refresh, and the tree's text size). Right-click a folder or the empty area for the same. Drag the divider to resize.

Nothing has to be installed on the server beyond `tar` (which every system has): transfers run over AIminal's existing SSH connection, and folders work too.

## Editing files

Double-click a text file in the file tree and it opens as a tab in the pane beside the terminal, so you don't need vim for a quick change.

- **Markdown** (`.md`) opens as a rendered preview (tables, task lists, code blocks); switch to **Edit** to change it. **HTML** has a preview too. Previews only read the file: they don't run scripts and don't load remote images or other content from the internet. Everything else (`.sh`, `.py`, `.json`, `.yaml`, `.toml`, `Dockerfile`, dotfiles, …) opens straight in the editor.
- **⌘S** saves back to where the file lives: this Mac, an SSH machine or a container. An orange dot means unsaved changes.
- If the file changed since you opened it (another person on the server, or Claude), AIminal asks before overwriting.
- The editor is made for code: syntax colors for shell, Python, JavaScript/TypeScript, C-family, Go, Rust, Swift, YAML, JSON, HTML, SQL and Dockerfiles; no smart quotes or auto-correct. ⌘F finds.
- Closing a file with unsaved changes asks to save. Files over 5 MB or that aren't UTF-8 text don't open in the editor; right-click → Open with Default App / Open in VS Code / Open a Copy instead.

## Multi-line input

Typing a long prompt straight into a terminal is awkward: Enter submits, and every tool has its own trick for a line break. Under every terminal, including each pane of a split view, there is a **Message for Claude** button (just **Multi-line input** when Claude isn't running there). Click it, or press **⇧⌘M**, and a text box unfolds; write there instead: several paragraphs, Markdown, code blocks, anything. New tabs start with the box open (turn that off in Settings → General); fold it with ✕ or ⇧⌘M and that tab stays folded. Each pane has its own box and draft, and ⇧⌘M and ⌘↩ act on the pane you last clicked or typed in; the button shows the first line of an unsent draft.

- **Send ⌘↩** pastes the whole text into the terminal as one block and then presses Enter, so Claude Code (or your shell) receives it as a single message. **Paste Only** pastes without Enter, so you can keep editing in the terminal. **esc** puts the keyboard back in the terminal without sending. After sending, the keyboard goes to the terminal so you can watch; turn on **Keep typing in the message box after sending** in Settings → General to stay in the box instead.
- **Preview** renders the Markdown; what is sent is always the raw text. The box keeps its own draft per tab, and you can drag its top edge to resize it.
- Works in tmux sessions on this Mac, over SSH and inside containers (the text goes through tmux's paste buffer), and in plain terminal tabs.

## Side by side

Watch more than one thing at once. The terminal area splits into **panes, each with its own tab bar** (like editor groups in VS Code). A pane shows one of its tabs; tabs are terminals or files.

- **⌘D** opens a new terminal in a pane beside the current one, in the same machine and folder (**⇧⌘D** below it).
- **Drag a tab** to another pane's tab bar to move it there (while you drag, the other panes' tab bars light up with *Drop to move to this pane*, and a line shows where it will land), or to the highlighted area at the edge to give it a pane of its own. Dragging within a tab bar reorders. With several panes, each session's one-line header still shows Claude's model and account. Right-click a tab for **Move to a New Pane** / **Move to Pane N**.
- The **split button** in the session header does the same from a menu: new terminal beside or below, move this tab to a new pane, open another tab or a session that isn't open yet beside it, switch between **Side by Side** and **Stacked**, **Equal Sizes**, and **Merge All Panes**.
- Files you open from the file tree become tabs in the pane next to the terminal, so the terminal stays visible.
- Up to six panes. **Drag the divider** between panes to resize them. A pane disappears when its last tab is closed.
- Click a pane (or one of its tabs, or press ⌥⌘← / ⌥⌘→) to make it the active one: its tab is outlined, the keyboard goes to its terminal or editor, and the sidebar, the file tree, ⌘W and ⇧⌘M follow it. ⌘↩ sends a message box only while you're typing in that box or its terminal, so it never fires from a file editor. Home, machine and preset pages take the whole area and leave the layout as it is.

## Starting sessions and presets

**New tmux session** (⌘N, or the ⊕ card on Home) asks for:

| Field | |
|---|---|
| Machine | this Mac or an SSH machine |
| Container | optional: a running docker container to enter (see [Docker](#docker-containers)) |
| Folder | where the session starts (inside the container, if you picked one) |
| Keep running in the background (tmux) | on by default; turn off for a plain terminal |
| Session name / Startup command | for example `claude` or `npm run dev` |

**Presets** save that recipe so a session is one click away. Start one from Home (Quick Start), the sidebar, or ⌘K. Mark a preset **autostart** to bring it up with the **Autostart** button, or automatically when AIminal launches (Settings → General). A new install comes with an `example` preset that opens Claude Code in your home folder.

**Save what's running as presets, all at once.** **Save Running…** next to **Presets** in the sidebar (or ⌘K → *Save Sessions as Presets…*) lists your tmux sessions, the ones open in AIminal first (switch to **All sessions** for the rest). Each row already knows where it lives: on this Mac, on an SSH machine, inside a container's own tmux, or a machine's tmux that `docker exec`s into a container (the container and its `-w` folder are kept). The folder comes from the session's window and the command is `claude` (or `happy`) when Claude Code runs there; edit either before saving. Tick **Include in Autostart** and the whole setup comes back with one click. A preset holds one window, so for multi-window sessions the Claude window is saved; sessions that are already presets are marked and, if you tick them, updated in place. To save just one session, right-click it in the sidebar or on Home → **Save as Preset…** (filled in the same way), or **Update preset from this session…** if it already has one.

**Keep presets in iCloud Drive (one file per Mac).** Click **Folder** next to **Presets** in the sidebar → **Save to Folder…** and pick a folder, for example `iCloud Drive/AIminal`. From then on, every change is saved there as `AIminal presets (<this Mac's name>).json`. On another Mac, the same menu offers **Load from Folder** with one entry per Mac (or **Load from File…** for any backup); you choose **Merge** (add only what isn't there yet) or **Replace**. Each Mac keeps its own file, so presets that point at local folders never mix, and nothing is loaded automatically. The first time AIminal touches iCloud Drive, macOS asks for permission.

Presets live in `~/.config/aiminal/config.json`:

```json
"presets": [
  { "name": "api-server", "path": "~/dev/api-server", "command": "claude", "autostart": true },
  { "name": "notebook", "path": "~/research", "command": "jupyter lab", "device": "gpu-box" },
  { "name": "train", "path": "/workspace/train", "command": "claude", "device": "gpu-box", "container": "research" }
]
```

`device` is a `Host` name from `~/.ssh/config` (leave it out for this Mac). With `container`, see below.

## Closing things

The **End…** menu in the session header (and in every session's right-click menu) has three actions, each named after what it does. Nothing happens on a plain click, so nothing ends by accident.

| Action | What happens |
|---|---|
| **Close Tab (Detach)** | Closes AIminal's tab. The tmux session and Claude keep running. Same as the tab's ✕ and ⌘W. |
| **Quit Claude (/exit)** | Sends `/exit` to Claude. The shell and the session stay. |
| **End Session…** | Ends the session after asking. If Claude runs in it, AIminal quits Claude with `/exit` first, waits for it, then ends the session. |

If a remote session's machine drops, its pane says **Lost connection** and offers **Reconnect**; the session is usually still running on the server. A session that really ended offers **Start Again** (when it has a preset) and **Close Tab**.

## Claude Code

AIminal notices Claude Code in any tmux window: on this Mac, over SSH, and inside containers.

- **Working or waiting.** While Claude works, its status line says "esc to interrupt"; AIminal reads the bottom of the pane every few seconds. (Inside tmux, Claude keeps its window title fixed, so the title alone can't tell.)
- **Claude Code hooks (optional, more accurate).** On a machine page, **Install…** next to *Claude Code hooks* (for a container: **Add Claude hooks…** on its row) adds a few hooks and a status line to that machine's `~/.claude/settings.json`, after asking. Claude Code then tells AIminal itself when it starts working, finishes, or **waits for your permission** to run a tool, so AIminal no longer depends on reading the screen, and a session waiting for you shows **Claude · Needs you** with its own notification. The hooks only mark the tmux pane Claude runs in (nothing is sent anywhere); the original file is kept as `settings.json.aiminal-backup`, and **Remove…** takes out only AIminal's hooks. Restart running Claude Code sessions to pick them up. Outside tmux (a plain `docker exec` shell) the screen reading above is still used.
- **Usage bar.** With the hooks installed, each pane header shows how much of your **5-hour** and **weekly** Claude limit is used, as a bar with the percentage (green below 70%, orange from 70%, red from 90%). Hover it for the reset times. It belongs to the account that pane's Claude is signed in with, so it stays right when you switch accounts, and it works on remote machines and in containers. The numbers come from the same pane marker as the status, and the status line AIminal adds shows nothing inside Claude. If you already use your own Claude Code status line, AIminal leaves it alone and skips the bar. Subscription accounts only; with an API key there are no limits to show. Narrow panes shrink it to "5h 78%", then hide it.
  It also works for Claude Code started with `docker exec` from a tmux pane (no tmux inside the container): install the hooks in that container too (**Add Claude hooks…** on its row). If you installed the hooks with 0.14.11–0.14.15, the hooks row says the usage bar needs an update; click **Install…** once more.
- **Finished.** When Claude goes from working to waiting in a session you aren't looking at, you get a notification with the task name, a green **Done** badge on the session, and a Dock badge. Click the notification to jump to it.
- **Usage limit.** When Claude stops at its usage limit ("Usage limit reached · resets 8:50pm"), the session shows ⚠ **Limit · 8:50pm** and you get one notification instead of "finished".
- **Model.** The Claude badge on cards, session headers and window cards says which model that Claude is using, like **Claude · Fable 5.1** or **Opus 5.5** (the full id is in the tooltip). AIminal reads it from Claude Code's own session files (`~/.claude/sessions`, and the last reply in the session's transcript); it never reads your conversation or tokens. If a session's windows use different models, both are listed.
- **Account.** Machine pages, container rows and Claude session headers show which account Claude Code is signed in with there, and its plan (for example `you@example.com · Max 5x`). AIminal reads this from `~/.claude.json`; it never reads tokens.
- **Happy.** Sessions started with `happy claude` show **Happy**. In Happy's remote mode (the phone screen), Claude's own screen is hidden, so AIminal reads working / waiting from Claude Code's session file instead; the badge says it is in remote mode.
- **Trust prompt.** In a folder Claude hasn't been trusted in yet, Claude waits on a "trust this folder?" prompt; AIminal shows it as waiting.

The **Alerts** button at the top right turns the notification, its sound and the count on the Dock icon on or off in one click (the bell is crossed out when they're all off). The same switches are in Settings → General → Notifications.

**Alerts per machine or session.** Right-click a machine, container or session and open **Alerts** to choose **With Sound**, **Without Sound** or **Off**, or leave it following the level above. The closest choice wins: session, then container, then machine, then the main switches. So you can silence one noisy server, or keep a single session alerting while the rest are off. A session set to Off still shows its **Done** badge in AIminal, but sends no notification and isn't counted on the Dock. Everything starts with alerts on; a crossed-out bell marks each machine, container or session whose alerts you turned off.

## Machines over SSH

The **Machines** section lists this Mac and the hosts in your `~/.ssh/config`.

**Connecting.** Click a machine and **Connect**. With an SSH key, it connects in the background. If the server wants a password (or a host key confirmation), a terminal tab opens so you can type it once; AIminal reuses that login while you stay connected. If the server can't be reached, AIminal shows the SSH error with a hint (address not found: VPN or Tailscale off? no answer, connection refused, host key changed, key not accepted) and a **Try Again** button. Home cards show the same reason; **Cancel** stops a connection that hangs.

**Reconnecting by itself.** When Wi-Fi drops or the Mac sleeps, a machine that was connected tries again every 30 seconds with your SSH key, and right after the Mac wakes. It never opens a password prompt by itself; **Disconnect** stops the retries.

**One login.** AIminal keeps a single SSH session per machine and streams the session list, Claude status and previews over it every 3 seconds, so a login monitor on the server sees one login, not one every few seconds. When nothing has changed, only a few hundred bytes go over the wire, and the slower checks (`docker ps`, `nvidia-smi`, Claude's session files) run every 15 seconds. Tabs and file transfers reuse that same connection, so the server still sees one login.

**Editing machines.** Add a machine with **Add Machine (SSH)…**, or edit one on its page: name (Host), address (HostName), user, port, key file and jump host. AIminal only rewrites the lines you change, keeps your comments and other options, writes through symlinks (dotfiles setups), and keeps the previous file as `~/.ssh/config.aiminal-backup`. Hosts from `Include`d files are shown read-only.

**Notes**
- AIminal runs tmux with `-u`, so it works on servers whose SSH sessions have no language setting (macOS servers in particular), and Korean or box-drawing characters show correctly.
- Renaming a machine changes its connection; connect again afterwards.

## Docker containers

AIminal supports both common ways of working in containers.

**1. tmux on the machine, work inside the container.** Keep tmux on the server and `docker exec` into a container from a tmux session. Give a new session or preset a **Container**, and AIminal runs

```
docker exec -it -w <folder> <container> bash -lc '<command>; exec bash -l'
```

for you, so the session lands in the container's folder with your command running, and stays in the container shell after it ends. Session cards show 🐳 and the container name. Claude inside the container is detected from its title and screen, since its processes aren't under the tmux pane.

**2. tmux inside the container.** AIminal also reads the tmux sessions running *inside* each container (every 15 seconds for containers that have tmux, and a full sweep every minute, over the machine's existing SSH session). They appear under the machine as 🐳 container → sessions, and opening one runs `docker exec -it <container> tmux attach -t <session>` in AIminal's terminal. Claude detection, notifications, Close and rename all work there too. **Start more of them** from AIminal: the ⊕ next to the container in the sidebar (or right-click → New tmux session inside…), the "new session" card in the container's group on Home, or **New tmux inside** on the machine page. The session is created inside the container (`docker exec <container> tmux new -s …`), so you can keep several tmux sessions per container, each with its own Claude.

A machine's page lists its running containers with:
- **New tmux inside**: a new tmux session inside the container (tmux lives in the container; keep several)
- **Machine tmux → docker exec**: a new tmux session on the machine that immediately enters the container (shows up under the machine)
- **Shell only**: `docker exec` in a plain tab, no tmux; nothing keeps running after you close it

Your account needs permission to run `docker` on that machine. With it, AIminal shows every container there (a docker user is effectively an admin of the machine).

## Keyboard

Hold **⌘** for half a second to see all shortcuts; the tabs show their numbers too.

| Keys | Action |
|---|---|
| ⌘K | Command palette: jump to any session, machine, preset or command |
| ⇧⌘H | Home |
| ⌘1 … ⌘8, ⌘9 | Go to a tab, counted in the order you see them across panes (⌘9 = last tab) |
| ⇧⌘] / ⇧⌘[ | Next / previous tab |
| ⌘W | Close Tab (Detach) for the current tab |
| ⌘N / ⌘T / ⇧⌘N | New tmux session / new terminal (no tmux) / new preset |
| ⌘= / ⌘- / ⌘0 | Zoom the last-clicked kind of panel in every tab / out / reset |
| ⌃⌘= / ⌃⌘- / ⌃⌘0 | Make the whole interface bigger / smaller / default size |
| ⇧⌘E | Show or hide the file tree |
| ⇧⌘. | Show or hide hidden files in the file tree |
| F2 / ⌘⌫ | Rename / delete the selected item in the file tree |
| ⇧⌘M / ⌘↩ | Show or hide the message box / send it and press Enter |
| ⌘S / ⌥⌘S | Save the editor you're working in / save every changed file |
| ⌘F / ⌘G | Find in the editor / find next |
| ⌥⌘→ / ⌥⌘← | Move to the next / previous pane |
| ⌘D / ⇧⌘D | New terminal in a pane beside / below |
| ⌘R | Refresh |
| ⌃⌘S | Show or hide the sidebar |
| ⌃⌘F | Full screen |
| ⌘, | Settings |
| ⇧⌘L | Logs |

The **Go** menu lists the navigation shortcuts. They work while the terminal has focus.

The **Session** and **Machine** menus act on what you selected in the sidebar, with the same items as the right-click menus (open in another terminal, rename, save as preset, quit Claude, end the session; connect, disconnect, edit or delete a machine). **View** has Expand All, Collapse All and Start Autostart Presets for Home.

## Settings

Open with ⌘,.

- **General**: language (English, 한국어), **Interface size** (85–150%, also ⌃⌘= / ⌃⌘-), Dock icon and the clock and stats in the toolbar; a **Terminal** group (where clicking a session opens it, terminal font size, opening the message box in new tabs, keeping the keyboard in the message box after sending, **Edit Snippets…**); notifications (with a warning when macOS blocks them); updates; and startup (launch at login, autostart presets).
- **External Terminals**: your default external terminal (iTerm2, Terminal, cmux, Ghostty, WezTerm, kitty, Alacritty) and its options. For cmux, set its socket access to `password` in cmux Settings → Automation and enter the same password here.
- **Advanced**: tmux path and version (or how to install it), **Draw terminals with the GPU (Metal)** (on by default; much less CPU when many sessions update at once, turn it off if a terminal draws incorrectly), the log file, the config file, and **Help**: **Report a Problem…**, the welcome screen and this guide.

## Logs and troubleshooting

Errors and warnings are saved to `~/Library/Logs/AIminal/aiminal.log` (it opens in Console.app too). **Show Logs** (⇧⌘L) lets you filter, search, expand details and copy. Failed commands are logged with the exact command, its exit code and its output. When something fails, the toolbar shows a red count and the message has a **Log** button.

| Problem | Try |
|---|---|
| "tmux is not installed" | `brew install tmux` — AIminal notices within a few seconds, no restart needed. SSH machines work without tmux on this Mac. |
| A machine won't connect | The machine page shows the SSH error with a hint, and the log has the details. Check Tailscale/VPN, the address, and that `ssh <host>` works in a terminal. |
| A password prompt tab closes at once | Look at the tab's last line (it now stays open) or the log; usually the server is unreachable. |
| Sessions on a server don't appear | Make sure tmux is installed there and you are connected (green dot). |
| No notifications | Allow AIminal in System Settings → Notifications, and check Settings → General → Notifications. |
| Claude in a container isn't detected | Use a recent Claude Code; AIminal reads its title and screen, so the session should show Claude's normal screen. |

Still stuck? Help → **Report a Problem…** opens a GitHub issue with your AIminal, macOS and tmux versions filled in. Nothing is sent until you submit it; paste the relevant log lines if they help.

## Files and privacy

| File | |
|---|---|
| `~/.config/aiminal/config.json` | settings and presets (readable only by you) |
| `~/.ssh/config` | your SSH machines (edited only when you save a machine; the previous contents go to `config.aiminal-backup`, and the file as it was before AIminal first touched it stays in `config.aiminal-original`) |
| `~/.config/aiminal/ssh/` (or `/tmp/aiminal-<uid>`) | AIminal's own SSH connection-sharing sockets |
| `~/Library/Logs/AIminal/aiminal.log` | logs |
| `~/Downloads` | files you download from the file tree |
| `~/Library/Preferences/com.hyeokjong.initia.plist` | window and sidebar state |

AIminal never stores your SSH passwords or keys: a password is typed once into a terminal tab and only the open connection is reused. The one secret it keeps is the optional cmux socket password you enter in Settings, saved in your macOS Keychain (not in `config.json`). After an update macOS may ask once whether AIminal can use it; choose Always Allow.

On each machine it reads tmux's state, the process list, the bottom of each pane's screen, the running containers, load, memory, GPU and disk usage, the account fields of `~/.claude.json` (email and plan, not tokens), and the model name from Claude Code's session files (not the conversation). If you install the optional Claude Code hooks, AIminal writes them into that machine's `~/.claude/settings.json` (backup kept) and reads the status and usage numbers they leave on the tmux pane. None of it leaves your Mac: there is no telemetry or analytics, and the only connections AIminal makes on its own are to your SSH machines and to GitHub, to check for and download updates. The log file records machine names, file paths and commands that failed, never what you type into the message box or the terminal.

**Uninstalling.** Quit AIminal, move `AIminal.app` to the Trash, and delete AIminal's own files: `~/.config/aiminal/`, `~/Library/Logs/AIminal/` and `~/Library/Preferences/com.hyeokjong.initia.plist` (plus the `~/.config/termoor` and `~/.config/initia` links, if you started on an older version). If you turned on **Launch AIminal at login**, turn it off first or remove AIminal in System Settings → General → Login Items. tmux sessions, your `~/.ssh/config` and your downloads are yours and stay as they are; shared SSH connections close by themselves within 30 minutes.
