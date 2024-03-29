import 'package:fire_control_app/pages/alarm/alarm_handle.dart';
import 'package:fire_control_app/pages/home/find_device_page.dart';
import 'package:fire_control_app/pages/home/home_report.dart';
import 'package:fire_control_app/pages/home/message_page.dart';
import 'package:fire_control_app/pages/home/scan_page.dart';
import 'package:fire_control_app/pages/inspection/punch.dart';
import 'package:fire_control_app/pages/map/map.dart';
import 'package:flutter/material.dart';
import 'package:fire_control_app/pages/alarm/details/alarm_fault_detail_page.dart';
import 'package:fire_control_app/pages/alarm/details/danger_detail_page.dart';
import 'package:fire_control_app/pages/alarm/details/fire_detail_page.dart';
import 'package:fire_control_app/pages/alarm/details/trouble_detail_page.dart';
import 'package:fire_control_app/pages/home/unit_select.dart';
import 'package:fire_control_app/pages/index.dart';
import 'package:fire_control_app/pages/inspection/route_detail_page.dart';
import 'package:fire_control_app/pages/inspection/task_detail_page.dart';
import 'package:fire_control_app/pages/login/login.dart';

// 设备
import 'package:fire_control_app/pages/device/device_details_main.dart';

// 我的
import 'package:fire_control_app/pages/mine/mine_mail_list.dart';
import 'package:fire_control_app/pages/mine/mine_work/mine_work_main.dart';
import 'package:fire_control_app/pages/mine/mine_about.dart';
import 'package:fire_control_app/pages/mine/mine_privacy.dart';
import 'package:fire_control_app/pages/mine/mine_external/mine_news.dart';
import 'package:fire_control_app/pages/mine/mine_external/mine_help.dart';
import 'package:fire_control_app/pages/mine/mine_external/mine_external_details.dart';
import 'package:fire_control_app/pages/mine/mine_system_setting.dart';
import 'package:fire_control_app/pages/mine/mine_personal.dart';

/// 路由配置类
class RouterUtil {
  // 登录页面
  static const String login = "login";
  // 主页
  static const String index = "index";
  // 单位选择
  static const String unitSelect = "unitSelect";
  // 消息列表
  static const String messageList = "messageList";

  static Map<String, WidgetBuilder> routes = {
    login: (context) => const Login(),
    index: (context) => const IndexPage(),
    unitSelect: (context, {arguments}) => UnitSelect(
          type: arguments?['type'],
          param: arguments?['param'],
        ),
    FireDetailPage.routeName: (context, {arguments}) => FireDetailPage(fireId: arguments),
    AlarmFaultDetailPage.routeName: (context, {arguments}) => AlarmFaultDetailPage(param: arguments),
    TroubleDetailPage.routeName: (context, {arguments}) => TroubleDetailPage(troubleId: arguments),
    DangerDetailPage.routeName: (context, {arguments}) => DangerDetailPage(dangerId: arguments),
    TaskDetailPage.routeName: (context, {arguments}) => TaskDetailPage(taskId: arguments),
    RouteDetailPage.routeName: (context, {arguments}) => RouteDetailPage(routeId: arguments),
    PunchNfcPage.routeName: (context, {arguments}) => PunchNfcPage(param: arguments),
    ScanPage.routeName: (context, {arguments}) => const ScanPage(),
    LoginScanPage.routeName: (context, {arguments}) => LoginScanPage(url: arguments),
    PunchScanPage.routeName: (context, {arguments}) => PunchScanPage(param: arguments),
    PunchErrorPage.routeName: (context, {arguments}) => PunchErrorPage(param: arguments),
    FindDevicePage.routeName: (context, {arguments}) => const FindDevicePage(),
    FindResultPage.routeName: (context, {arguments}) => FindResultPage(param: arguments),
    MessageCenterPage.routeName: (context, {arguments}) => const MessageCenterPage(),
    NoticeDetailPage.routeName: (context, {arguments}) => NoticeDetailPage(
          noticeId: arguments,
        ),
    ActivityDetailPage.routeName: (context, {arguments}) => ActivityDetailPage(activityId: arguments),
    HandlePage.routeName: (context, {arguments}) => HandlePage(param: arguments),
    HomeReport.routeName: (context, {arguments}) => const HomeReport(),
    '/deviceDetails': (context, {arguments}) => DeviceDetailsMain(deviceId: arguments),
    '/mineMail': (context) => const MineMail(),
    '/mainWorkMain': (context, {arguments}) => MainWorkMain(
          id: arguments?['id'],
          name: arguments?['name'],
        ),
    '/mineAbout': (context) => const MineAbout(),
    '/minePrivacy': (context) => const MinePrivacy(),
    '/minePersonal': (context) => const MinePersonal(),
    '/mineSystemSetting': (context) => const MineSystemSetting(),
    '/mineNews': (context) => const MineNews(),
    '/mineHelp': (context) => const MineHelp(),
    '/mineexternalDetails': (context, {arguments}) => MineExternalDetails(
          url: arguments?['url'],
          type: arguments?['type'],
        ),
    MapCase.routeName: (context, {arguments}) => MapCase(
          info: arguments?['info'],
        ),
  };

  //定义通用的onGenerateRoute
  static RouteFactory onGenerateRoute = (RouteSettings settings) {
    //settings 中两个属性 name 表示路由名称 arguments 传递的参数若是无参则这个为null
    //1.获取当前调用的路由名称
    //2.找到我们上面定义的Map路由表中是否包含此路由，并取出方法
    //3.取出对应的参数
    //4.判断不为null表示找到了某个路由定义的方法
    //5.判断setting中的 arguments 不为null
    //6.返回要跳转的页面和传递参数
    //7.使用我们获取到的Function 调用带参数的去传递参数
    //8.否则使用我们获取到的Function 调用不带参数的
    String? routeName = settings.name;
    Function? pageContentBuilder = routes[routeName];
    Object? args = settings.arguments;
    if (pageContentBuilder != null) {
      if (args != null) {
        final Route route = MaterialPageRoute(builder: (context) {
          return pageContentBuilder(context, arguments: args);
        });
        return route;
      } else {
        return MaterialPageRoute(builder: (context) => pageContentBuilder(context));
      }
    }
  };
}
