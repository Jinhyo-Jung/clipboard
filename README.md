# ClipboardApp (macOS)

[한국어 README](README.ko.md)

Keyboard-first clipboard history app for macOS. Open history with `Ctrl + Option + V`, select with keyboard, and paste instantly.

![App Icon](docs/images/앱아이콘.png)

## Quick Overview
- Open history panel: `⌃⌥V`
- Navigate: `↑/↓`, `⌘1..9`
- Paste: `Enter`
- Delete: `⌘⌫` (delete all: `⇧⌘⌫`)
- Auto screenshot capture: stores new screenshots from `⌘⇧5`

## Install & Run (Non-Developers)

### 0) Download Release Files
The easiest way is GitHub **Releases**.

1. Open the repository **Releases** tab.
2. Download from the latest release **Assets**:
   - `ClipboardApp-installer.pkg` (recommended)
   - `ClipboardApp.app.zip` or `ClipboardApp.app` (if provided)

If there is no release yet, download files directly from the `dist/` folder on branch `release/mac-clipboard-v1.0.0`.

### 1) Files
- Installer: `dist/ClipboardApp-installer.pkg`
- Direct app run: `dist/ClipboardApp.app`

### 2) Recommended Install
1. Double-click `dist/ClipboardApp-installer.pkg`
2. Run `/Applications/ClipboardApp.app`

![Installer Screen](docs/images/설치화면.png)

### 3) If macOS Blocks the App
For free-distribution builds (without notarization), macOS may show a warning.

1. Right-click app in Finder → `Open`
2. Allow execution in System Settings > Privacy & Security

## Screenshots

### History Panel
![History Panel](docs/images/window.png)

### Settings Window
![Settings Window](docs/images/clipboard_설정창.png)

## Permissions
- Auto-paste requires Accessibility permission.
- Without permission, the app still copies to clipboard and users can paste manually with `⌘V`.

---

## Developer Guide

### Run Locally
```bash
cd /Users/kkongwang/Documents/clipboard
swift run ClipboardApp
```

### Build Artifacts
```bash
./scripts/build_app_bundle.sh
./scripts/package_installer_pkg.sh
```

Artifacts:
- `dist/ClipboardApp.app`
- `dist/ClipboardApp-installer.pkg`

### Distribution Upload Source
- Release upload files are generated under `dist/`.
- In free mode, `dist/` files can also be downloaded directly from GitHub.

### (Optional) Sign & Notarize (Paid Apple Developer Account)
```bash
./scripts/sign_and_notarize.sh
```

### CI Release Templates
- `fastlane/Fastfile`
- `.github/workflows/release.yml`

## Add Images to README
1. Put image files in `docs/images/`
2. Reference in Markdown

```md
![Description](docs/images/filename.png)
```

3. Commit and push.
