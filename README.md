# Initia

**A tmux-native terminal for macOS.** Browse every tmux session, watch it live, and work in it from a built-in terminal. Or open it in iTerm2, Terminal or cmux with one click.

> Status: **public beta**, free during the beta.

## Features

- **Built-in terminal**: open any tmux session in a real terminal inside Initia, with a tab for each one. Closing a tab only detaches
- **Session browser**: every tmux session with its attach state, folder, running command, pane title (for example, what Claude Code is working on), and last activity
- **Live overview**: the terminal contents of every window, refreshed every 2 seconds
- **Manage tmux**: create sessions from a folder; rename sessions and windows; create and close windows
- **Open anywhere**: iTerm2, Terminal, cmux, Ghostty, WezTerm, kitty, Alacritty
- **Presets and autostart**: save a folder and a startup command, and bring your sessions up at login
- **Menu bar and Dock**: quick access from the menu bar, plus a full window
- English and Korean UI

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

## Configuration

Settings live in `~/.config/initia/config.json`. Open the Settings window with ⌘,.

**cmux:** by default, cmux accepts socket connections only from processes it started itself. To let Initia open workspaces in cmux, go to cmux **Settings → Automation**, set socket access to `password`, and enter the same password in Initia under **Settings → Terminals**.

## Feedback

Report bugs and request features in [Issues](https://github.com/hyeok-jong/Initia/issues).

## License

Initia is proprietary software, free to use during the beta. See [LICENSE](LICENSE).
