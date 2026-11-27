import 'dart:io';

import 'package:fast_file_picker/fast_file_picker.dart';
import 'package:flutter/services.dart';

/// Android 上直接用系统文档选择器拿 content:// URI。
///
/// 选文件不再经过会复制文件内容的插件：几 GB 的文件复制到缓存既会长时间
/// 没有反应，也会把缓存占满。返回的 [FastFilePickerPath] 中
/// [FastFilePickerPath.name] 是显示名，[FastFilePickerPath.path] 存的是
/// content:// URI，传输层识别该前缀后按 SAF 文档流式读取。
class AndroidDocumentService {
  AndroidDocumentService._();

  static final AndroidDocumentService instance = AndroidDocumentService._();

  static const MethodChannel _channel = MethodChannel('flashbyte/documents');

  /// 系统文件选择器多选结果；用户取消时返回空列表。
  Future<List<FastFilePickerPath>> pickDocuments() async {
    if (!Platform.isAndroid) {
      return const [];
    }
    final raw = await _channel.invokeMethod<List<dynamic>>('pickDocuments');
    return _toPaths(raw);
  }

  List<FastFilePickerPath> _toPaths(dynamic raw) {
    if (raw is! List) {
      return const [];
    }
    final paths = <FastFilePickerPath>[];
    for (final item in raw) {
      final path = _pathFromEntry(item);
      if (path != null) {
        paths.add(path);
      }
    }
    return paths;
  }

  FastFilePickerPath? _pathFromEntry(dynamic item) {
    if (item is! Map) {
      return null;
    }
    final uri = item['uri'];
    if (uri is! String || uri.isEmpty) {
      return null;
    }
    final rawName = item['name'];
    final name = rawName is String && rawName.isNotEmpty
        ? rawName
        : uri.split('/').last;
    return FastFilePickerPath.fromPath(name, uri);
  }
}
