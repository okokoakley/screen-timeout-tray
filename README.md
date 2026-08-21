# 🔵 Screen Timeout Tray Toggle

A lightweight Windows 11 system tray tool that lets you quickly toggle the AC monitor timeout between 1 minute and "never" with a single click.

![License](https://img.shields.io/badge/license-MIT-blue)
![Platform](https://img.shields.io/badge/platform-Windows%2011-lightgrey)
![PowerShell](https://img.shields.io/badge/PowerShell-5.1+-blue)
![Size](https://img.shields.io/github/size/okokoakley/screen-timeout-tray/ScreenTimeoutTray.ps1)

---

## 🎯 Why?

Windows 11 buries the screen timeout setting deep in **Settings > System > Power & battery**. If you frequently switch between "keep screen on" (presenting, monitoring) and "save power" (stepping away), this tray icon saves you clicks.

**Before:** 5 clicks through Settings  
**After:** 1 click on the tray icon ✨

---

## ✨ Features

| Feature | Description |
|---------|-------------|
| 🖱️ **One-click toggle** | Left-click the tray icon to switch between 1-minute and never timeout |
| 🎨 **Visual indicator** | Orange circle = 1 min, Green circle = Never |
| 📋 **Right-click menu** | Set specific timeout, refresh status, or exit |
| 📌 **Auto-promote** | Tray icon stays visible in the taskbar (not hidden) |
| 📝 **Logging** | Activity logged to `ScreenTimeoutTray.log` |
| 💾 **Zero dependencies** | Pure PowerShell, no installation required |

---

## 🚀 Quick Start

### Option 1: Run directly

```powershell
powershell.exe -NoProfile -STA -ExecutionPolicy Bypass -WindowStyle Hidden -File ScreenTimeoutTray.ps1
```

### Option 2: Use the launcher (Recommended)

Double-click `Start-ScreenTimeoutTray.cmd` — it starts the tray app and auto-promotes the icon to the taskbar.

### Option 3: Auto-start with Windows

1. Press `Win + R`, type `shell:startup`, press Enter
2. Place a shortcut to `Start-ScreenTimeoutTray.cmd` in the Startup folder

---

## 📸 How It Looks

```
┌─────────────────────────────────────┐
│  Windows Taskbar                    │
│  ┌───┐                              │
│  │ 🟢 │  ← Green = Never timeout    │
│  └───┘                              │
│      or                             │
│  ┌───┐                              │
│  │ 🟠 │  ← Orange = 1 min timeout   │
│  └───┘                              │
└─────────────────────────────────────┘
```

**Right-click menu:**
```
┌─────────────────────────────────────┐
│ Current: AC screen never off        │
│─────────────────────────────────────│
│ Set AC screen off after 1 minute    │
│ Set AC screen never off             │
│─────────────────────────────────────│
│ Refresh status                      │
│ Exit                                │
└─────────────────────────────────────┘
```

---

## 🔧 How It Works

The app reads and modifies the Windows power plan's `VIDEOIDLE` setting using `powercfg.exe`:

- **AC power (plugged in):** Toggles between 1 minute (60 seconds) and never (0 seconds)
- Tray icon color indicates current state
- Right-click menu provides explicit set options

---

## 📁 Files

| File | Description |
|------|-------------|
| `ScreenTimeoutTray.ps1` | Main tray application |
| `Promote-ScreenTimeoutTray.ps1` | Promotes tray icon to taskbar visibility |
| `Start-ScreenTimeoutTray.cmd` | Launcher script (start app + promote icon) |
| `LICENSE` | MIT License |
| `README.md` | This file |

---

## 📋 Requirements

- Windows 11 (should work on Windows 10 as well)
- PowerShell 5.1+
- No admin rights required

---

## 🤝 Contributing

Contributions are welcome! Feel free to open issues or submit pull requests.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

---

## 📄 License

This project is licensed under the MIT License — see the [LICENSE](LICENSE) file for details.

---

## 🙏 Credits

Created by [Oakley](https://github.com/okokoakley) — bakery owner by day, tinkerer by night 🍞💻

---

## ⭐ Star this repo

If you find this useful, please give it a star! It helps others discover the project.
