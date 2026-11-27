# Changelog

This file records the changes of this fork (the Chinese-localized Flashbyte fork). Version numbers stay in sync with upstream, and entries only cover what differs here; the complete upstream `3.1.4` list is in the [upstream CHANGELOG](https://github.com/iamsami101/Flashbyte/blob/main/CHANGELOG.md).

Kept in sync with the Chinese [`CHANGELOG.md`](CHANGELOG.md). The release workflow bumps both files and turns this file's entries into a collapsible English block in the release notes, so both must be updated in the same change.

## Unreleased

- Removed: receiving files that other apps share to Flashbyte. The Android share intents and the iOS share extension are gone, so the app no longer appears in the system share sheet; files can only be picked from inside the app (file, folder or clipboard)
- Removed: desktop drag and drop (Windows / macOS / Linux); the only send sources are the in-app clipboard / file / folder buttons
- Dependencies: dropped `receive_sharing_intent` and `desktop_drop`, which existed only for the two features above
- Docs: `FORK.md` / `FORK-en.md` merged into `README.md` / `README-en.md`, both READMEs rewritten with a full comparison against upstream
- Docs: this changelog rewritten to describe the fork's own delta
- Docs: added this English mirror next to `CHANGELOG.md`
- Docs: both READMEs start with a language switch entry that jumps between the Chinese and English files

## 3.1.4 - 2026-11-18

The first Chinese release, based on upstream `3.1.4`. That release still contained system-share receiving and desktop drag and drop; both are removed in the `Unreleased` section above.

### Localization

- Added `lib/l10n/app_localizations.dart`: every UI string in Chinese and English
- Added `lib/app/controllers/app_locale_controller.dart`: language controller supporting follow system / Simplified Chinese / English
- Added a "Language" option in Settings; changes apply immediately and persist
- Notification channel names and descriptions refresh with the language setting
- Added `Base` and `zh-Hans` versions of the iOS / macOS permission strings, plus the macOS Chinese menu
- Added Android `res/values-zh/strings.xml` for the foreground-service notification
- Added `fastlane/metadata/android/zh-CN/` store listing; Simplified Chinese installer UI in `windows/installer/flashbyte.iss`; `install.sh` / `uninstall.sh` print Chinese when `LANG` says so; Chinese `Comment` in the `.desktop` entry

### Desktop window

- Added `lib/platform/window_state_manager.dart`: persists and restores window position, size and maximized state
- The Linux / Windows / macOS native layers no longer show the window on the first frame; Dart restores geometry and then shows it; macOS / Windows fade in over roughly 160 ms
- A restored position outside every visible display falls back to centered; when geometry is unavailable the previous position is kept
- macOS: clicking the dock icon restores a minimized or background window
- Windows: a single-instance mutex, so a second launch only raises the existing window
- Linux: switched to `G_APPLICATION_HANDLES_COMMAND_LINE`, so a second process forwards activation to the running instance

### Sending and receiving

- Added clipboard sending: text is written to a temporary file, and the receiver uses the `clipboard` flag to put it back on its clipboard instead of writing a file
- Batch offers: many files offered once and approved once, with accept all / decline all and pause all / resume all / cancel all
- Resumable transfers: the receiver keeps a partial file, continues from the received offset, and finalizes it into the destination file once complete
- Per-file status cards in the session page (queued, waiting for approval, transferring, paused, completed, cancelled)
- In-session send entries for clipboard / file / folder
- Actionable notifications: batch progress and accepting or declining an offer from the notification; offers handled while backgrounded do not show the approval page again when the app returns
- Renaming a device pushes `update_peer_info` to the connected peer immediately

### Transfer robustness

- Frame size limits in the `flashbyte_core` frame protocol (4 MiB metadata, 32 MiB payload) plus a bounded read buffer; exceeding them closes the connection
- Serialized frame writes, so heartbeats no longer race a chunk on the same socket
- Added file-name sanitizing: prevents directory traversal, replaces characters Windows rejects, prefixes reserved device names, truncates by UTF-8 bytes
- Discovery: per-source rate limit, 64 device cap, broadcast interval 2 s → 5 s, strict hello validation, serialized `stop` operations
- TLS key generation moved to a worker isolate so first launch does not block the first frame; concurrent callers share one generation
- Graceful disconnect gains a 4 s timeout; a resume reconnect no longer sends `transfer_cancelled`, so the peer keeps its partial file

### Device names

- The device name defaults to the device model (internal model codes fall back to brand / hostname); the random two-word name is gone
- Added `packages/flashbyte_core/lib/utils/device_name.dart` and `lib/app/device_name.dart`: name sanitizing, length limit and validation
- Names received from discovered peers are sanitized as well

### Platform integration

- Android: replaced `disable_battery_optimization` / `process_run` / `windowed_file_reader` with native channels for document picking (`flashbyte/documents`), battery-optimization state (`flashbyte/battery_optimization`), the foreground service (`flashbyte/foreground_service`) and a free-space precheck (`flashbyte/storage`)
- Android: added `TransferForegroundService` to keep the process alive during transfers; the manifest drops storage and install-package permissions and disables backup
- Android: a non-dismissible overlay checks notification permission and the battery-optimization exemption on launch (upstream showed a dismissible one-time prompt)
- iOS: registered the battery-optimization equivalent channel (Background App Refresh) and removed the no-longer-needed location permission string
- macOS: declared `CFBundleLocalizations`, starts the window transparent and fades it in after the position is restored

### Dependencies

- Added `flutter_localizations` (SDK) and `screen_retriever`
- Removed `receive_sharing_intent`, `desktop_drop`, `disable_battery_optimization`, `process_run`, `windowed_file_reader`

### Tests and CI

- `packages/flashbyte_core/test/`: new tests for device-name rules, frame limits, write serialization and file-name sanitizing
- Added `test/app/device_name_test.dart`
- CI switched to a manual trigger and reduced to analyze plus app and core tests
- The release workflow adds a `verify` job, downloads the Inno Setup Chinese language file, and writes the download table into both `README.md` and `README-en.md`
