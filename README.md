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
   - `ClipboardApp-v1.1.0.pkg` (recommended)
   - `ClipboardApp-v1.1.0.app.zip` or `ClipboardApp-v1.1.0.app` (if provided)

If there is no release yet, download files directly from the `dist/` folder on branch `release/mac-clipboard-v1.1.0`.

### 1) Files
- Installer: `dist/ClipboardApp-v1.1.0.pkg`
- Direct app run: `dist/ClipboardApp-v1.1.0.app`

### 2) Recommended Install
1. Double-click `dist/ClipboardApp-v1.1.0.pkg`
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

## Troubleshooting: Auto-paste does not paste into the focused field

If ClipboardApp does not paste immediately with `Enter` or double-click (but manual `⌘V` works), reset macOS permission caches and grant permissions again.

1. Get the app bundle identifier:
   ```bash
   defaults read /Applications/ClipboardApp.app/Contents/Info CFBundleIdentifier
   ```
2. Reset permission caches (`<BUNDLE_ID>` = output from step 1):
   ```bash
   tccutil reset Accessibility <BUNDLE_ID>
   tccutil reset AppleEvents <BUNDLE_ID>
   ```
3. Re-launch `ClipboardApp.app`, then re-enable:
   - Privacy & Security > Accessibility
   - Privacy & Security > Automation (System Events), if prompted

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
- `dist/ClipboardApp-v1.1.0.app`
- `dist/ClipboardApp-v1.1.0.pkg`

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
