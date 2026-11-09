# Initia

**A tmux-native terminal for macOS.** See every tmux session on your Mac and on your servers, watch them live, know when Claude Code is done, and work in them from a built-in terminal.

> Status: **public beta**, free during the beta.

<picture>
  <source media="(prefers-color-scheme: dark)" srcset="screenshots/home-dark.png">
  <img src="screenshots/home.png" alt="Initia home: every tmux session as a card with a live preview and Claude status, with machines and their sessions in the sidebar">
</picture>

<table>
<tr>
<td><picture>
  <source media="(prefers-color-scheme: dark)" srcset="screenshots/overview-dark.png">
  <img src="screenshots/overview.png" alt="Session overview: a live preview of every window, with Exit and terminal controls">
</picture></td>
<td><picture>
  <source media="(prefers-color-scheme: dark)" srcset="screenshots/ssh-host-dark.png">
  <img src="screenshots/ssh-host.png" alt="A remote machine over SSH: its tmux sessions and the editable ssh config entry">
</picture></td>
</tr>
<tr>
<td align="center">Live overview of every window</td>
<td align="center">A remote machine and its tmux sessions</td>
</tr>
</table>

## Why I built Initia

My day runs on tmux. Every project lives in its own tmux session, most of them running Claude Code, and they are spread over several machines: my Mac, a GPU server, a lab server, each reached over SSH and each holding several tmux sessions of its own.

A plain terminal made me do all the bookkeeping by hand. Which session is on which machine? Is Claude in that one done, or still working, or waiting for me? What was the folder and command for that project again? I kept typing `ssh`, then `tmux ls`, then `tmux attach -t …`, over and over.

Initia is the app I wanted for that:

- **Manage tmux sessions comfortably.** Every session is a card with a live preview. Open, rename, split into windows, or close it in a click, and closing a tab never kills the work
- **Presets for the things you start every day.** A machine, a folder and a startup command (like `claude`) become one click, or start on their own when Initia launches
- **Know when Claude is done.** Initia sees which sessions run Claude Code and whether it is working or waiting, and notifies you when it finishes, even on a remote server
- **Many machines, one window.** Your `~/.ssh/config` machines sit next to this Mac. Connect once and see every tmux session running on each of them, and open any of them in a tab
- **A home, not just a terminal.** Start from an overview of everything that is running, then dive into a session in Initia's own terminal

## Features

- **Home**: a start screen with a card for every session, live previews, and a summary of what's running
- **Built-in terminal**: open any tmux session in a real terminal inside Initia, with a tab for each one. Closing a tab only detaches. Plain terminals without tmux work too (⌘T)
- **Claude Code aware**: see which sessions run Claude and whether it is working or waiting. Get a notification when Claude finishes, and quit it cleanly with **Exit** (`/exit`, then end the session)
- **Machines**: this Mac and your `~/.ssh/config` machines side by side in the sidebar. Connect (key or password) to see and open each machine's tmux sessions, and add or edit machines in the app. Initia keeps one SSH session per machine, so your server sees a single login
- **Snippets**: one-click buttons under the terminal that type text for you (`/clear`, `/compact`, …)
- **Manage tmux**: create sessions; rename sessions and windows; create and close windows
- **Opens in Initia by default**, and still one click away in iTerm2, Terminal, cmux, Ghostty, WezTerm, kitty or Alacritty
- **Presets and autostart**: save a machine, folder and startup command, and bring your sessions up at login
- **Automatic updates**: Initia checks for new versions and updates itself in one click. Your tmux sessions keep running
- **Menu bar and Dock**, English and Korean UI

## Install

Requires macOS 15 or later (Apple Silicon or Intel) and [tmux](https://github.com/tmux/tmux) (`brew install tmux`).

```sh
curl -fsSL https://raw.githubusercontent.com/hyeok-jong/Initia/beta/install.sh | bash
```

The script downloads the latest release, verifies its checksum, and installs Initia to `/Applications` (or `~/Applications`).

**Manual install:** download `Initia-<version>.zip` from [Releases](https://github.com/hyeok-jong/Initia/releases) and unzip it into `/Applications`. Initia is not notarized by Apple yet, so the first launch is blocked. Allow it in **System Settings → Privacy & Security → Open Anyway**, or run:

```sh
xattr -dr com.apple.quarantine /Applications/Initia.app
```

## Presets

A preset is a session you start often: a machine, a folder, and a startup command. Start it in one click from Home, or mark it **autostart** to bring it up when Initia launches. A new install comes with an `example` preset that opens Claude Code in your home folder; edit or delete it in the sidebar.

Presets are stored in `~/.config/initia/config.json`, so you can also write them by hand:

```json
"presets": [
  { "name": "api-server", "path": "~/dev/api-server", "command": "claude", "autostart": true },
  { "name": "notebook", "path": "~/research", "command": "jupyter lab", "device": "gpu-box" }
]
```

`device` is the machine's `Host` name from `~/.ssh/config`. Leave it out for this Mac.

## Configuration

Settings live in `~/.config/initia/config.json`. Open the Settings window with ⌘,.

**Logs:** errors and warnings go to `~/Library/Logs/Initia/initia.log`. Open the log viewer with ⇧⌘L.

**SSH:** Initia reads hosts from `~/.ssh/config`. When you edit a host in Initia, only the lines you change are rewritten, and the previous file is kept as `~/.ssh/config.initia-backup`. Initia never stores passwords: if a host needs one, you log in once in a terminal tab and Initia reuses that connection for 30 minutes.

**cmux:** by default, cmux accepts socket connections only from processes it started itself. To let Initia open workspaces in cmux, go to cmux **Settings → Automation**, set socket access to `password`, and enter the same password in Initia under **Settings → Terminals**.

## Feedback

Report bugs and request features in [Issues](https://github.com/hyeok-jong/Initia/issues).

## License

Initia is proprietary software, free to use during the beta. See [LICENSE](LICENSE).
