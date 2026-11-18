# Changelog

## 0.13.0-beta

### Changed

- **Panes now each have their own tab bar.** Splitting used to happen inside one tab's content area, and the layout changed whenever you switched tabs. Now the terminal area is divided into panes, like editor groups in VS Code: every pane has its tabs at the top and shows one of them
  - **Drag a tab** to another pane's tab bar to move it, or to the edge to give it a new pane; right-click a tab for **Move to a New Pane** / **Move to Pane N**
  - ⌘D / ⇧⌘D open a new terminal in a pane beside / below; closing a pane's last tab removes the pane
  - **Files are tabs too**: a file opened from the file tree becomes a tab in the pane next to the terminal, with an unsaved-changes dot, and stays open when you close the terminal tab it came from
  - The pane you click becomes the active one (outlined tab); the sidebar, the file tree, ⌘W, ⇧⌘M and ⌘↩ follow it
  - With several panes the session header shrinks to one line; **Merge All Panes** in the split menu brings everything back into one
- One file tree for the window, following the active pane's terminal
- **Much lighter on shared servers**: an idle machine now costs about 0.5 KB every 3 seconds instead of tens of KB. AIminal sends only the processes under your tmux panes (not the whole server's process list), skips the session list when nothing changed, checks `docker ps`, `nvidia-smi` and Claude's session files every 15 seconds, and only looks inside containers that run tmux (all containers once a minute)
- Large files in the editor no longer slow down typing (syntax colors catch up a moment later)

### Fixed

- A message box draft is no longer redrawn with the whole window on every keystroke
- Downloading a folder that changes while it's being sent (a running training job's logs) no longer fails at the end
- Notifications for a session you're looking at are skipped only when the main window is in front and that session is visible in any pane
- Renaming a machine or session keeps its place in the order you dragged
- Problems in a sheet ("Enter a session name", "already exists") now show inside the sheet instead of behind it
- English: "1 session running", "1 error", "+1 window"
- VoiceOver reads session cards, rows and tabs as buttons

## 0.12.29-beta

A second full audit — data safety, performance, and the rough edges a first-time user hits.

### Fixed — things that could lose work

- **Message for Claude lost long messages**: anything over about 16 KB (roughly 5,000 Korean characters, or a pasted log) failed with "command too long" and the draft was already gone. Text of any length now goes through, and if a send ever fails the draft comes back
- **A message starting with `-` followed by non-English text** (a Markdown bullet in Korean, for example) arrived empty on this Mac. The same bug made **uploading a file named like `-메모.txt`** send the whole parent folder instead; both are fixed
- **A file that failed to open could be overwritten**: a too-large or non-text file showed an empty editor, and saving it replaced the real file. It now shows **Try Again** and can't be saved
- **Uploading into a folder you hadn't expanded** replaced same-named files without asking
- **Opening a seventh pane** silently dropped the first one even when it was an unsaved editor; unsaved editors are never pushed out now
- **Editing a machine removed the quotes** around values such as `IdentityFile "~/My Keys/id"`, after which ssh rejected the whole config. Untouched lines are left exactly as they were
- **A `~/.ssh/config` that isn't UTF-8** was treated as empty, so adding a machine replaced the file. AIminal now refuses to rewrite it, and keeps the very first original as `config.aiminal-original`
- **Saving a remote file** no longer leaves it empty if the connection drops mid-save
- **End tmux session…** now always asks first (it used to end the session without a prompt when Claude was idle); **deleting a preset** asks too, and **Replace** when loading presets keeps a copy of the old ones
- **Closing or quitting with something running in a terminal without tmux** asks first, like Terminal does
- **Cancelling an update at the "save changes?" prompt** left the button stuck on "Downloading…" and swapped the app hours later when you quit. Unsaved files are asked about before the download, and a failed swap is reported instead of saying "Updated"

### Faster and lighter

