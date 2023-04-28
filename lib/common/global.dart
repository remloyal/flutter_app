import 'dart:convert';

import 'package:fire_control_app/http/http.dart';
import 'package:fire_control_app/models/profile.dart';
import 'package:fire_control_app/models/unit.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// 全局变量及配置类，配置采用本地存储
class Global {

  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();


  static late SharedPreferences _prefs;

  static Profile profile = Profile();

  // 包信息
  static late PackageInfo packageInfo;

  // 单位列表
  static List<Unit> units = [];

  // 本地缓存key
  static const String _profileKey = "profile";

  // 是否为release版
  static bool get isRelease => const bool.fromEnvironment("dart.vm.product");

  //初始化全局信息，会在APP启动时执行
  static Future init() async {
    WidgetsFlutterBinding.ensureInitialized();
    packageInfo = await PackageInfo.fromPlatform();
    _prefs = await SharedPreferences.getInstance();

    String? cacheProfile = _prefs.getString(_profileKey);
    if (cacheProfile != null) {
      try {
        profile = Profile.fromJson(jsonDecode(cacheProfile));
      } catch (e) {
        print(e);
      }
    } else {}

    Http.init();
  }

  static setBaseUrl() {
    Http.dio.options.baseUrl = profile.apiInfo.baseUrl;
  }

  // 持久化Profile信息
  static saveProfile() =>
      _prefs.setString(_profileKey, jsonEncode(profile.toJson()));

  // 清除Profile的信息
  static clearProfile() => _prefs.remove(_profileKey);

  Future<void> setString(key, value) async {
    _prefs.setString(key, value);
  }

  Future<String?> getString(String key) async {
    var value = _prefs.getString(key);
    return value;
  }
}

class ProfileChangeNotifier extends ChangeNotifier {
  Profile get _profile => Global.profile;

  @override
  void notifyListeners() {
    Global.saveProfile(); //保存Profile变更
    super.notifyListeners(); //通知依赖的Widget更新
  }
}

///