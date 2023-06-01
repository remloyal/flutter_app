import 'dart:async';
import 'dart:developer' as dev;
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/widgets.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map/src/layer/tile_layer/tile_provider/network_no_retry_image_provider.dart'; // this line will be warned as "Don't import Implementation files from other package", just ignore it.
import './app_dir.dart';
import 'package:path/path.dart' as path;

class CacheTileProvider extends NetworkNoRetryTileProvider {
  String tileName;
  String? fallbackUrl;

  CacheTileProvider(
    this.tileName, {
    this.fallbackUrl = '',
    // 这是新添加的参数，用于区分不同的瓦片图源；下面两个参数继承自NetworkNoRetryTileProvider
    super.headers,
    super.httpClient,
  });

  @override
  ImageProvider getImage(TileCoordinates coords, TileLayer options) {
    File file = File(path.join(
        AppDir.cache.path, // 应用缓存路径
        'flutter_map_tiles', // 表明这是 flutter_map 使用的目录
        tileName, // 以tileName区分不同的瓦片图源
        coords.z.round().toString(),
        coords.x.round().toString(),
        '${coords.y.round().toString()}.png'));

    if (file.existsSync()) {
      return FileImage(file);
    } else {
      return NetworkImageSaverProvider(
        getTileUrl(coords, options),
        file,
        headers: headers,
        httpClient: httpClient,
        fallbackUrl: fallbackUrl,
      );
    }
  }
}

class NetworkImageSaverProvider extends FMNetworkNoRetryImageProvider {
  File file;

  NetworkImageSaverProvider(
    super.url,
    this.file, {
    // 新添加的参数，图片保存的目标文件。
    HttpClient? httpClient,
    super.headers = const {},
    required super.fallbackUrl,
  });

  @override
  ImageStream createStream(ImageConfiguration configuration) {
    // 重写createStream，为stream添加listener
    ImageStream stream = ImageStream();
    ImageStreamListener listener = ImageStreamListener(imageListener);
    stream.addListener(listener);
    return stream;
  }

  void imageListener(ImageInfo imageInfo, bool synchronousCall) {
    ui.Image uiImage = imageInfo.image;
    _saveImage(uiImage);
  }

  Future<void> _saveImage(ui.Image uiImage) async {
    // 异步保存图片
    try {
      Directory parent = file.parent;
      if (!await parent.exists()) {
        await parent.create(recursive: true); // 如果目录不存在，逐级创建。
      }
      ByteData? bytes = await uiImage.toByteData(format: ui.ImageByteFormat.png);
      if (bytes != null) {
        final buffer = bytes.buffer;
        file.writeAsBytes(buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes)); // 将二进制数据写入图片文件。
      }
    } catch (e) {
      dev.log(e.toString());
    }
  }
}