- **Much less background CPU**: the 3-second check on this Mac used to start dozens of small processes each time; Claude's model and status are now read directly, and previews reuse what the check already captured
- **Slows down when you aren't looking**: with the window closed or covered, this Mac is checked every 9 seconds instead of 3
- The window no longer redraws itself every 2–3 seconds for unchanged data (the CPU/MEM figures update on their own), and the editor stops recompiling its syntax rules on every keystroke
- A stuck `docker` or `tmux` can no longer pile up background checks, and machines you aren't connected to cost nothing

### Improved

- **tmux installed after AIminal** is picked up within seconds (no restart), with the install command shown on Home; the menu bar popover still lists your SSH sessions when this Mac has no tmux
- **Hidden files**: ⇧⌘. (as in Finder) and a right-click item, in addition to the eye button
- **Previews are read-only and offline**: the HTML preview doesn't run scripts, neither preview loads remote images, and links open in your browser
- Messages such as "Copied" look like information, not errors, and fade after 5 seconds
- SSH connections notice a dead network within 45 seconds instead of staying "connected" with a frozen screen, and a leftover socket from a crash no longer causes repeated logins
- Uploads into a root container are owned by that user (not uid 501); container shells fall back to `sh` when the image has no `bash`; files opened from a server are quarantined like any download
- A session that ends by itself cleans up its panes, and an unsaved editor beside it moves to the next tab; a detached pane has a **Reconnect** button
- ⌘W in a sheet or the Settings window no longer closes the tab behind it; ⌘K gives the keyboard back to the terminal; the tab bar scrolls to the selected tab and long tab titles are shortened
- A fresh login no longer hides the window when you open AIminal yourself right after a restart
- `config.json` is readable only by you; the log no longer contains any text from the message box
- `install.sh` updates AIminal where it already is (no second copy), asks the running app to quit normally, and can't leave you without an app if the download is cut off
- Guide: what AIminal reads and stores, spelled out; how to uninstall

## 0.12.28-beta

Full code and documentation audit before wider release. Nothing changes in how AIminal looks; these are the fixes.

### Fixed

- **Servers whose login shell is csh or tcsh**: every remote query and transfer failed (`Unmatched '''`) because csh can't take a multi-line command in quotes. Remote scripts are now passed in a form that works the same in sh, bash, zsh, fish, csh and tcsh
- **Renaming a session or machine could crash the app** when a tab with that name had been open before (duplicate keys while moving per-tab state). It also lost the stacked/side-by-side choice, per-pane zoom and the file tree's expanded folders; all are carried over now
- **A broken `config.json` no longer wipes your presets**: a copy is kept as `config.json.broken`, and **Reload config** keeps your current settings instead of replacing them with empty defaults
- **`~/.ssh/config.aiminal-backup` was useless when `~/.ssh/config` is a symlink** (the backup was the link itself); it now holds the previous contents
- **Preset startup commands ending in `;`** (and session names ending in `;`) were silently ignored by tmux; they are escaped now
- **Message box**: the Clear button didn't clear while the last Korean syllable was still being composed; the Preview toggle leaked between tabs; after switching to a tab with panes beside it, keystrokes went to the side pane instead of the main terminal
- **Machines with a Korean (non-ASCII) alias** in `~/.ssh/config` connected but never listed sessions or files (the alias reached ssh in a decomposed form); all ssh paths now go through the same safe route
- File tree showed a stale folder after being hidden and shown again or after returning to a tab; the file-tree and message-box buttons turned the feature *off* when clicked from the Overview page
- Uploading a file whose name starts with `-` or `@` failed; downloading a symlink produced a dangling link instead of the file it points to
- Claude's 🔔 badge stayed on for a container session that had been killed, and for machines you renamed or deleted
- A host alias with trailing spaces was saved with the spaces, leaving presets pointing at a machine that didn't exist
- Container sessions in **Autostart** and tab restore after an update didn't check the machine's SSH connection
- Reconnecting a shell tab lost the editor panes and draft beside it
- Home hid a connected machine that has no tmux; ⌘K could show the wrong row for sessions whose names collide (`ssh:a` + `bc` vs `ssh:ab` + `c`); a pane screen that itself contains `@@INITIA-…` no longer corrupts parsing
- **Save sessions as presets** → *All sessions* ignored sessions filtered out by the sidebar search

