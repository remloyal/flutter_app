import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:fire_control_app/common/constants.dart';
import 'package:fire_control_app/common/global.dart';
import 'package:fire_control_app/models/api_info.dart';

enum DioMethod {
  get,
  post,
  put,
  delete,
  patch,
  head,
}

/// 网络请求配置及封装
class Http {
  static Dio dio = Dio();
  static ApiInfo apiInfo = Global.profile.apiInfo;

  static init() {
    if (Global.profile.apiInfo.baseUrl.isNotEmpty) {
      print(
          'Global.profile.apiInfo.baseUrl.isNotEmpty  ${Global.profile.apiInfo.baseUrl.isNotEmpty}');
      dio.options.baseUrl = Global.profile.apiInfo.baseUrl;
      dio.interceptors.add(InterceptorsWrapper(
          onRequest: _onRequest, onResponse: _onResponse, onError: _onError));
      // 在调试模式下需要抓包调试，所以我们使用代理，并禁用HTTPS证书校验
      if (!Global.isRelease) {
        // ignore: deprecated_member_use
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
      print('dio.options.baseUrl  ${dio.options.baseUrl}');
    }
  }

  /// 请求拦截器
  static void _onRequest(
      RequestOptions options, RequestInterceptorHandler handler) {
    options.headers['token'] = Global.profile.apiInfo.token;
    options.headers['user-agent'] = Constants.userAgent;
    options.headers['ticket'] = Global.profile.apiInfo.ticket;
    print('请求参数options $options');
    handler.next(options);
    // super.onRequest(options, handler);
  }

  /// 相应拦截器
  static void _onResponse(
      Response response, ResponseInterceptorHandler handler) async {
    // 请求成功是对数据做基本处理
    var data = response.data;
    if (response.data is String) {
      data = jsonDecode(response.data);
    }

    if (data["code"] == 20013) {
      print(data["message"]);
      return;
    }
    handler.next(response);
  }

  /// 错误处理
  static void _onError(DioError error, ErrorInterceptorHandler handler) {
    handler.next(error);
  }

  /// 请求类
  static Future<T> request<T>(
    String path, {
    DioMethod method = DioMethod.get,
    Map<String, dynamic>? params,
    data,
    CancelToken? cancelToken,
    Options? options,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    const methodValues = {
      DioMethod.get: 'get',
      DioMethod.post: 'post',
      DioMethod.put: 'put',
      DioMethod.delete: 'delete',
      DioMethod.patch: 'patch',
      DioMethod.head: 'head'
    };
    options ??= Options(method: methodValues[method]);
    try {
      Response response;
      response = await dio.request(path,
          data: data,
          queryParameters: params,
          cancelToken: cancelToken,
          options: options,
          onSendProgress: onSendProgress,
          onReceiveProgress: onReceiveProgress);
      return response.data;
    } on DioError catch (e) {
      print('DioError:  $e ');
      rethrow;
    }
  }
}
