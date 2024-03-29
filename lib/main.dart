import 'package:fire_control_app/common/fc_color.dart';
import 'package:fire_control_app/common/global.dart';
import 'package:fire_control_app/common/router.dart';
import 'package:fire_control_app/states/unit_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

void main() {
  Global.init().then((value) => runApp(const FireControlApp()));
}

class FireControlApp extends StatelessWidget {
  const FireControlApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: UnitModel()),
      ],
      child: RefreshConfiguration(
        headerBuilder: () => const ClassicHeader(),
        footerBuilder: () => const ClassicFooter(),
        child: OverlaySupport.global(
          child: MaterialApp(
            title: '智慧消防',
            theme: ThemeData(
              // primarySwatch: Colors.grey,
              primarySwatch: createMaterialColor(FcColor.baseColor),
              platform: TargetPlatform.iOS, //滑动切换页面
            ),
            locale: const Locale('zh', 'CN'),
            localizationsDelegates: const [
              // 本地化的代理类
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
              RefreshLocalizations.delegate
            ],
            supportedLocales: const [
              Locale('en', 'US'), // 美国英语
              Locale('zh', 'CN'), // 中文简体
            ],
            initialRoute:
                Global.profile.isLogin ? RouterUtil.index : RouterUtil.login,
            // routes: RouterUtil.routes,
            navigatorKey: Global.navigatorKey,
            onGenerateRoute: RouterUtil.onGenerateRoute,
          )
        ),
      ),
    );
  }
}