### Changed

- `install.sh` now refuses to install when the release has no checksum file, waits for a running AIminal to quit before replacing it, and no longer depends on `head` closing a pipe
- LICENSE lists MarkdownUI, NetworkImage and cmark-gfm; the full license texts ship inside the app bundle
- Guide: table of contents, session-header description, keyboard table (⇧⌘M, ⌘↩), settings list and the SSH "one login" note brought up to date; "nothing to install on the server" now says "beyond tmux"

## 0.12.27-beta

### Fixed

- **Message for Claude**: after typing in one tab's message box and switching back to another tab, your typing went into the other tab's draft (closing and reopening the box made it right). Each tab now has its own box, and an editor always writes to the tab it's showing

## 0.12.26-beta

### Changed

- A session's right-click menu always offers presets: **Save as preset…**, or **Update preset from this session…** when a preset with that name already exists (before, the item was hidden)
- Updating a preset from a session keeps its startup command when it runs the same program (`claude --model opus` stays instead of becoming `claude`)

## 0.12.25-beta

### Changed

- Right-click a session → **Save as preset…** now fills in the same things as **Save sessions as presets**: the container and its folder when the session `docker exec`s into one, and `claude`/`happy` when Claude Code runs there

## 0.12.24-beta

### Added

- **Save sessions as presets**: the new button next to **Presets** in the sidebar (also in ⌘K) turns the tmux sessions you have running into presets in one go. It handles every kind of session: on this Mac, on an SSH machine, tmux inside a container, and a machine's tmux that `docker exec`s into a container (the container and its `-w` folder are kept). Folders and the `claude`/`happy` command are filled in and editable; sessions that are already presets can be updated in place, and **Include in Autostart** brings the whole setup back with one click

### Fixed

- AIminal crashed at launch when the language was set to Korean (since 0.12.17): three translations were listed twice. A release check now blocks this

## 0.12.23-beta

### Changed

- **Sidebar**: sessions that are already open in a tab are dimmed under their machine, and the "Open in AIminal" group can be collapsed
- **Home**: the "New session" card is a slim row instead of a full-size card
- **Session header**: fewer buttons (opening in another terminal moved to the ⋯ menu), a pencil next to the name for renaming, and the ⌘ shortcut overlay now explains the header buttons
- **Settings → General**: "Keep typing in the message box after sending" keeps the keyboard in the box; by default it goes to the terminal

## 0.12.22-beta

### Changed

- UI/UX pass: **esc** in the message box returns the keyboard to the terminal; the box's hint now reads "⌘↩ sends it as one message · esc back to the terminal"; container names in the sidebar no longer get truncated before the "docker" caption does

## 0.12.21-beta

### Fixed

- **⌘= / ⌘- zoomed only the file tree** no matter where you clicked, and a click on the terminal might not have given it the keyboard back (both since 0.12.19): the click-location test used a view property that lies inside SwiftUI. Both now use plain window coordinates

## 0.12.20-beta

### Fixed

- **Closing the message box sometimes only changed the button's colour.** The ✎ button and ⇧⌘M could act on a box in a tab you had clicked earlier but weren't looking at. The header button now always toggles its own tab's box, and ⇧⌘M only follows the focus to a pane that is on screen

## 0.12.19-beta

### New

- **Zoom the panel you clicked.** ⌘= / ⌘- / ⌘0 now act on the last panel you clicked: a terminal (each side-by-side pane separately), the message box, an editor pane, or the file tree. With nothing clicked yet they act on the current terminal, as before. Settings → General still sets the default terminal size for new terminals

