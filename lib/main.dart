import 'package:fire_control_app/common/global.dart';
import 'package:fire_control_app/common/router.dart';
import 'package:fire_control_app/states/unit_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
      providers: [ChangeNotifierProvider.value(value: UnitModel())],
      child: RefreshConfiguration(
        headerBuilder: () => const ClassicHeader(),
        footerBuilder: () => const ClassicFooter(),
        child: MaterialApp(
          title: '智慧消防',
          theme: ThemeData(
            primarySwatch: Colors.grey,
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
          // home: const IndexPage(),
          routes: FireControlRouter.getRoutes(),
          initialRoute: '/login',
          builder: FToastBuilder(),
        ),
      ),
    );
  }
}
