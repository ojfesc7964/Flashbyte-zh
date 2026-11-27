import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

/// 读取系统粘贴板中的文本并写入临时文件；粘贴板没有文本时返回 null。
///
/// 发送端把它当作普通文件传输，接收端识别 `clipboard` 标记后只在内存里拼接
/// 内容，完成时写回粘贴板，不生成磁盘文件。
Future<File?> createClipboardTextFile() async {
  String? text;
  try {
    final data = await Clipboard.getData(Clipboard.kTextPlain);
    text = data?.text;
  } catch (_) {
    // 无法读取粘贴板时按“没有内容”处理，由界面提示。
    return null;
  }

  if (text == null || text.isEmpty) {
    return null;
  }

  try {
    final directory = await getTemporaryDirectory();
    final file = File(
      '${directory.path}${Platform.pathSeparator}'
      'flashbyte_clipboard_${DateTime.now().microsecondsSinceEpoch}.txt',
    );
    await file.writeAsString(text);
    return file;
  } catch (_) {
    return null;
  }
}

/// 清理本次启动之前留下的粘贴板文本临时文件。
///
/// 只删除 [before] 之前修改的文件，本次启动中新建的文件（包括刚写入的
/// 粘贴板文本）不会被动到。
Future<void> cleanupClipboardTextFiles({required DateTime before}) async {
  try {
    final directory = await getTemporaryDirectory();
    await for (final entity in directory.list(followLinks: false)) {
      if (entity is! File) {
        continue;
      }
      final name = entity.uri.pathSegments.last;
      if (!name.startsWith('flashbyte_clipboard_')) {
        continue;
      }
      try {
        final stat = await entity.stat();
        if (stat.modified.isBefore(before)) {
          await entity.delete();
        }
      } catch (_) {
        // 文件正被使用或已被删除时跳过。
      }
    }
  } catch (_) {
    // 拿不到临时目录时忽略，下一次启动再清理。
  }
}