### Fixed

- A click inside the message box can no longer be mistaken for a click on the terminal behind it (terminal hit-testing now uses the visible area and skips text editors). Logged under `terminal` if it ever happens, to chase the remaining "dropped letters after switching tabs" report

## 0.12.18-beta

### Changed

- The toolbar strip shows only the Mac AIminal runs on (clock, date, CPU, memory). Remote load, memory and GPU readings stay on each machine's page

## 0.12.17-beta

### New

- **Clock and machine stats in the toolbar.** Time to the second, the date, this Mac's CPU and memory, and, while you look at a remote session or machine, that machine's load per core, memory and each GPU's utilization and temperature (`nvidia-smi`). Machine pages show the same with a bar per GPU. Remote numbers come with the existing tmux snapshot, so no extra logins. Settings → General turns the strip off

## 0.12.16-beta

### Changed

- The three container buttons on a machine page now say what they do: **New tmux inside** (tmux lives in the container), **Machine tmux → docker exec** (tmux on the machine, shell in the container), **Shell only** (docker exec, no tmux), each with a one-line caption and a fuller tooltip

## 0.12.15-beta

### New

- **Start tmux sessions inside a container.** The ⊕ next to a container in the sidebar (or right-click → New tmux session inside…), the "new session" card in the container's group on Home, and **tmux inside** on the machine page create the session inside the container (`docker exec <container> tmux new -s …`), so one container can hold several tmux sessions, each with its own Claude. Opening a shell inside the container is in the same right-click menu

## 0.12.14-beta

### Fixed

- A terminal that gets (re)attached to the window no longer takes the keyboard away from a message box or editor you are typing in. Suspected cause of dropped letters in a message box while another pane's Claude was working; this build also logs focus moves (⇧⌘L, categories `terminal` and `compose`) to confirm

## 0.12.13-beta

### Changed

- **Sessions stay under their machine in the sidebar when you open them.** Opening a session used to move it from the machine tree into "Open in AIminal"; now it appears in both places, so the machine tree always shows everything that is running there

## 0.12.12-beta

### Fixed

- Clicking the terminal after the message box really moves the keyboard focus now (0.12.11 tried, but looked up the clicked view in the wrong coordinate space)

## 0.12.11-beta

### Fixed

- **Clicking the terminal gives it the keyboard back.** After clicking into the message box (or an editor pane), a click on the terminal didn't move the focus there, so you had to use ⌘↩ or a tab switch to get back

## 0.12.10-beta

### Fixed

- **Korean typing in the message box dropped letters again** (0.12.7 to 0.12.9): while the input method was composing a syllable, a routine refresh could overwrite the box with its last saved text. The box is now left alone whenever a syllable is being composed. Reproduced and verified with a simulated input-method sequence

## 0.12.9-beta

### Fixed

- **Send + Enter now always empties the box.** The text is read straight from the box (including a syllable the Korean input method is still composing) and the box is cleared directly, instead of going through SwiftUI state, which the input method could override

## 0.12.8-beta

### Fixed

- **Split panes are first-class.** Every pane of a split view now has its own **Message for Claude** button and box, and ⇧⌘M / ⌘↩ go to the pane you last clicked or typed in, not always the left one
- **The box really clears after Send + Enter.** Sending now resets the input method's state too, so a syllable the Korean IME was still composing can't come back
- Removed the old "Termoor is now AIminal" notice from the README and guide

## 0.12.7-beta

### Fixed

- **Send + Enter left the text in the box** after typing Korean, and the last syllable could be missing from what was sent: the input method still held that syllable as "composing". The box now commits it before sending and clears properly

### Changed

