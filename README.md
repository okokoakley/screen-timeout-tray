# Screen Timeout Tray Toggle

A lightweight Windows 11 system tray tool that lets you quickly toggle the AC monitor timeout between 1 minute and "never" with a single click.

![License](https://img.shields.io/badge/license-MIT-blue)
![Platform](https://img.shields.io/badge/platform-Windows%2011-lightgrey)

## Why?

Windows 11 buries the screen timeout setting deep in Settings > System > Power & battery. If you frequently switch between "keep screen on" (e.g., presenting, monitoring) and "save power" (e.g., stepping away), this tray icon saves you clicks.

## Features

- **One-click toggle** — Left-click the tray icon to switch between 1-minute and never timeout
- **Visual indicator** — Orange circle = 1 min, Green circle = Never
- **Right-click menu** — Set specific timeout, refresh status, or exit
- **Auto-promote** — Tray icon stays visible in the taskbar (not hidden)
- **Logging** — Activity logged to `ScreenTimeoutTray.log`
- **Zero dependencies** — Pure PowerShell, no installation required

## Quick Start

### Option 1: Run directly

```powershell
powershell.exe -NoProfile -STA -ExecutionPolicy Bypass -WindowStyle Hidden -File ScreenTimeoutTray.ps1
```

### Option 2: Use the launcher

Double-click `Start-ScreenTimeoutTray.cmd` — it starts the tray app and auto-promotes the icon to the taskbar.

### Option 3: Auto-start with Windows

1. Press `Win + R`, type `shell:startup`, press Enter
2. Place a shortcut to `Start-ScreenTimeoutTray.cmd` in the Startup folder

## How It Works

The app reads and modifies the Windows power plan's `VIDEOIDLE` setting using `powercfg.exe`:

- **AC power (plugged in)**: Toggles between 1 minute (60 seconds) and never (0 seconds)
- Tray icon color indicates current state
- Right-click menu provides explicit set options

## Files

| File | Description |
|------|-------------|
| `ScreenTimeoutTray.ps1` | Main tray application |
| `Promote-ScreenTimeoutTray.ps1` | Promotes tray icon to taskbar visibility |
| `Start-ScreenTimeoutTray.cmd` | Launcher script (start app + promote icon) |

## Requirements

- Windows 11 (should work on Windows 10 as well)
- PowerShell 5.1+
- No admin rights required

## License

MIT — feel free to use, modify, and share.

## Credits

Created by [Oakley](https://github.com/okokoakley) —bakery owner by day, tinkerer by night 🍞💻
