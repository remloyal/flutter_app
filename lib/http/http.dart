import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:fire_control_app/common/global.dart';

/// 网络请求配置及封装
class Http {

  static Dio dio = Dio();
  
  static void init() {
    if (Global.profile.apiInfo.baseUrl.isNotEmpty) {
      dio.options.baseUrl = Global.profile.apiInfo.baseUrl;
      dio.interceptors.add(InterceptorsWrapper(
        onRequest: (RequestOptions options, RequestInterceptorHandler handler) {
          options.headers['token'] = Global.profile.apiInfo.token;
          options.headers['user-agent'] = "Mozilla/5.0 (iPhone; CPU iPhone OS 13_2_3 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/13.0.3 Mobile/15E148 Safari/604.1";
          options.headers['ticket'] = Global.profile.apiInfo.ticket;
          return handler.next(options);
        }
      ));
      // 在调试模式下需要抓包调试，所以我们使用代理，并禁用HTTPS证书校验
      if (!Global.isRelease) {
        (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
            (client) {
          // client.findProxy = (uri) {
          //   return 'PROXY 192.168.1.200:8866';
          // };
          //代理工具会提供一个抓包的自签名证书，会通不过证书校验，所以我们禁用证书校验
          client.badCertificateCallback =
              (X509Certificate cert, String host, int port) => true;
        };
      }
    }
  }
}