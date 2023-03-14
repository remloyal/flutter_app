import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:fire_control_app/common/constants.dart';
import 'package:fire_control_app/common/global.dart';
import 'package:fire_control_app/models/api_info.dart';
import 'package:fire_control_app/http/login_api.dart';
import 'package:fire_control_app/utils/toast.dart';

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
      dio.options.baseUrl = Global.profile.apiInfo.baseUrl;
      // dio.options.contentType = "application/json";
    }

    dio.interceptors.add(InterceptorsWrapper(
        onRequest: _onRequest, onResponse: _onResponse, onError: _onError));

    // 在调试模式下需要抓包调试，所以我们使用代理，并禁用HTTPS证书校验
    if (!Global.isRelease) {
      // 抓包代理设置
      dio.httpClientAdapter = IOHttpClientAdapter()
        ..onHttpClientCreate = (HttpClient client) {
          // client.findProxy = (uri) {
          //   //proxy all request to localhost:8888
          //   return 'PROXY 192.168.1.200:8866';
          // };
          //代理工具会提供一个抓包的自签名证书，会通不过证书校验，所以我们禁用证书校验
          client.badCertificateCallback =
              (X509Certificate cert, String host, int port) => true;
          return client;
        };
    }
  }

  /// 请求拦截器
  static void _onRequest(
      RequestOptions options, RequestInterceptorHandler handler) {
    options.headers['User-Agent'] = Constants.userAgent;
    if (Global.profile.isLogin) {
      options.headers['token'] = Global.profile.apiInfo.token;
      options.headers['ticket'] = Global.profile.apiInfo.ticket;
    }

    handler.next(options);
  }

  /// 相应拦截器
  static void _onResponse(
      Response response, ResponseInterceptorHandler handler) async {
    // 请求成功是对数据做基本处理
    var data = response.data;
    if (response.data is String) {
      data = jsonDecode(response.data);
    }

    if (data?['code'] != 200 || response.statusCode != 200) {
      print(data?["message"]);
      data?["message"] != null ? Message.error(data?["message"]) : '';
    }
    if (data["code"] == 20013) {
      LoginService.clearInfo();
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