- **"Message for Claude" is a button.** Every terminal has a slim bar with a **Message for Claude** button (or **Multi-line input** where Claude isn't running); click it or press ⇧⌘M to unfold the text box, ✕ to fold it. The bar shows the first line of an unsent draft. The box no longer takes space until you ask for it

## 0.12.6-beta

### Fixed

- The multi-line box showed icon-only buttons even in a wide pane; it now drops the hint text first and the labels only in a narrow pane

## 0.12.5-beta

### Changed

- **The multi-line input box is now always there** under every terminal (hide or show it with the ✎ button in the session header or ⇧⌘M; the choice is remembered). Drafts are still kept per tab

### Fixed

- **Korean (and other IME) typing in the multi-line box and the file editor no longer drops letters.** The editor re-coloured the text on every keystroke, which interrupted the input method while it was composing a syllable; it now waits until the syllable is committed

## 0.12.4-beta

### New

- **Resizable split panes.** Drag the divider between side-by-side (or stacked) panes to change their size; the split menu has **Equal Sizes**. Up to six panes now (the current terminal plus five), instead of four
- The multi-line input box shows icon-only buttons when its pane is narrow

## 0.12.3-beta

### New

- **Multi-line input box** (⇧⌘M, or the ✎ button under the terminal). Write long prompts with Markdown and code blocks below the terminal, preview them, and send them with **Send + Enter** (⌘↩) as one message, or **Send** to paste without Enter. The text is pasted as one block (tmux paste buffer, or the terminal's own paste), so Claude Code gets line breaks instead of an early submit. Drafts are kept per tab; drag the top edge to resize

## 0.12.2-beta

### New

- **Presets in iCloud Drive, one file per Mac.** The folder button next to **Presets** in the sidebar saves your presets to a folder you pick (iCloud Drive/AIminal by default) as `AIminal presets (<Mac name>).json`, and keeps it updated. On another Mac, **Load from Folder** lists each Mac's file; choose **Merge** or **Replace**. Nothing is loaded automatically, so each Mac's own presets stay as they are

## 0.12.1-beta

### New

- **Claude model badge.** Every Claude badge (home cards, session header, window cards; tooltip in the sidebar and tabs) now says which model that Claude is using, like **Claude · Fable 5.1**. AIminal reads it from Claude Code's own session files on each machine and container (`~/.claude/sessions` plus the last reply in the transcript), never the conversation or tokens
- **Happy remote mode** (phone screen) now shows working/waiting too, using Claude Code's own busy/idle state instead of the hidden screen

### Fixed

- **Korean (non-ASCII) session names and folders on remote machines.** macOS turned them into decomposed characters on the way to `ssh`, so tmux on a Linux server reported "session not found" for rename, /exit and new sessions. Every command now goes through the same byte-safe path the file browser already used
- An upload whose target folder doesn't exist (or isn't writable) now fails with the server's message right away instead of hanging in the transfer list
- A command that printed a lot to stderr could hang the refresh forever; stderr is now read concurrently
- **Unsaved edits are no longer lost silently.** Closing a tab, "Close All Panes", or quitting AIminal first asks to save each changed file; if a terminal ends on its own, its unsaved editor panes move to the next tab
- The updater refuses a release that has no checksum file instead of installing it unverified

## 0.12.0-beta

### Aiminal is now spelled AIminal

Same app, same name, capital **AI**: the app is a terminal for AI agents, and the name now says so at a glance. Nothing else changes.

- **Updating is automatic.** Aiminal 0.11 (and Termoor or Initia) update themselves like any other release; on its first launch the app renames itself to AIminal.app
- Settings stay in `~/.config/aiminal` and logs in `~/Library/Logs/AIminal/aiminal.log`; notification permission, presets, open tabs and the sidebar layout carry over
- The GitHub repository is now [hyeok-jong/AIminal](https://github.com/hyeok-jong/AIminal). The old links and install commands keep working
- Install command: `curl -fsSL https://raw.githubusercontent.com/hyeok-jong/AIminal/beta/install.sh | bash`

## 0.11.0-beta

### Termoor is now Aiminal

Same app, new name, one more time. "Termoor" turned out to be taken by another tmux app (termoor.app, tmux on iPad) and sits one letter from Termora, an existing terminal. **Aiminal** (AI + terminal) is unique and says what this app is for: a terminal for many tmux sessions on many machines, with Claude Code agents running in them.

- **Updating is automatic.** Termoor (and Initia) update themselves to Aiminal like any other update. On its first launch the app renames itself to Aiminal.app
- **Everything carries over**: settings, presets and snippets move from `~/.config/termoor` (or `~/.config/initia`) to `~/.config/aiminal`, with links left at the old paths; notification permission, open tabs and the sidebar layout stay as they were
- The GitHub repository is now [hyeok-jong/Aiminal](https://github.com/hyeok-jong/Aiminal). Old links and the old install commands keep working
- New install command: `curl -fsSL https://raw.githubusercontent.com/hyeok-jong/Aiminal/beta/install.sh | bash`. It also removes an old Termoor.app or Initia.app next to it
- Logs now live in `~/Library/Logs/Aiminal/aiminal.log`, and the ssh config backup is `~/.ssh/config.aiminal-backup`

## 0.10.0-beta

### Initia is now Termoor

Same app, new name. Termoor is a terminal for people who run many tmux sessions on many machines, often with several Claude Code agents, and it deserved a name that says so (and that no other tool already uses).

- **Updating is automatic.** Initia updates itself to Termoor like any other update. On its first launch the app renames itself to Termoor.app
- **Everything carries over**: settings, presets and snippets move from `~/.config/initia` to `~/.config/termoor` (a link is left at the old path), and notification permission, open tabs and the sidebar layout stay as they were
- The GitHub repository is now [hyeok-jong/Termoor](https://github.com/hyeok-jong/Termoor). Old links and the old install command keep working
- New install command: `curl -fsSL https://raw.githubusercontent.com/hyeok-jong/Termoor/beta/install.sh | bash`. It also removes an old Initia.app next to it

## 0.9.3-beta

### New

- **Split without dragging.** ⌘D opens a new terminal beside the current one, in the same machine and folder; ⇧⌘D opens it below. The new split button in the session header also opens any tab, or any session that isn't open yet, beside the current one
- **Side by side or stacked**: switch the layout from the split button
- **Syntax colors in the editor** for shell, Python, JavaScript/TypeScript, C-family, Go, Rust, Swift, YAML, JSON, HTML, SQL and Dockerfiles
- Panes beside the terminal show which machine and container they're on
- **New screenshots** in the README showing the file tree, editor, side-by-side terminals and transfers

## 0.9.2-beta

### Changes

- **Clicking a file in the file tree only selects it**; it no longer types the path into the terminal. To insert a path, right-click → **Insert Path** (or **Insert as @mention** in a Claude session)

## 0.9.1-beta

### New

- **Choose where downloads go.** Right-click a file or folder → **Download To…** to pick any folder (Initia starts in the last one you used). **Download to Downloads** still saves in one click. On this Mac, **Copy To…** copies a file or folder anywhere

## 0.9.0-beta

### New

- **Edit files without vim.** Double-click a text file in the file tree (`.md`, `.html`, `.sh`, `.py`, `.json`, `.yaml`, and more) to open it beside the terminal. Markdown opens as a rendered preview (tables, task lists, code blocks) and HTML has a preview too. ⌘S saves back to this Mac, the SSH machine or the container, and Initia warns you if the file changed since you opened it
- **Terminals side by side.** Drag a tab onto the terminal, or right-click a tab → Open Beside Current Tab, to see up to four terminals and files at once
- **Progress bar for transfers**, with the size, percent and a Cancel button
- **The file tree is now shown by default** (⇧⌘E still hides it)

## 0.8.1-beta

### Fixes

- **File tree: downloading files with Korean (or other non-English) names from a Linux server failed** with "Cannot stat: No such file or directory". macOS changed the name's Unicode form on its way to the server, so the server didn't recognize it. Names now reach the server byte for byte, for downloads, uploads, folder listings and opening in VS Code

## 0.8.0-beta

### New: file tree

- **A folder tree beside the terminal** (⇧⌘E, or the sidebar button in the session header), like VS Code's Explorer. It follows the session's current folder and works on this Mac, SSH machines and docker containers
- **Click a file** to type its path into the terminal (no Enter). In a Claude session it types `@path`, so Claude reads the file
- **Double-click** to open: the default app on this Mac, VS Code Remote on an SSH machine (if VS Code is installed), or a downloaded copy
- **Download and upload**: right-click → Download to Downloads, or drop files and folders from Finder onto a folder to upload. Folders work too, and Initia asks before replacing anything. Transfers run over Initia's existing SSH connection with `tar`, so nothing needs to be installed on the server
- Right-click also has Copy Path, Copy Relative Path, cd Here and Show in Finder; the header has Parent folder, Go to the terminal's folder, hidden files and Refresh

## 0.7.3-beta

### Fixes

- **Dragging in the sidebar now actually reorders.** Machines and sessions could be dragged but snapped back, because the sidebar list swallowed the drop. The machine section now uses the list's own reordering: drag an SSH machine to move it among machines, or a session to move it within its machine or container (an insertion line shows where it lands). This Mac stays at the top

## 0.7.2-beta

### New

- **Drag to reorder** machines, sessions (within a machine or container), presets and the tabs at the top. The order is saved, and Home follows it
- **Home sections collapse**: click a machine or container heading to fold it, or use Expand all / Collapse all at the top. What you fold is remembered
- **Clearer hierarchy**: on Home, a machine's containers now sit inside the machine's section, indented with a colored line ("research (docker, in gpu-box)"). In the sidebar, child rows are indented further with stronger guide lines

## 0.7.1-beta

### New

- **Claude account.** Machine pages, container rows and Claude session headers show which account Claude Code is signed in with there, and its plan (for example `you@example.com · Max 5x`). Read from `~/.claude.json` on each machine and container; tokens are never read
- **User guide**: [GUIDE.md](GUIDE.md) and a Korean edition, [GUIDE.ko.md](GUIDE.ko.md)
- **Help menu**: Initia Guide, Keyboard Shortcuts, Release Notes and Show Logs. The guide and shortcuts are in the ⌘K palette too

## 0.7.0-beta

### New: keyboard and navigation

- **Hold ⌘** to see every keyboard shortcut, with tab numbers shown on the tabs
- **⌘K command palette**: search sessions (including those inside containers), machines, presets and commands, then press Enter
- **Zoom the terminal** with ⌘= / ⌘- and reset with ⌘0
- **Tabs**: ⌘1…⌘8 jump to a tab, ⌘9 to the last one, ⇧⌘] / ⇧⌘[ for next/previous; ⌘W closes the current tab like Ctrl-b d (the session keeps running)
- ⇧⌘H goes Home, ⌃⌘S shows or hides the sidebar, and the new Go menu lists all of these

### Sidebar

- Machines are clearly grouped: a divider between machines, bold machine names, and guide lines that show what sits under each machine and container
- **Containers collapse** like machines (collapsed by default) and still show Claude and attention badges when collapsed
- **Expand all / Collapse all** buttons next to "Machines (SSH)"; what you expand or collapse is remembered

## 0.6.9-beta

### Changes

- **An update button that is always there.** The toolbar (and the menu bar popover) has an update button: when a new version exists it reads "Update to <version>" and installs it in one click; otherwise it checks right away and tells you whether you are up to date
- Update notifications appear at most once a day; in between, the button and the sidebar banner show that an update is waiting
- The sidebar section is now "Machines (SSH)" and its button "Add machine (SSH)". Containers sit under their machine, and the tmux sessions inside a container sit under the container

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
