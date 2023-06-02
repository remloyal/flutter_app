import 'dart:io';
import 'package:path_provider/path_provider.dart';

class AppDir {
  static Directory data = Directory('');
  static Directory cache = Directory('');

  static setDir() async {
    data = await getApplicationDocumentsDirectory();
    cache = await getTemporaryDirectory();
    print('object --------- $data  ------- $cache');
  }
}

class CacheUtil {
  /// 获取缓存大小
  static Future<int> total() async {
    Directory tempDir = await getTemporaryDirectory();
    if (tempDir == null) return 0;
    int total = await _reduce(tempDir);
    return total;
  }

  /// 清除缓存
  static Future<void> clear() async {
    Directory tempDir = await getTemporaryDirectory();
    if (tempDir == null) return;
    await _delete(tempDir);
  }

  /// 递归缓存目录，计算缓存大小
  static Future<int> _reduce(final FileSystemEntity file) async {
    /// 如果是一个文件，则直接返回文件大小
    if (file is File) {
      int length = await file.length();
      return length;
    }

    /// 如果是目录，则遍历目录并累计大小
    if (file is Directory) {
      final List<FileSystemEntity> children = file.listSync();

      int total = 0;

      if (children != null && children.isNotEmpty)
        for (final FileSystemEntity child in children) total += await _reduce(child);

      return total;
    }

    return 0;
  }

  /// 递归删除缓存目录和文件
  static Future<void> _delete(FileSystemEntity file) async {
    // if (file is Directory) {
    //   final List<FileSystemEntity> children = file.listSync();
    //   for (final FileSystemEntity child in children) {
    //     await _delete(child);
    //   }
    // } else {
    //   await file.delete();
    // }

    try {
      if (file is Directory) {
        final List<FileSystemEntity> children = file.listSync();
        for (final FileSystemEntity child in children) {
          await _delete(child);
        }
      }
      await file.delete();
    } catch (e) {
      print(e);
    }
  }

  static String renderSize(value) {
    if (value == null) {
      return '0.0';
    }
    List<String> unitArr = []
      ..add('B')
      ..add('K')
      ..add('M')
      ..add('G');
    int index = 0;
    while (value > 1024) {
      index++;
      value = value / 1024;
    }
    String size = value.toStringAsFixed(2);
    return size + unitArr[index];
  }
}
