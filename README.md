<div align="center">
    <img src="./media/app_icon.png" alt="Flashbyte Logo" width="200" height="200"/>
    <h1>Flashbyte 中文分支</h1>
    <h3>简单、快速的局域网文件传输工具</h3>
</div>

<p align="center">
  <img src="https://img.shields.io/badge/version-3.1.4-blue?style=for-the-badge" alt="Version"/>
  <img src="https://img.shields.io/badge/flutter-3.47.7-blue?logo=flutter&style=for-the-badge" alt="Flutter"/>
  <img src="https://img.shields.io/badge/license-MIT-green?style=for-the-badge" alt="License"/>
</p>

> 本仓库是 [Flashbyte](https://github.com/iamsami101/Flashbyte) 的中文本地化分支，代码基线为上游 `v3.1.4`。
> 分支定位、与上游的差异、文件清单和同步流程集中写在文末的 [本分支说明](#本分支说明)。

## 特性

- **TLS 加密**：可用加密连接发送文件，按证书指纹校验对端身份。
- **跨平台**：Android、iOS、Windows、macOS、Linux 之间互传。
- **局域网直连**：不依赖 Wi-Fi 接入，热点直连也可传输。
- **无损、无大小限制**：按原始字节传输，支持任意类型与任意大小的文件。
- **不经过外部服务器**：只使用本地网络建立 TCP 连接。
- **批量与续传**：多文件一次发起、一次批准，可整体暂停 / 继续 / 取消；中断后按已接收位置续传。
- **多种发送入口**：文件、文件夹、粘贴板文本（接收端直接写回粘贴板）。
- **可信设备**：按证书指纹记住设备，之后自动接受其文件请求。
- **中英双语**：跟随系统，或手动切换简体中文 / English。
- **开源、不收集数据**：全部代码公开。

## 工作原理

Flashbyte 使用纯 TCP socket 在两台局域网设备之间建立连接，连接的读写发生在独立的 isolate 中，主 UI isolate 只负责界面与进度，因此大文件传输时界面保持流畅。

文件按「帧」传输：每帧由 8 字节头（元数据长度、负载长度）加上 JSON 元数据与二进制负载组成。元数据描述命令（发起请求、接受、暂停、进度、完成等），负载是文件分块。批量请求把多个文件的条目放在一条元数据里，接收方一次批准整批。

## 下载

<!-- BEGIN AUTO RELEASE DOWNLOADS -->
| 平台 | 下载 |
|----------|----------|
| Android | [APK](https://github.com/ojfesc7964/Flashbyte-zh/releases/download/v3.1.4/flashbyte-android.apk) \| [AAB](https://github.com/ojfesc7964/Flashbyte-zh/releases/download/v3.1.4/flashbyte-android.aab) |
| Linux | [TAR](https://github.com/ojfesc7964/Flashbyte-zh/releases/download/v3.1.4/flashbyte-linux-x64.tar.gz) |
| macOS | [DMG](https://github.com/ojfesc7964/Flashbyte-zh/releases/download/v3.1.4/flashbyte-macos.dmg) |
| iOS | [APP](https://github.com/ojfesc7964/Flashbyte-zh/releases/download/v3.1.4/flashbyte-ios-unsigned-runner-app.zip) |
| Windows | [EXE](https://github.com/ojfesc7964/Flashbyte-zh/releases/download/v3.1.4/flashbyte-windows-setup-x64.exe) \| [ZIP](https://github.com/ojfesc7964/Flashbyte-zh/releases/download/v3.1.4/flashbyte-windows-x64.zip) |
<!-- END AUTO RELEASE DOWNLOADS -->

## 目录

- [特性](#特性)
- [工作原理](#工作原理)
- [下载](#下载)
- [截图](#截图)
- [安装说明](#安装说明)
  - [Android](#android)
  - [Linux](#linux)
  - [Windows](#windows)
  - [macOS](#macos)
  - [iOS](#ios)
- [签署发布构建](#签署发布构建)
- [从源码构建](#从源码构建)
  - [前置要求](#前置要求)
  - [克隆仓库](#克隆仓库)
  - [构建 Linux 版本](#构建-linux-版本)
  - [构建 Android 版本](#构建-android-版本)
  - [构建 iOS 版本](#构建-ios-版本)
  - [构建 macOS 版本](#构建-macos-版本)
  - [构建 Windows 版本](#构建-windows-版本)
  - [调试构建](#调试构建)
- [本分支说明](#本分支说明)
  - [定位与基线](#定位与基线)
  - [与上游一致的部分](#与上游一致的部分)
  - [本分支的改动](#本分支的改动)
  - [相对上游移除的功能](#相对上游移除的功能)
  - [依赖差异](#依赖差异)
  - [文件差异清单](#文件差异清单)
  - [与上游同步流程](#与上游同步流程)
  - [文档维护约定](#文档维护约定)

---

## 截图

<img src="media/previews/mobile-android.png" alt="Flashbyte Android preview" height="300"/> <img src="media/previews/desktop-linux.png" alt="Flashbyte Linux preview" height="300"/>

## 安装说明

### Android

从 [Releases](https://github.com/ojfesc7964/Flashbyte-zh/releases) 页面下载 `.apk`，用文件管理器或浏览器下载页打开并安装。首次从浏览器安装需要在系统中允许「安装未知应用」。

传输期间应用会启动前台服务并显示常驻通知；首次启动时应用会要求放行通知权限与电池优化（见 [本分支的改动](#本分支的改动)），否则后台传输会被系统挂起。

### Linux

#### 安装脚本（推荐）

```bash
curl -fsSl "https://raw.githubusercontent.com/ojfesc7964/Flashbyte-zh/refs/heads/main/install.sh" | bash
```

卸载：

```bash
curl -fsSl "https://raw.githubusercontent.com/ojfesc7964/Flashbyte-zh/refs/heads/main/uninstall.sh" | bash
```

> 脚本通过 GitHub API 下载脚本内 `GITHUB_REPO` 变量所指仓库的最新 `.tar.gz`。要安装本分支的构建，请把脚本中的 `GITHUB_REPO` 改为 `ojfesc7964/Flashbyte-zh`，或直接使用下面的手动安装。

#### 手动安装

**1. 下载发布包**

从 [Releases 页面](https://github.com/ojfesc7964/Flashbyte-zh/releases) 获取最新的 `flashbyte-linux-x64.tar.gz`。

**2. 解压**

```bash
mkdir -p ~/.local/share/flashbyte
tar xzf flashbyte-linux-x64.tar.gz -C ~/.local/share/flashbyte
chmod +x ~/.local/share/flashbyte/flashbyte
```

**3. 创建启动器脚本**

应用运行时需要能找到随包附带的动态库：

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

确认 `~/.local/bin` 在 `PATH` 中：

```bash
echo $PATH | grep -q "$HOME/.local/bin" && echo "OK" || echo "not on PATH"
```

不在的话，把下面一行加到 `~/.bashrc` 或 `~/.zshrc` 后重开终端：

```bash
export PATH="$HOME/.local/bin:$PATH"
```

**4. 安装图标**

```bash
for size_dir in ~/.local/share/flashbyte/share/icons/hicolor/*/apps; do
    size_name=$(basename "$(dirname "$size_dir")")
    mkdir -p ~/.local/share/icons/hicolor/"$size_name"/apps
    cp "$size_dir/flashbyte.png" ~/.local/share/icons/hicolor/"$size_name"/apps/flashbyte.png
done
```

**5. 安装桌面入口**

> 桌面入口文件名与 `StartupWMClass` 必须与应用 GApplication ID（`com.iamsami.flashbyte`）一致，GNOME 才能在 Dock 中正确显示图标与应用名称。

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

**6. 刷新桌面缓存**

```bash
update-desktop-database ~/.local/share/applications
gtk-update-icon-cache ~/.local/share/icons/hicolor
```

**7. 运行**

从应用菜单启动 **Flashbyte**，或直接运行：

```bash
flashbyte
```

#### 手动卸载

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

从 [Releases](https://github.com/ojfesc7964/Flashbyte-zh/releases) 页面下载安装向导 `flashbyte-windows-setup-x64.exe` 或便携版 `flashbyte-windows-x64.zip`。

**安装程序（推荐）：** 运行向导并按提示操作，然后从开始菜单或桌面快捷方式启动。要移除，使用 **设置 > 应用**。安装界面支持简体中文。

**便携版：** 解压 zip 后运行：

```powershell
flashbyte.exe
```

如果 SmartScreen 提示发布者未知，选择 **更多信息 → 仍要运行**。发布包使用自签名证书签名，Windows 无法完全信任该签名；要消除提示需使用受信任的代码签名证书（参见 [签署发布构建](#签署发布构建)）。便携版删除解压后的文件夹即可。

### macOS

从 [Releases](https://github.com/ojfesc7964/Flashbyte-zh/releases) 页面下载 `flashbyte-macos.dmg`。

打开 DMG，把 **flashbyte.app** 拖进 **Applications**，再从应用程序启动。

如果 macOS 因未签名 / 未公证而拦截，打开 **系统设置 > 隐私与安全性** 允许 Flashbyte，或右键点击应用选择 **打开**。

### iOS

当前的 iOS 产物是未签名的 `Runner.app` zip，适合 CI 产物检查与本地签名，不能直接装到普通 iPhone 上。

要在设备上安装，请用 Apple 开发者账号从源码构建并签名：

```bash
flutter build ipa --release
```

然后通过 TestFlight、Apple Configurator 或自有 MDM / 内部分发渠道分发签名后的 `.ipa`。

## 签署发布构建

工作流会构建各平台产物并把 macOS 打包为 DMG，但平台签名需要私有证书与描述文件，应存放在 GitHub Actions secrets 中。

- **Android**：准备上传密钥库，并用 `ANDROID_KEYSTORE_BASE64`、`ANDROID_KEYSTORE_PASSWORD`、`ANDROID_KEYSTORE_ALIAS`、`ANDROID_KEY_PASSWORD` 配置 Gradle 签名。
- **macOS**：使用 Apple Developer ID Application 证书与公证凭据，通常为 `APPLE_DEVELOPER_ID_APPLICATION_CERTIFICATE_BASE64`、`APPLE_DEVELOPER_ID_APPLICATION_CERTIFICATE_PASSWORD`、`APPLE_TEAM_ID`、`APPLE_ID`、`APPLE_APP_SPECIFIC_PASSWORD`。
- **iOS**：使用 Apple Distribution 证书与描述文件，通常为 `APPLE_DISTRIBUTION_CERTIFICATE_BASE64`、`APPLE_DISTRIBUTION_CERTIFICATE_PASSWORD`、`IOS_PROVISIONING_PROFILE_BASE64`、`APPLE_TEAM_ID`。
- **Windows**：当前工作流用每次运行新建的自签名证书签署 `flashbyte.exe` 与 Inno Setup 安装程序，可保证二进制未被篡改，但仍会触发 SmartScreen。要使用受信任证书，准备 Windows 代码签名证书并在工作流中用 `signtool` 签名，通常为 `WINDOWS_CERTIFICATE_BASE64`、`WINDOWS_CERTIFICATE_PASSWORD`。

## 从源码构建

需要安装 Flutter，并按目标平台准备好工具链。

### 前置要求

- **Flutter SDK**（stable 频道，工作流固定 `3.47.7`）— [安装说明](https://docs.flutter.dev/get-started/install)
- **Git**

安装完成后验证：

```bash
flutter doctor
```

先解决它报告的问题（缺 Android SDK、缺 Linux 工具链等，下面按平台说明）。

### 克隆仓库

```bash
git clone https://github.com/ojfesc7964/Flashbyte-zh.git
cd Flashbyte-zh
flutter pub get
dart pub get -C packages/flashbyte_core
```

---

### 构建 Linux 版本

**额外前置要求：**

```bash
sudo apt update
sudo apt install clang cmake ninja-build pkg-config libgtk-3-dev
```

启用 Linux 桌面支持（未启用时）：

```bash
flutter config --enable-linux-desktop
```

构建发布版：

```bash
flutter build linux --release
```

产物位于：

```bash
build/linux/x64/release/bundle/
```

这个 `bundle/` 目录就是 `.tar.gz` 发布包的内容——包含 `data/`、`lib/`、`flashbyte` 可执行文件，以及带图标与桌面文件的 `share/`。可以直接运行：

```bash
cd build/linux/x64/release/bundle
./flashbyte
```

也可以按上面的 [手动安装](#手动安装) 步骤，用这个 `bundle/` 作为来源代替下载包。

---

### 构建 Android 版本

**额外前置要求：**

- Android SDK（[Android Studio](https://developer.android.com/studio) 或命令行工具）
- 已配置 `ANDROID_HOME`
- 至少接受一次 Android SDK 许可：

```bash
flutter doctor --android-licenses
```

构建发布 APK：

```bash
flutter build apk --release
```

产物位于：

```bash
build/app/outputs/flutter-apk/app-release.apk
```

安装到已连接设备或模拟器：

```bash
flutter install
```

也可以手动把 APK 传到设备安装（未通过 Play 商店分发，需要允许「安装未知来源」）。

按架构拆分（体积更小）：

```bash
flutter build apk --split-per-abi --release
```

同一输出目录会生成每个 ABI 的独立 APK（`armeabi-v7a`、`arm64-v8a`、`x86_64`）。

---

### 构建 iOS 版本

**额外前置要求：**

- macOS
- Xcode
- CocoaPods
- 要在真机安装或生成可分发的 IPA，需要 Apple 开发者账号

检查环境：

```bash
flutter doctor
```

构建未签名发布产物（CI / 产物检查用）：

```bash
flutter build ios --release --no-codesign
```

配置好签名证书与描述文件后构建已签名 IPA：

```bash
flutter build ipa --release
```

未签名产物通常在：

```bash
build/ios/iphoneos/Runner.app
```

已签名 IPA 通常在：

```bash
build/ios/ipa/
```

---

### 构建 macOS 版本

**额外前置要求：**

- macOS
- Xcode
- CocoaPods

启用 macOS 桌面支持（未启用时）：

```bash
flutter config --enable-macos-desktop
```

构建发布版：

```bash
flutter build macos --release
```

产物位于：

```bash
build/macos/Build/Products/Release/Flashbyte.app
```

要在本机之外分发，需签名并公证，再打包为 DMG。

---

### 构建 Windows 版本

**额外前置要求：**

- Windows
- 安装了「使用 C++ 的桌面开发」工作负载的 Visual Studio

启用 Windows 桌面支持（未启用时）：

```powershell
flutter config --enable-windows-desktop
```

构建发布版：

```powershell
flutter build windows --release
```

产物位于：

```powershell
build\windows\x64\runner\Release\
```

压缩该目录内容即可分发便携版。仓库在 `windows/installer/flashbyte.iss` 提供了 [Inno Setup](https://jrsoftware.org/isinfo.php) 脚本，发布工作流用它生成带签名的 **安装向导**（`flashbyte-windows-setup-x64.exe`），安装界面含简体中文。要面向更大范围分发，请用受信任的 Windows 代码签名证书签署。

---

### 调试构建

开发 / 测试时去掉 `--release`：

```bash
flutter run
```

Flutter 会检测已连接设备（或要求选择一台），改动后热重载。

---

## 本分支说明

### 定位与基线

| 项目 | 内容 |
|---|---|
| 上游仓库 | <https://github.com/iamsami101/Flashbyte> |
| 本分支仓库 | <https://github.com/ojfesc7964/Flashbyte-zh> |
| 代码基线 | 上游 `v3.1.4`（`pubspec.yaml` 版本 `3.1.4+0`，与上游版本号保持一致） |
| 维护原则 | 与上游保持协议兼容、功能尽量跟随上游；中文本地化、桌面窗口、平台原生集成、传输健壮性与发布分发改动由本分支维护 |

本分支与上游共用同一套传输协议（`flashbyte-discovery-v1` 与帧协议），两端互通；差异集中在界面语言、桌面窗口行为、平台原生通道、传输健壮性与发布流程。

### 与上游一致的部分

以下与上游 `3.1.4` 相同，本分支未改动行为：

- 发现与传输协议：UDP 广播发现、TCP 长连接、帧格式与命令集
- TLS 开关、证书指纹校验、首次连接时的身份交换
- 可信设备列表（按证书指纹）、「始终接受来自…」
- 设备名重置、接收端设备名编辑
- Android 对 `content://` 只用 SAF 读取，普通路径直接读
- 发布工作流骨架：五个平台的构建任务、自签名 Windows 产物、CHANGELOG 自动分节、`body_path: release-body.md`

### 本分支的改动

#### 1. 中文与多语言

- `lib/l10n/app_localizations.dart`：全部界面文案的中英文取词
- `lib/app/controllers/app_locale_controller.dart` + 设置页「语言」选项：跟随系统 / 简体中文 / English，切换即时生效并持久化
- 通知渠道名称与说明按语言设置刷新
- iOS / macOS 权限弹窗说明中文化（`Runner/{Base,zh-Hans}.lproj/InfoPlist.strings`）
- macOS 中文菜单（`Runner/zh-Hans.lproj/MainMenu.strings`）
- Android 应用内字符串中文化（`res/values-zh/strings.xml`，前台服务通知）
- `fastlane/metadata/android/zh-CN/` 商店文案、`windows/installer/flashbyte.iss` 中文安装界面、`install.sh` / `uninstall.sh` 按 `LANG` 输出中文、`.desktop` 中文 `Comment`

#### 2. 桌面窗口与单实例

- `lib/platform/window_state_manager.dart`：记录并恢复窗口位置、尺寸、最大化状态
- Linux / Windows / macOS 原生层不再在首帧显示窗口，由 Dart 恢复几何后 `show()`；macOS / Windows 显示时约 160 ms 淡入
- 恢复位置不在任何显示器可见区域内时回退居中；拿不到几何信息时沿用上次位置
- macOS：点击 Dock 图标恢复最小化 / 后台窗口（`applicationShouldHandleReopen`）
- Windows：`main.cpp` 增加单实例互斥体，第二次启动只把已有窗口置前
- Linux：改用 `G_APPLICATION_HANDLES_COMMAND_LINE`，第二个进程把激活请求转给已运行实例

#### 3. 发送与接收

- 粘贴板发送：`lib/services/transfer/clipboard_text_file.dart` 把粘贴板文本写成临时文件发送，接收端按 `clipboard` 标记只在内存拼接并写回粘贴板，不落盘
- 批量请求：多文件一次发起、接收方一次批准；会话页可「全部接受 / 全部拒绝」「全部暂停 / 全部继续 / 全部取消」
- 断点续传：接收端把未完成内容写入临时文件（`partial`），中断后按已接收偏移继续，完成后 `finalizeFile` 转成目标文件
- 会话页逐文件卡片：排队、等待批准、传输中、已暂停、完成、取消各有状态与操作
- 会话内发送入口：粘贴板 / 文件 / 文件夹，不需要退回选择页
- 通知栏可操作：批量进度通知、在通知里接受或拒绝请求；应用在后台时批准页还没构建时的请求状态由 `SocketService` 记录，回到前台不会重复弹批准页
- 发送端改名后通过 `update_peer_info` 立即同步给已连接对端

#### 4. 传输健壮性与安全

- `packages/flashbyte_core/lib/protocol/frame_protocol.dart`：帧大小上限（元数据 4 MiB、负载 32 MiB）、读缓冲区上限，超限即断开，避免恶意或异常对端撑爆内存
- 帧写入串行化：同一条 socket 的所有帧排队写入，心跳不再与数据块竞争导致 `StreamSink is bound to a stream`
- 写失败记忆：`isFrameWriterFailed` 让心跳立即失败，而不是等待一个永远不会成功的写
- `packages/flashbyte_core/lib/utils/file_utils.dart`：文件名清洗（去掉路径分隔符防目录穿越、替换 Windows 非法字符、前缀 Windows 保留设备名、按 UTF-8 字节截断长度）
- 发现服务：按来源地址限速（1 秒窗口 60 条）、设备列表上限 64、广播间隔 2 s → 5 s、严格校验 hello 字段、`stop` 系列串行化
- `tls_identity_service.dart`：RSA 生成放进独立 isolate，首启不阻塞首帧；并发调用共享同一次生成
- `socket_service.dart`：`stopConnectionGracefully` 超时兜底（4 s）；只有致命错误才结束会话状态；续传重连不发送 `transfer_cancelled`，避免对端丢弃临时文件
- `device_discovery_service.dart` 与发送端：广播失败不再只捕获 `SocketException`，其它异常同样跳过并重试

#### 5. 设备名

- 设备名默认取设备型号（内部型号码回退到品牌 / 主机名），不再使用随机两词名
- `packages/flashbyte_core/lib/utils/device_name.dart`：名称规则（清洗、长度、校验）
- 发现列表中的设备名同样经过清洗，避免对端发来的异常名称影响 UI

#### 6. Android 原生集成

- 用原生实现替代上游的三个插件依赖：`disable_battery_optimization` → `flashbyte/battery_optimization` 通道；Android 文件选择改用原生 `ACTION_OPEN_DOCUMENT`（`flashbyte/documents`），不再经插件把文件复制到缓存；`process_run` → `dart:io` 的 `Process.run`
- `MainActivity.kt` 提供四个通道：
  - `flashbyte/documents`：系统文档选择器多选、`content://` 元数据查询（`pickDocuments` / `statUri`）
  - `flashbyte/battery_optimization`：电池优化豁免状态查询、打开应用信息页
  - `flashbyte/foreground_service`：传输期间的前台服务启停
  - `flashbyte/storage`：接收前可用空间预检
- `TransferForegroundService.kt` + `res/values{,-zh}/strings.xml`：传输期间的前台通知（`dataSync` 类型）
- `AndroidManifest.xml`：声明前台服务与相关权限；移除了上游的 `READ_EXTERNAL_STORAGE`、`REQUEST_INSTALL_PACKAGES`，并关闭 `allowBackup` / `fullBackupContent`
- `lib/widgets/background_permission_gate.dart`：启动时检查通知权限与电池优化豁免，未放行时用不可穿透的遮罩引导到系统设置（上游是可关闭的一次性提示）

#### 7. iOS / macOS

- `ios/Runner/Info.plist`：移除上游的 `NSLocationWhenInUseUsageDescription`（不再需要定位权限）
- `ios/Runner/AppDelegate.swift`：注册 `flashbyte/battery_optimization` 通道，iOS 用「后台 App 刷新」作为电池优化的等价条件
- `macos/Runner/Info.plist`：`CFBundleLocalizations` 声明 `en` / `zh-Hans`
- `macos/Runner/MainFlutterWindow.swift`：初始透明，Dart 恢复位置后淡入，避免黑屏与位置跳变

#### 8. 测试与 CI

- `packages/flashbyte_core/test/`：新增设备名规则、帧上限、写入串行化、文件名清洗测试
- `test/app/device_name_test.dart`：应用层设备名测试
- `.github/workflows/ci.yml`：改为手动触发（`workflow_dispatch`），任务精简为 analyze + 单元测试 + core 包测试
- `.github/workflows/release.yml`：增加 `verify` 前置任务；Windows 构建下载 Inno Setup 中文语言文件；README 下载表同时写入 `README.md` 与 `README-en.md`，任一文件缺少标记即失败

### 相对上游移除的功能

| 功能 | 上游做法 | 本分支现状 |
|---|---|---|
| 接收其它应用分享的文件 | `receive_sharing_intent` 插件（Android 分享意图 + 文本转 `.txt`） | **已移除**：不在系统分享面板出现，发送只能从应用内选择文件 / 文件夹 / 粘贴板 |
| 桌面拖放发送 | `desktop_drop`（把文件拖进窗口即加入待发送列表） | **已移除**：只用应用内的粘贴板 / 文件 / 文件夹按钮 |
| 随机两词设备名 | `lib/utils/two_random_words.dart` + `random_words.dart` | **已移除**：默认取设备型号，可手动改名或重置 |
| 可关闭的电池优化提示 | 启动弹窗，可「以后再说」并记住选择 | **改为**启动门禁：未放行通知权限 / 电池优化时用遮罩引导，不提供跳过 |

### 依赖差异

`pubspec.yaml` 与上游的差异：

| 变动 | 依赖 | 说明 |
|---|---|---|
| 移除 | `desktop_drop` | 桌面拖放功能一并移除 |
| 移除 | `receive_sharing_intent` | 系统分享接收功能一并移除 |
| 移除 | `disable_battery_optimization` | 改用原生通道 `flashbyte/battery_optimization` |
| 移除 | `process_run` | 改用 `dart:io` 的 `Process.run`（`file_preview_widget.dart`） |
| 移除 | `windowed_file_reader` | 上游未在任何 Dart 代码中引用，直接移除 |
| 新增 | `flutter_localizations`（SDK） | 界面本地化 |
| 新增 | `screen_retriever` | 校验恢复后的窗口是否仍在可见屏幕内 |

其余依赖（`window_manager`、`saf`、`fast_file_picker`、`awesome_notifications`、`device_info_plus` 等）与上游一致。

### 文件差异清单

统计口径：与上游 `v3.1.4` 源码逐文件比对（排除 `.git`、`build`、`.dart_tool`、`.idea`、`.vscode`、`Pods`、`ephemeral` 与二进制产物）。

#### 本分支新增（25）

| 文件 | 用途 |
|---|---|
| `README-en.md` | 英文说明（本文件的英文版） |
| `CHANGELOG-en.md` | 英文更新日志（`CHANGELOG.md` 的镜像） |
| `lib/l10n/app_localizations.dart` | 中英文文案 |
| `lib/app/controllers/app_locale_controller.dart` | 语言控制器 |
| `lib/app/device_name.dart` | 设备名归一化与校验 |
| `lib/platform/window_state_manager.dart` | 窗口位置 / 尺寸持久化与淡入 |
| `lib/widgets/background_permission_gate.dart` | 通知与电池优化门禁 |
| `lib/services/platform/android_document_service.dart` | 系统文档选择器与 `statUri` |
| `lib/services/platform/android_storage_service.dart` | 可用空间预检 |
| `lib/services/platform/transfer_foreground_service.dart` | 前台服务 Dart 侧 |
| `lib/services/transfer/clipboard_text_file.dart` | 粘贴板文本临时文件 |
| `packages/flashbyte_core/lib/utils/device_name.dart` | 设备名规则（core） |
| `packages/flashbyte_core/test/device_name_rules_test.dart` | 设备名规则测试 |
| `test/app/device_name_test.dart` | 应用层设备名测试 |
| `android/app/src/main/kotlin/com/flashbyte/TransferForegroundService.kt` | 传输前台服务 |
| `android/app/src/main/res/values/strings.xml` | 前台服务通知文案（英文） |
| `android/app/src/main/res/values-zh/strings.xml` | 前台服务通知文案（中文） |
| `ios/Runner/Base.lproj/InfoPlist.strings` | iOS 权限说明（英文） |
| `ios/Runner/zh-Hans.lproj/InfoPlist.strings` | iOS 权限说明（中文） |
| `macos/Runner/Base.lproj/InfoPlist.strings` | macOS 权限说明（英文） |
| `macos/Runner/zh-Hans.lproj/InfoPlist.strings` | macOS 权限说明（中文） |
| `macos/Runner/zh-Hans.lproj/MainMenu.strings` | macOS 中文菜单 |
| `fastlane/metadata/android/zh-CN/full_description.txt` | 商店长描述（中文） |
| `fastlane/metadata/android/zh-CN/short_description.txt` | 商店短描述（中文） |
| `fastlane/metadata/android/zh-CN/changelogs/2.txt` | 商店更新日志（中文） |

#### 上游独有（3）

| 文件 | 说明 |
|---|---|
| `lib/services/sharing/incoming_share_service.dart` | 系统分享接收（功能已移除） |
| `lib/utils/two_random_words.dart` | 随机两词设备名（改为设备型号） |
| `packages/flashbyte_core/lib/identity/random_words.dart` | 随机词表（同上） |

#### 修改（49）

| 类别 | 文件 |
|---|---|
| 文档 | `README.md`、`CHANGELOG.md` |
| CI 与发布 | `.github/workflows/ci.yml`、`.github/workflows/release.yml`、`windows/installer/flashbyte.iss`、`install.sh`、`uninstall.sh`、`linux/com.iamsami.flashbyte.desktop`、`.gitignore` |
| 依赖 | `pubspec.yaml`、`pubspec.lock` |
| Android | `android/app/src/main/AndroidManifest.xml`、`android/app/src/main/kotlin/com/flashbyte/MainActivity.kt`、`lib/services/platform/android_connection_notification_service.dart`、`lib/services/platform/android_saf_service.dart` |
| iOS / macOS | `ios/Runner.xcodeproj/project.pbxproj`、`ios/Runner/AppDelegate.swift`、`ios/Runner/Info.plist`、`macos/Runner.xcodeproj/project.pbxproj`、`macos/Runner/AppDelegate.swift`、`macos/Runner/Info.plist`、`macos/Runner/MainFlutterWindow.swift` |
| Linux / Windows 窗口 | `linux/runner/my_application.cc`、`windows/runner/main.cpp`、`windows/runner/flutter_window.cpp` |
| 界面与本地化 | `lib/main.dart`、`lib/app/app_settings.dart`、`lib/features/settings/settings_page.dart`、`lib/features/transfers/pages/file_selection_page.dart`、`lib/features/transfers/pages/incoming_transfer_offer_page.dart`、`lib/features/transfers/pages/outgoing_transfer_offer_page.dart`、`lib/features/transfers/pages/tcp_chat_page.dart`、`lib/features/transfers/widgets/transfer_widget.dart`、`lib/features/transfers/widgets/file_preview_widget.dart` |
| 传输、发现与安全 | `lib/services/transfer/file_transfer_isolate.dart`、`lib/services/transfer/socket_service.dart`、`lib/services/discovery/device_discovery_service.dart`、`lib/services/security/tls_identity_service.dart`、`lib/services/security/trusted_devices_service.dart` |
| `flashbyte_core` | `lib/protocol/frame_protocol.dart`、`lib/utils/file_utils.dart`、`lib/utils/utils.dart`、`lib/adapters/output_target_adapter.dart`、`lib/identity/device_identity.dart`、`lib/identity/identity.dart` |
| 测试 | `packages/flashbyte_core/test/frame_protocol_test.dart`、`packages/flashbyte_core/test/file_utils_test.dart`、`packages/flashbyte_core/test/device_identity_test.dart`、`test/features/transfers/transfer_widget_test.dart` |

### 与上游同步流程

1. 拉取上游新版本，与本节「文件差异清单」逐项比对，确认上游改了哪些共享文件
2. 上游的功能与修复直接应用到 `lib/` 与 `packages/flashbyte_core/`，但要保留本分支的本地化改造：新增界面文案先加进 `AppLocalizations`，不要在界面里写死字符串
3. 下列内容不要被上游覆盖：
   - `lib/l10n/`、`lib/app/controllers/app_locale_controller.dart`、`lib/app/device_name.dart`
   - `lib/platform/window_state_manager.dart` 与三端原生窗口显示时机、单实例处理
   - `lib/widgets/background_permission_gate.dart` 与四个原生通道（documents / battery_optimization / foreground_service / storage）
   - `release.yml` 的双 README 下载表写入段与 Inno Setup 中文语言文件步骤
   - `windows/installer/flashbyte.iss`、`install.sh`、`uninstall.sh`、`.desktop`、各平台 `Base` / `zh-Hans` 字符串文件
   - 已裁剪的功能（系统分享接收、桌面拖放）：上游若再改这几处，直接跳过
4. 同步后更新 `pubspec.yaml` 版本号，并把本次改动写进 `CHANGELOG.md` 的 `## Unreleased` 段
5. 新增或删除文件时，同步更新本节「文件差异清单」

### 文档维护约定

- `README.md` 与 `README-en.md` 内的下载表由 `.github/workflows/release.yml` 按一对 `AUTO RELEASE DOWNLOADS` 起止注释（HTML 注释形式，位于「下载」小节）自动写入：**不要手改表格本身**，两个文件都必须保留这对注释，缺一个发布任务会失败
- 版本徽章、安装说明中的版本号与产物文件名跟随 `pubspec.yaml` 与发布工作流
- 更新日志分中英两份（`CHANGELOG.md` / `CHANGELOG-en.md`），发布工作流把两份的 `## Unreleased` 段都搬进同一日期版本段：中文条目作为 Release 说明正文，英文条目放进可折叠的 English 段；因此每条改动写成一行 `- ` 条目
