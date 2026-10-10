# zellij-claude-setup

Terminal setup copied from my main MacBook: Zellij, the Claude Code status line and settings, and the WezTerm config they run in. Target is macOS with Homebrew.

## What is here

| Path | Installs to | What it is |
| --- | --- | --- |
| `zellij/config.kdl` | `~/.config/zellij/config.kdl` | Zellij config and keybinds (written by Zellij 0.43.1) |
| `zellij/layouts/dev.kdl` | `~/.config/zellij/layouts/dev.kdl` | Layout with only the tab bar, tabs `claude`, `editor`, `music` |
| `shell/zellij-session.zsh` | appended to `~/.zshrc` | `zell` alias, `start [dir]` and `stop` functions |
| `bin/ncspot-autostart.sh` | `~/.local/bin/ncspot-autostart.sh` | Starts playback once ncspot is up, called by `start` |
| `claude/statusline-command.sh` | `~/.claude/statusline-command.sh` | Status line: folder, git branch, model, 5 hour usage bar |
| `claude/settings.json` | merged into `~/.claude/settings.json` | Status line, theme, fullscreen TUI, hooks, plugins, model |
| `wezterm/wezterm.lua` | `~/.wezterm.lua` | Catppuccin Mocha, MesloLGS Nerd Font Mono 17, no tab bar |

## Instructions for the agent setting this up

Back up any file before replacing it (copy to `<name>.bak`). Do not overwrite anything without looking at what is there first.

1. Install the tools that are missing:
   ```sh
   brew install zellij jq neovim ncspot
   brew install --cask wezterm font-meslo-lg-nerd-font
   ```
   `ncspot` is only needed for the `music` tab. If it is not wanted, remove that tab from `dev.kdl` and the `nohup` and `disown` lines from `start`.
2. Copy `zellij/config.kdl` and `zellij/layouts/dev.kdl` to `~/.config/zellij/`. If the installed Zellij is newer than 0.43.1 and rejects the config, keep the machine's own `config.kdl` and only make sure it does not set `simplified_ui true`.
3. Copy `bin/ncspot-autostart.sh` to `~/.local/bin/` and make it executable.
4. Append `shell/zellij-session.zsh` to `~/.zshrc`, unless `start` and `stop` are already defined there.
5. Copy `claude/statusline-command.sh` to `~/.claude/`.
6. Merge `claude/settings.json` into `~/.claude/settings.json`. Keep keys that exist only on the target machine, and take this repo's value where both define one. This file sets `permissions.defaultMode` to `bypassPermissions`, confirm with the user before applying that key.
7. Install the plugins named in `enabledPlugins` from the `claude-plugins-official` marketplace (`anthropics/claude-plugins-official`): `clangd-lsp` and `vercel`.
8. Copy `wezterm/wezterm.lua` to `~/.wezterm.lua`.
9. Run `zellij kill-all-sessions --yes`, open a new WezTerm window and run `start`. The tab bar should show arrow shaped tabs and there should be no key hint bar at the bottom. Claude Code should show the folder, model and usage bar under the prompt.

## Not included

- Personal skills in `~/.claude/skills` and the global `~/.claude/CLAUDE.md`
- `~/.claude/settings.local.json`, which only holds hooks for the `impeccable` skill
- Raycast settings, export those from Raycast with Export Settings & Data
