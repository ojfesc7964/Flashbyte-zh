<div align="center">
    <img src="./media/app_icon.png" alt="Flashbyte Logo" width="200" height="200"/>
    <h1>Flashbyte (Chinese fork)</h1>
    <h3>A simple and fast local file transfer tool</h3>
</div>

<p align="center">
  <img src="https://img.shields.io/badge/version-3.1.4-blue?style=for-the-badge" alt="Version"/>
  <img src="https://img.shields.io/badge/flutter-3.47.7-blue?logo=flutter&style=for-the-badge" alt="Flutter"/>
  <img src="https://img.shields.io/badge/license-MIT-green?style=for-the-badge" alt="License"/>
</p>

<p align="center">
  <a href="README.md">简体中文</a> · <b>English</b>
</p>

> This repository is the Chinese-localized fork of [Flashbyte](https://github.com/iamsami101/Flashbyte), based on upstream `v3.1.4`.
> What this fork is, how it differs from upstream, the file list and the sync workflow are all documented in [About this fork](#about-this-fork) at the end of this file.

## Features

- **TLS encryption**: send over an encrypted connection, with peer identity checked by certificate fingerprint.
- **Cross-platform**: Android, iOS, Windows, macOS and Linux talk to each other.
- **Local network only**: works without Wi-Fi access; a hotspot between two devices is enough.
- **Lossless, no size limit**: raw bytes, any file type, any size.
- **No external server**: connections are plain TCP inside your network.
- **Batches and resume**: offer many files at once, accept or decline them together, pause / resume / cancel the whole batch, and continue interrupted files from the received offset.
- **Several send sources**: files, folders, and clipboard text (the receiver writes it back to its clipboard).
- **Trusted devices**: remember a peer by certificate fingerprint and accept its offers automatically.
- **Chinese and English UI**: follow the system language, or pick 简体中文 / English.
- **Open source, no data collected**: all code is public.

## How it works

Flashbyte opens a plain TCP socket between two devices on the local network. Reading and writing happen in a dedicated isolate; the main UI isolate only handles widgets and progress, so the UI stays smooth during large transfers.

Files travel as frames: an 8-byte header (metadata length, payload length) followed by JSON metadata and a binary payload. Metadata carries the commands (offer, accept, pause, progress, complete, ...) and the payload carries file chunks. A batch request lists every file in one metadata block, so the receiver approves the whole batch once.

## Downloads

<!-- BEGIN AUTO RELEASE DOWNLOADS -->
| Platform | Download |
|----------|----------|
| Android | [APK](https://github.com/ojfesc7964/Flashbyte-zh/releases/download/v3.1.4/flashbyte-android.apk) \| [AAB](https://github.com/ojfesc7964/Flashbyte-zh/releases/download/v3.1.4/flashbyte-android.aab) |
| Linux | [TAR](https://github.com/ojfesc7964/Flashbyte-zh/releases/download/v3.1.4/flashbyte-linux-x64.tar.gz) |
| macOS | [DMG](https://github.com/ojfesc7964/Flashbyte-zh/releases/download/v3.1.4/flashbyte-macos.dmg) |
| iOS | [APP](https://github.com/ojfesc7964/Flashbyte-zh/releases/download/v3.1.4/flashbyte-ios-unsigned-runner-app.zip) |
| Windows | [EXE](https://github.com/ojfesc7964/Flashbyte-zh/releases/download/v3.1.4/flashbyte-windows-setup-x64.exe) \| [ZIP](https://github.com/ojfesc7964/Flashbyte-zh/releases/download/v3.1.4/flashbyte-windows-x64.zip) |
<!-- END AUTO RELEASE DOWNLOADS -->

## Contents

- [Features](#features)
- [How it works](#how-it-works)
- [Downloads](#downloads)
- [Screenshots](#screenshots)
- [Installation](#installation)
  - [Android](#android)
  - [Linux](#linux)
  - [Windows](#windows)
  - [macOS](#macos)
  - [iOS](#ios)
- [Signing release builds](#signing-release-builds)
- [Building from source](#building-from-source)
  - [Prerequisites](#prerequisites)
  - [Clone the repository](#clone-the-repository)
  - [Building for Linux](#building-for-linux)
  - [Building for Android](#building-for-android)
  - [Building for iOS](#building-for-ios)
  - [Building for macOS](#building-for-macos)
  - [Building for Windows](#building-for-windows)
  - [Debug builds](#debug-builds)
- [About this fork](#about-this-fork)
  - [Scope and baseline](#scope-and-baseline)
  - [Shared with upstream](#shared-with-upstream)
  - [Changes in this fork](#changes-in-this-fork)
  - [Features removed from upstream](#features-removed-from-upstream)
  - [Dependency differences](#dependency-differences)
  - [Files that differ](#files-that-differ)
  - [Syncing upstream](#syncing-upstream)
  - [Documentation conventions](#documentation-conventions)

---

## Screenshots

<img src="media/previews/mobile-android.png" alt="Flashbyte Android preview" height="300"/> <img src="media/previews/desktop-linux.png" alt="Flashbyte Linux preview" height="300"/>

## Installation

### Android

Download the `.apk` from the [releases](https://github.com/ojfesc7964/Flashbyte-zh/releases) page and open it from a file manager or the browser download page. Installing from a browser requires allowing "install unknown apps" once.

During a transfer the app runs a foreground service with an ongoing notification. On first launch the app asks for notification permission and battery-optimization exemption (see [Changes in this fork](#changes-in-this-fork)); without them the system suspends background transfers.

### Linux

#### Install script (recommended)

```bash
curl -fsSl "https://raw.githubusercontent.com/ojfesc7964/Flashbyte-zh/refs/heads/main/install.sh" | bash
```

Uninstall:

```bash
curl -fsSl "https://raw.githubusercontent.com/ojfesc7964/Flashbyte-zh/refs/heads/main/uninstall.sh" | bash
```

> The script reads the latest `.tar.gz` of the repository named in its own `GITHUB_REPO` variable. To install this fork's build, set `GITHUB_REPO` to `ojfesc7964/Flashbyte-zh` in the script, or use the manual installation below.

#### Manual installation

**1. Download the release**

Grab the latest `flashbyte-linux-x64.tar.gz` from the [releases page](https://github.com/ojfesc7964/Flashbyte-zh/releases).

**2. Extract it**

```bash
mkdir -p ~/.local/share/flashbyte
tar xzf flashbyte-linux-x64.tar.gz -C ~/.local/share/flashbyte
chmod +x ~/.local/share/flashbyte/flashbyte
```

**3. Create a launcher script**

This lets the app find its bundled libraries at runtime:

```bash
mkdir -p ~/.local/bin
cat > ~/.local/bin/flashbyte << 'EOF'
#!/bin/bash
HERE="$HOME/.local/share/flashbyte"
export LD_LIBRARY_PATH="$HERE/lib:$LD_LIBRARY_PATH"
exec "$HERE/flashbyte" "$@"
EOF
chmod +x ~/.local/bin/flashbyte
```

Make sure `~/.local/bin` is on your `PATH`:

```bash
echo $PATH | grep -q "$HOME/.local/bin" && echo "OK" || echo "not on PATH"
```

If it is not, add this line to `~/.bashrc` or `~/.zshrc` and restart the terminal:

```bash
export PATH="$HOME/.local/bin:$PATH"
```

**4. Install the icons**

```bash
for size_dir in ~/.local/share/flashbyte/share/icons/hicolor/*/apps; do
    size_name=$(basename "$(dirname "$size_dir")")
    mkdir -p ~/.local/share/icons/hicolor/"$size_name"/apps
    cp "$size_dir/flashbyte.png" ~/.local/share/icons/hicolor/"$size_name"/apps/flashbyte.png
done
```

**5. Install the desktop entry**

> The desktop entry filename and `StartupWMClass` must match the app's GApplication ID (`com.iamsami.flashbyte`) so GNOME shows the icon and name correctly in the dock.

```bash
mkdir -p ~/.local/share/applications
cat > ~/.local/share/applications/com.iamsami.flashbyte.desktop << EOF
[Desktop Entry]
Type=Application
Name=Flashbyte
Comment=LAN file sharing app
Comment[zh_CN]=局域网文件共享应用
Exec=$HOME/.local/bin/flashbyte
Icon=flashbyte
Categories=Network;
Terminal=false
StartupWMClass=com.iamsami.flashbyte
EOF
chmod +x ~/.local/share/applications/com.iamsami.flashbyte.desktop
rm -f ~/.local/share/applications/flashbyte.desktop
```

**6. Refresh the desktop caches**

```bash
update-desktop-database ~/.local/share/applications
gtk-update-icon-cache ~/.local/share/icons/hicolor
```

**7. Run it**

Launch **Flashbyte** from the application menu, or run:

```bash
flashbyte
```

#### Uninstalling manually

```bash
rm -rf ~/.local/share/flashbyte
rm -f ~/.local/bin/flashbyte
rm -f ~/.local/share/applications/com.iamsami.flashbyte.desktop
rm -f ~/.local/share/applications/flashbyte.desktop
rm -f ~/.local/share/icons/hicolor/*/apps/flashbyte.png
update-desktop-database ~/.local/share/applications
gtk-update-icon-cache ~/.local/share/icons/hicolor
```

### Windows

Download the setup wizard `flashbyte-windows-setup-x64.exe` or the portable `flashbyte-windows-x64.zip` from the [releases](https://github.com/ojfesc7964/Flashbyte-zh/releases) page.

**Installer (recommended):** run the wizard and follow it, then launch Flashbyte from the Start menu or the desktop shortcut. To remove it, use **Settings > Apps**. The installer UI is available in Simplified Chinese.

**Portable:** extract the zip, then run:

```powershell
flashbyte.exe
```

If SmartScreen warns about an unknown publisher, choose **More info → Run anyway**. Release builds are signed with a self-signed certificate, so Windows cannot fully trust the signature; remove the warning with a trusted code-signing certificate (see [Signing release builds](#signing-release-builds)). Delete the extracted folder to remove the portable build.

### macOS

Download `flashbyte-macos.dmg` from the [releases](https://github.com/ojfesc7964/Flashbyte-zh/releases) page.

Open the DMG, drag **flashbyte.app** into **Applications**, then launch it from Applications.

If macOS blocks the app because it is not signed / notarized, open **System Settings > Privacy & Security** and allow Flashbyte, or right-click the app and choose **Open**.

### iOS

The current iOS artifact is an unsigned `Runner.app` zip. It is useful for CI output and local signing, but it cannot be installed on a normal iPhone directly.

To install on a device, build and sign from source with an Apple Developer account:

```bash
flutter build ipa --release
```

Then distribute the signed `.ipa` through TestFlight, Apple Configurator, or your own MDM / internal distribution.

## Signing release builds

The workflow builds every platform artifact and packages macOS as a DMG, but platform signing needs private certificates and provisioning files stored as GitHub Actions secrets.

- **Android**: add an upload keystore and configure Gradle signing with `ANDROID_KEYSTORE_BASE64`, `ANDROID_KEYSTORE_PASSWORD`, `ANDROID_KEYSTORE_ALIAS` and `ANDROID_KEY_PASSWORD`.
- **macOS**: use an Apple Developer ID Application certificate plus notarization credentials, usually `APPLE_DEVELOPER_ID_APPLICATION_CERTIFICATE_BASE64`, `APPLE_DEVELOPER_ID_APPLICATION_CERTIFICATE_PASSWORD`, `APPLE_TEAM_ID`, `APPLE_ID` and `APPLE_APP_SPECIFIC_PASSWORD`.
- **iOS**: use an Apple Distribution certificate and provisioning profile, usually `APPLE_DISTRIBUTION_CERTIFICATE_BASE64`, `APPLE_DISTRIBUTION_CERTIFICATE_PASSWORD`, `IOS_PROVISIONING_PROFILE_BASE64` and `APPLE_TEAM_ID`.
- **Windows**: the workflow signs `flashbyte.exe` and the Inno Setup installer with a fresh self-signed certificate on every run. That keeps the binaries tamper-evident but still triggers SmartScreen. For a trusted signature, obtain a Windows code-signing certificate and use `signtool` in the workflow, usually stored as `WINDOWS_CERTIFICATE_BASE64` and `WINDOWS_CERTIFICATE_PASSWORD`.

## Building from source

Install Flutter and set up the toolchain for the platform(s) you target.

### Prerequisites

- **Flutter SDK** (stable channel, the workflow pins `3.47.7`) — [install instructions](https://docs.flutter.dev/get-started/install)
- **Git**

Verify the setup:

```bash
flutter doctor
```

Resolve what it reports (missing Android SDK, missing Linux toolchain, ... — covered per platform below).

### Clone the repository

```bash
git clone https://github.com/ojfesc7964/Flashbyte-zh.git
cd Flashbyte-zh
flutter pub get
dart pub get -C packages/flashbyte_core
```

---

### Building for Linux

**Additional prerequisites:**

```bash
sudo apt update
sudo apt install clang cmake ninja-build pkg-config libgtk-3-dev
```

Enable Linux desktop support if needed:

```bash
flutter config --enable-linux-desktop
```

Build a release bundle:

```bash
flutter build linux --release
```

Output:

```bash
build/linux/x64/release/bundle/
```

That `bundle/` folder is exactly what the `.tar.gz` release contains: `data/`, `lib/`, the `flashbyte` executable, and `share/` with icons and the desktop file. Run it directly:

```bash
cd build/linux/x64/release/bundle
./flashbyte
```

Or follow the [manual installation](#manual-installation) steps above using this `bundle/` folder as the source.

---

### Building for Android

**Additional prerequisites:**

- Android SDK ([Android Studio](https://developer.android.com/studio) or command-line tools)
- A configured `ANDROID_HOME`
- At least one accepted SDK license:

```bash
flutter doctor --android-licenses
```

Build a release APK:

```bash
flutter build apk --release
```

Output:

```bash
build/app/outputs/flutter-apk/app-release.apk
```

Install it on a connected device or emulator:

```bash
flutter install
```

Or copy the APK to the device and install it manually (it is not distributed through the Play Store, so "install from unknown sources" must be allowed).

Split per architecture (smaller files):

```bash
flutter build apk --split-per-abi --release
```

This produces one APK per ABI (`armeabi-v7a`, `arm64-v8a`, `x86_64`) in the same output folder.

---

### Building for iOS

**Additional prerequisites:**

- macOS
- Xcode
- CocoaPods
- An Apple Developer account for installing on a device or creating a distributable IPA

Check the setup:

```bash
flutter doctor
```

Build an unsigned release app (CI / artifact checks):

```bash
flutter build ios --release --no-codesign
```

Build a signed IPA once certificates and a provisioning profile are configured:

```bash
flutter build ipa --release
```

The unsigned app is usually under:

```bash
build/ios/iphoneos/Runner.app
```

The signed IPA is usually under:

```bash
build/ios/ipa/
```

---

### Building for macOS

**Additional prerequisites:**

- macOS
- Xcode
- CocoaPods

Enable macOS desktop support if needed:

```bash
flutter config --enable-macos-desktop
```

Build a release app:

```bash
flutter build macos --release
```

Output:

```bash
build/macos/Build/Products/Release/Flashbyte.app
```

For distribution beyond your machine, sign and notarize the app, then package it as a DMG.

---

### Building for Windows

**Additional prerequisites:**

- Windows
- Visual Studio with the "Desktop development with C++" workload

Enable Windows desktop support if needed:

```powershell
flutter config --enable-windows-desktop
```

Build a release app:

```powershell
flutter build windows --release
```

Output:

```powershell
build\windows\x64\runner\Release\
```

Zip that folder to distribute a portable build. The repository ships an [Inno Setup](https://jrsoftware.org/isinfo.php) script at `windows/installer/flashbyte.iss`; the release workflow uses it to build a signed **setup wizard** (`flashbyte-windows-setup-x64.exe`) with a Simplified Chinese installer UI. For wider distribution, sign with a trusted Windows code-signing certificate.

---

### Debug builds

Drop `--release` for development and testing:

```bash
flutter run
```

Flutter detects a connected device (or asks you to choose one) and hot-reloads on changes.

---

## About this fork

### Scope and baseline

| Item | Value |
|---|---|
| Upstream repository | <https://github.com/iamsami101/Flashbyte> |
| This fork | <https://github.com/ojfesc7964/Flashbyte-zh> |
| Baseline | upstream `v3.1.4` (`pubspec.yaml` version `3.1.4+0`, kept in sync with upstream version numbers) |
| Policy | Stay protocol-compatible and follow upstream features where possible; localization, desktop window handling, native platform integration, transfer robustness and the release pipeline are maintained here |

The fork speaks the same protocol as upstream (`flashbyte-discovery-v1` and the frame protocol), so both sides interoperate. Differences are limited to UI language, desktop window behaviour, native platform channels, transfer robustness and the release pipeline.

### Shared with upstream

Identical to upstream `3.1.4`:

- Discovery and transfer protocol: UDP broadcast discovery, long-lived TCP connections, frame format and command set
- TLS switch, certificate fingerprint verification, identity exchanged on first connection
- Trusted device list (keyed by certificate fingerprint) and "Always accept from…"
- Device-name reset and receiver name editing
- Android reads only `content://` URIs through SAF; plain paths are read directly
- Release workflow skeleton: five build jobs, self-signed Windows artifacts, automatic changelog sectioning, `body_path: release-body.md`

### Changes in this fork

#### 1. Chinese and localization

- `lib/l10n/app_localizations.dart`: every UI string in Chinese and English
- `lib/app/controllers/app_locale_controller.dart` plus a "Language" setting: follow system / Simplified Chinese / English, applied immediately and persisted
- Notification channel names and descriptions follow the language setting
- iOS / macOS permission strings localized (`Runner/{Base,zh-Hans}.lproj/InfoPlist.strings`)
- macOS Chinese menu (`Runner/zh-Hans.lproj/MainMenu.strings`)
- Android in-app strings localized (`res/values-zh/strings.xml`, foreground-service notification)
- `fastlane/metadata/android/zh-CN/` store listing, Chinese `windows/installer/flashbyte.iss` UI, `install.sh` / `uninstall.sh` printing Chinese when `LANG` says so, Chinese `Comment` in the `.desktop` entry

#### 2. Desktop window and single instance

- `lib/platform/window_state_manager.dart` persists and restores window position, size and maximized state
- The Linux / Windows / macOS native layers no longer show the window on the first frame; Dart restores geometry and then calls `show()`; macOS / Windows fade in over roughly 160 ms
- A restored position outside every visible display falls back to centered; when geometry is unavailable the previous position is kept
- macOS: clicking the dock icon restores a minimized or background window (`applicationShouldHandleReopen`)
- Windows: `main.cpp` adds a single-instance mutex; a second launch only raises the existing window
- Linux: switched to `G_APPLICATION_HANDLES_COMMAND_LINE`, so a second process forwards activation to the running instance

#### 3. Sending and receiving

- Clipboard sending: `lib/services/transfer/clipboard_text_file.dart` writes clipboard text to a temporary file; the receiver uses the `clipboard` flag to assemble it in memory and put it back on its clipboard instead of writing a file
- Batch offers: many files offered once and approved once; the session page offers accept all / decline all and pause all / resume all / cancel all
- Resumable transfers: the receiver keeps unfinished data in a partial file and continues from the received offset; `finalizeFile` turns it into the destination file once complete
- Per-file cards in the session page: queued, waiting for approval, transferring, paused, completed and cancelled each have their own state and actions
- In-session send entries: clipboard / file / folder, without going back to the picker page
- Actionable notifications: batch progress notifications and accepting or declining an offer from the notification; offers handled while the app is backgrounded are recorded in `SocketService` so the approval page is not shown again when the app returns
- Renaming a device pushes `update_peer_info` to the connected peer immediately

#### 4. Transfer robustness and safety

- `packages/flashbyte_core/lib/protocol/frame_protocol.dart`: frame limits (4 MiB metadata, 32 MiB payload) and a bounded read buffer; exceeding them closes the connection instead of buffering without limit
- Serialized frame writes: every frame on one socket is queued on a single future, so heartbeats can no longer race a chunk and hit `StreamSink is bound to a stream`
- Write-failure memory: `isFrameWriterFailed` lets the heartbeat fail fast instead of awaiting a write that can never succeed
- `packages/flashbyte_core/lib/utils/file_utils.dart`: file-name sanitizing (strip path separators to prevent directory traversal, replace characters Windows rejects, prefix reserved Windows device names, truncate by UTF-8 bytes)
- Discovery: per-source rate limit (60 messages per second window), 64 device cap, broadcast interval 2 s → 5 s, strict hello validation, serialized `stop` operations
- `tls_identity_service.dart`: RSA generation moved to a worker isolate so first launch does not block the first frame; concurrent callers share one generation
- `socket_service.dart`: `stopConnectionGracefully` has a 4 s timeout; only fatal errors end the session state; a resume reconnect no longer sends `transfer_cancelled`, so the receiver keeps its partial file
- Broadcast failures no longer catch `SocketException` only — other exceptions are skipped and retried on the next heartbeat

#### 5. Device names

- The device name defaults to the device model (internal model codes fall back to brand / hostname); the random two-word name is gone
- `packages/flashbyte_core/lib/utils/device_name.dart`: name rules (sanitize, length, validation)
- Names received from discovered peers are sanitized as well

#### 6. Android native integration

- Three upstream plugin dependencies replaced with native code: `disable_battery_optimization` → the `flashbyte/battery_optimization` channel; Android file picking uses native `ACTION_OPEN_DOCUMENT` (`flashbyte/documents`) instead of a plugin that copies files into the cache; `process_run` → `dart:io` `Process.run`
- `MainActivity.kt` exposes four channels:
  - `flashbyte/documents`: system document picker (multi-select) and `content://` metadata (`pickDocuments` / `statUri`)
  - `flashbyte/battery_optimization`: battery-optimization exemption state and opening the app info page
  - `flashbyte/foreground_service`: start / stop the foreground service during transfers
  - `flashbyte/storage`: free-space precheck before receiving
- `TransferForegroundService.kt` plus `res/values{,-zh}/strings.xml`: foreground notification during transfers (`dataSync` type)
- `AndroidManifest.xml`: declares the foreground service and its permissions; upstream's `READ_EXTERNAL_STORAGE` and `REQUEST_INSTALL_PACKAGES` are gone, and `allowBackup` / `fullBackupContent` are disabled
- `lib/widgets/background_permission_gate.dart`: on launch, checks notification permission and battery-optimization exemption and blocks the UI with a non-dismissible overlay until both are granted (upstream showed a dismissible one-time prompt instead)

#### 7. iOS / macOS

- `ios/Runner/Info.plist`: upstream's `NSLocationWhenInUseUsageDescription` removed (location is no longer needed)
- `ios/Runner/AppDelegate.swift`: registers the `flashbyte/battery_optimization` channel; on iOS "Background App Refresh" stands in for the battery-optimization exemption
- `macos/Runner/Info.plist`: `CFBundleLocalizations` declares `en` / `zh-Hans`
- `macos/Runner/MainFlutterWindow.swift`: starts fully transparent and fades in after Dart restores geometry, avoiding a black flash and a position jump

#### 8. Tests and CI

- `packages/flashbyte_core/test/`: new tests for device-name rules, frame limits, write serialization and file-name sanitizing
- `test/app/device_name_test.dart`: app-level device-name tests
- `.github/workflows/ci.yml`: manual trigger (`workflow_dispatch`), reduced to analyze plus app and core tests
- `.github/workflows/release.yml`: adds a `verify` job; the Windows build downloads the Inno Setup Chinese language file; the download table is written into both `README.md` and `README-en.md` and the job fails when either file lacks the markers

### Features removed from upstream

| Feature | Upstream | This fork |
|---|---|---|
| Receiving files shared from other apps | `receive_sharing_intent` (Android share intents plus text-to-`.txt`) | **Removed**: the app no longer appears in the share sheet; sending starts inside the app with a file / folder / clipboard pick |
| Desktop drag and drop | `desktop_drop` (drop files into the window to queue them) | **Removed**: only the in-app clipboard / file / folder buttons |
| Random two-word device names | `lib/utils/two_random_words.dart` plus `random_words.dart` | **Removed**: the device model is used by default, and the name can be edited or reset |
| Dismissible battery-optimization prompt | Launch dialog with "Not now" and "Do not show again" | **Changed** into a launch gate: until notification permission and the exemption are granted, a non-dismissible overlay guides to system settings |

### Dependency differences

`pubspec.yaml` compared with upstream:

| Change | Dependency | Reason |
|---|---|---|
| Removed | `desktop_drop` | drag-and-drop feature removed |
| Removed | `receive_sharing_intent` | system-share receiving removed |
| Removed | `disable_battery_optimization` | replaced by the native `flashbyte/battery_optimization` channel |
| Removed | `process_run` | replaced by `dart:io` `Process.run` (`file_preview_widget.dart`) |
| Removed | `windowed_file_reader` | never referenced by any Dart code upstream |
| Added | `flutter_localizations` (SDK) | UI localization |
| Added | `screen_retriever` | verifies that a restored window is still on a visible display |

Every other dependency (`window_manager`, `saf`, `fast_file_picker`, `awesome_notifications`, `device_info_plus`, ...) matches upstream.

### Files that differ

Scope: file-by-file comparison against the upstream `v3.1.4` source (excluding `.git`, `build`, `.dart_tool`, `.idea`, `.vscode`, `Pods`, `ephemeral` and binary artifacts).

#### Added by this fork (25)

| File | Purpose |
|---|---|
| `README-en.md` | English documentation (this file) |
| `CHANGELOG-en.md` | English changelog (mirror of `CHANGELOG.md`) |
| `lib/l10n/app_localizations.dart` | Chinese and English strings |
| `lib/app/controllers/app_locale_controller.dart` | Language controller |
| `lib/app/device_name.dart` | Device-name normalization and validation |
| `lib/platform/window_state_manager.dart` | Window geometry persistence and fade-in |
| `lib/widgets/background_permission_gate.dart` | Notification and battery-optimization gate |
| `lib/services/platform/android_document_service.dart` | System document picker and `statUri` |
| `lib/services/platform/android_storage_service.dart` | Free-space precheck |
| `lib/services/platform/transfer_foreground_service.dart` | Foreground service (Dart side) |
| `lib/services/transfer/clipboard_text_file.dart` | Clipboard text temporary file |
| `packages/flashbyte_core/lib/utils/device_name.dart` | Device-name rules (core) |
| `packages/flashbyte_core/test/device_name_rules_test.dart` | Device-name rule tests |
| `test/app/device_name_test.dart` | App-level device-name tests |
| `android/app/src/main/kotlin/com/flashbyte/TransferForegroundService.kt` | Transfer foreground service |
| `android/app/src/main/res/values/strings.xml` | Foreground notification strings (English) |
| `android/app/src/main/res/values-zh/strings.xml` | Foreground notification strings (Chinese) |
| `ios/Runner/Base.lproj/InfoPlist.strings` | iOS permission strings (English) |
| `ios/Runner/zh-Hans.lproj/InfoPlist.strings` | iOS permission strings (Chinese) |
| `macos/Runner/Base.lproj/InfoPlist.strings` | macOS permission strings (English) |
| `macos/Runner/zh-Hans.lproj/InfoPlist.strings` | macOS permission strings (Chinese) |
| `macos/Runner/zh-Hans.lproj/MainMenu.strings` | macOS Chinese menu |
| `fastlane/metadata/android/zh-CN/full_description.txt` | Store long description (Chinese) |
| `fastlane/metadata/android/zh-CN/short_description.txt` | Store short description (Chinese) |
| `fastlane/metadata/android/zh-CN/changelogs/2.txt` | Store changelog (Chinese) |

#### Upstream only (3)

| File | Notes |
|---|---|
| `lib/services/sharing/incoming_share_service.dart` | System-share receiving (feature removed) |
| `lib/utils/two_random_words.dart` | Random two-word device names (replaced by the device model) |
| `packages/flashbyte_core/lib/identity/random_words.dart` | Word list for the above |

#### Modified (49)

| Group | Files |
|---|---|
| Docs | `README.md`, `CHANGELOG.md` |
| CI and release | `.github/workflows/ci.yml`, `.github/workflows/release.yml`, `windows/installer/flashbyte.iss`, `install.sh`, `uninstall.sh`, `linux/com.iamsami.flashbyte.desktop`, `.gitignore` |
| Dependencies | `pubspec.yaml`, `pubspec.lock` |
| Android | `android/app/src/main/AndroidManifest.xml`, `android/app/src/main/kotlin/com/flashbyte/MainActivity.kt`, `lib/services/platform/android_connection_notification_service.dart`, `lib/services/platform/android_saf_service.dart` |
| iOS / macOS | `ios/Runner.xcodeproj/project.pbxproj`, `ios/Runner/AppDelegate.swift`, `ios/Runner/Info.plist`, `macos/Runner.xcodeproj/project.pbxproj`, `macos/Runner/AppDelegate.swift`, `macos/Runner/Info.plist`, `macos/Runner/MainFlutterWindow.swift` |
| Linux / Windows window | `linux/runner/my_application.cc`, `windows/runner/main.cpp`, `windows/runner/flutter_window.cpp` |
| UI and localization | `lib/main.dart`, `lib/app/app_settings.dart`, `lib/features/settings/settings_page.dart`, `lib/features/transfers/pages/file_selection_page.dart`, `lib/features/transfers/pages/incoming_transfer_offer_page.dart`, `lib/features/transfers/pages/outgoing_transfer_offer_page.dart`, `lib/features/transfers/pages/tcp_chat_page.dart`, `lib/features/transfers/widgets/transfer_widget.dart`, `lib/features/transfers/widgets/file_preview_widget.dart` |
| Transfer, discovery and security | `lib/services/transfer/file_transfer_isolate.dart`, `lib/services/transfer/socket_service.dart`, `lib/services/discovery/device_discovery_service.dart`, `lib/services/security/tls_identity_service.dart`, `lib/services/security/trusted_devices_service.dart` |
| `flashbyte_core` | `lib/protocol/frame_protocol.dart`, `lib/utils/file_utils.dart`, `lib/utils/utils.dart`, `lib/adapters/output_target_adapter.dart`, `lib/identity/device_identity.dart`, `lib/identity/identity.dart` |
| Tests | `packages/flashbyte_core/test/frame_protocol_test.dart`, `packages/flashbyte_core/test/file_utils_test.dart`, `packages/flashbyte_core/test/device_identity_test.dart`, `test/features/transfers/transfer_widget_test.dart` |

### Syncing upstream

1. Fetch the new upstream version and compare it against "Files that differ" above to see which shared files changed
2. Apply upstream features and fixes to `lib/` and `packages/flashbyte_core/`, keeping the localization structure: new UI text goes into `AppLocalizations`, never hard-coded in widgets
3. Never let upstream overwrite:
   - `lib/l10n/`, `lib/app/controllers/app_locale_controller.dart`, `lib/app/device_name.dart`
   - `lib/platform/window_state_manager.dart` and the native window-show timing plus single-instance handling on all three desktop platforms
   - `lib/widgets/background_permission_gate.dart` and the four native channels (documents / battery_optimization / foreground_service / storage)
   - the dual-README download table section and the Inno Setup Chinese language step in `release.yml`
   - `windows/installer/flashbyte.iss`, `install.sh`, `uninstall.sh`, the `.desktop` entry, and the `Base` / `zh-Hans` string files on every platform
   - the removed features (system-share receiving, desktop drag and drop): skip upstream changes to them
4. Bump the `pubspec.yaml` version and record the changes in the `## Unreleased` section of `CHANGELOG.md`
5. Update "Files that differ" whenever files are added or removed

### Documentation conventions

- The download table in `README.md` and `README-en.md` is written by `.github/workflows/release.yml` between a pair of `AUTO RELEASE DOWNLOADS` HTML comment markers in the Downloads section: **do not edit the table by hand**, and keep both markers in both files — the release job fails when one is missing
- Version badges and the artifact names in the installation section follow `pubspec.yaml` and the release workflow
- Each README starts with a language switch line (the current language in bold, the other one linking to its sibling file); do not remove it
- Changelogs come in two files (`CHANGELOG.md` / `CHANGELOG-en.md`). The release workflow moves the `## Unreleased` sections of both into one dated version section: the Chinese entries become the release body, the English entries go into a collapsible English block; every change is a single `- ` line
