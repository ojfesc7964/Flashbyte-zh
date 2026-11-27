# 更新日志

本文件记录本分支（Flashbyte 中文本地化分支）的改动。版本号与上游保持一致，条目只写本分支有差异的部分；上游 `3.1.4` 的完整条目见 [上游 CHANGELOG](https://github.com/iamsami101/Flashbyte/blob/main/CHANGELOG.md)。

发布流程会读取 `## Unreleased` 段：把这些条目搬进带日期的版本段，并作为 GitHub Release 说明发布，所以每条改动写成一行 `- ` 条目。

英文镜像：[CHANGELOG-en.md](CHANGELOG-en.md)。两份文件需在同一处改动中一起更新；发布时把两份的 `## Unreleased` 段都搬进同一日期版本段，中文条目作为 Release 说明正文，英文条目放进可折叠的 English 段。

## Unreleased

- 移除：不再接收其它应用通过系统分享交给 Flashbyte 的文件。Android 分享意图与 iOS 分享扩展一并删除，应用不再出现在系统分享面板；发送只能从应用内选择文件、文件夹或粘贴板（依赖 `receive_sharing_intent` 随之移除）
- 文档：`FORK.md` / `FORK-en.md` 合并进 `README.md` / `README-en.md`，两份 README 重写并新增与上游的逐项对比
- 文档：重写本文件，改为按本分支视角记录差异条目
- 文档：新增 `CHANGELOG-en.md` 作为本文件的英文镜像
- 文档：两份 README 顶部新增语言切换入口，可在中文与英文之间跳转

## 3.1.4 - 2026-11-18

首个中文版，基于上游 `3.1.4`。该版本仍包含系统分享接收，已在 `Unreleased` 段移除；桌面端拖放与上游一致，保留。

### 本地化

- 新增 `lib/l10n/app_localizations.dart`：全部界面文案的中英文取词
- 新增 `lib/app/controllers/app_locale_controller.dart`：语言控制器，支持跟随系统 / 简体中文 / English
- 设置页新增「语言」选项，切换即时生效并持久化
- 通知渠道名称与说明随语言设置刷新
- 新增 iOS / macOS 权限弹窗说明的 `Base` 与 `zh-Hans` 版本，以及 macOS 中文菜单
- 新增 Android `res/values-zh/strings.xml`：前台服务通知文案
- 新增 `fastlane/metadata/android/zh-CN/` 商店文案；`windows/installer/flashbyte.iss` 增加简体中文安装界面；`install.sh` / `uninstall.sh` 按 `LANG` 输出中文；`.desktop` 增加中文 `Comment`

### 桌面窗口

- 新增 `lib/platform/window_state_manager.dart`：记录并恢复窗口位置、尺寸、最大化状态
- Linux / Windows / macOS 原生层不再在首帧显示窗口，由 Dart 恢复几何后再显示；macOS / Windows 显示时约 160 ms 淡入
- 恢复的位置不在任何显示器可见区域内时回退居中；拿不到几何信息时沿用上次位置
- macOS 点击 Dock 图标恢复最小化 / 后台窗口
- Windows 增加单实例互斥体，第二次启动只把已有窗口置前
- Linux 改用 `G_APPLICATION_HANDLES_COMMAND_LINE`，第二个进程把激活请求转给已运行实例

### 发送与接收

- 新增粘贴板发送：文本写成临时文件传输，接收端按 `clipboard` 标记写回粘贴板，不落盘
- 批量请求：多文件一次发起、一次批准，支持全部接受 / 拒绝、全部暂停 / 继续 / 取消
- 断点续传：接收端保留临时文件，中断后按已接收偏移继续，完成后转成目标文件
- 会话页逐文件状态卡片（排队、等待批准、传输中、已暂停、完成、取消）
- 会话内提供粘贴板 / 文件 / 文件夹发送入口
- 通知栏可操作：批量进度、在通知里接受或拒绝请求；后台处理过的请求回到前台不重复弹批准页
- 发送端改名后立即通过 `update_peer_info` 同步给已连接对端

### 传输健壮性

- `flashbyte_core` 帧协议增加大小上限（元数据 4 MiB、负载 32 MiB）与读缓冲区上限，超限断开
- 帧写入串行化，心跳与数据块不再竞争 socket 写
- 新增文件名清洗：防目录穿越、替换 Windows 非法字符、前缀保留设备名、按 UTF-8 字节截断
- 发现服务按来源地址限速、设备列表上限 64、广播间隔 2 s → 5 s、hello 字段严格校验、`stop` 系列串行化
- TLS 密钥生成移入独立 isolate，首启不阻塞首帧；并发调用共享同一次生成
- 优雅断开增加 4 s 超时兜底；续传重连不再发送 `transfer_cancelled`，避免对端删除临时文件

### 设备名

- 设备名默认取设备型号（内部型号码回退到品牌 / 主机名），不再生成随机两词名
- 新增 `packages/flashbyte_core/lib/utils/device_name.dart` 与 `lib/app/device_name.dart`：名称清洗、长度限制与校验
- 发现列表中的对端名称同样经过清洗

### 平台集成

- Android：移除 `disable_battery_optimization` / `process_run` / `windowed_file_reader` 等插件，改由原生通道提供文档选择（`flashbyte/documents`）、电池优化状态（`flashbyte/battery_optimization`）、前台服务（`flashbyte/foreground_service`）与空间预检（`flashbyte/storage`）
- Android：新增 `TransferForegroundService`，传输期间保持进程；清单去除存储与安装包权限，关闭备份
- Android：启动时用不可穿透的遮罩检查通知权限与电池优化豁免（上游为可关闭的一次性提示）
- iOS：注册电池优化等价通道（后台 App 刷新），移除不再需要的定位权限说明
- macOS：声明 `CFBundleLocalizations`，窗口初始透明并在恢复位置后淡入

### 依赖

- 新增 `flutter_localizations`（SDK）与 `screen_retriever`
- 移除 `receive_sharing_intent`、`disable_battery_optimization`、`process_run`、`windowed_file_reader`

### 测试与 CI

- `packages/flashbyte_core/test/`：新增设备名规则、帧上限、写入串行化、文件名清洗测试
- 新增 `test/app/device_name_test.dart`
- CI 改为手动触发，精简为 analyze + 应用测试 + core 包测试
- 发布工作流增加 `verify` 前置任务，Windows 构建下载 Inno Setup 中文语言文件，下载表同时写入 `README.md` 与 `README-en.md`
