import 'package:fire_control_app/common/colors.dart';
import 'package:fire_control_app/common/global.dart';
import 'package:fire_control_app/http/unit_api.dart';
import 'package:fire_control_app/common/router.dart';
import 'package:fire_control_app/states/unit_model.dart';
import 'package:flutter/material.dart';
import 'package:fire_control_app/common/fcm_icon.dart';
import 'package:fire_control_app/pages/home/home.dart';
import 'package:fire_control_app/pages/inspection/inspection.dart';
import 'package:fire_control_app/pages/alarm/alarm.dart';
import 'package:fire_control_app/pages/device/device.dart';
import 'package:fire_control_app/pages/mine/mine.dart';
import 'package:provider/provider.dart';

class IndexPage extends StatefulWidget {
  const IndexPage({
    Key? key,
  }) : super(key: key);

  @override
  State<IndexPage> createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  int _selectedIndex = 0;

  final PageController _pageController = PageController();

  @override
  void initState() {
    UnitApi.getUnitList().then((value) {
      Global.units = value;
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("index create");
    var bottomNavigationBarItems = <BottomNavigationBarItem>[
      const BottomNavigationBarItem(
        icon: Icon(FcmIcon.home),
        label: "综合",
      ),
      const BottomNavigationBarItem(
        icon: Icon(FcmIcon.inspection),
        label: "巡检",
      ),
      const BottomNavigationBarItem(
        icon: Icon(FcmIcon.alarm),
        label: "告警",
      ),
      const BottomNavigationBarItem(
        icon: Icon(FcmIcon.device),
        label: "设备",
      ),
      const BottomNavigationBarItem(
        icon: Icon(FcmIcon.mine),
        label: "我的",
      )
    ];

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        backgroundColor: _selectedIndex == 4 ? Colors.blue : null,
        title: _buildTitle(_selectedIndex != 4),
      ),
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: _pageController,
        children: const [Home(), Inspection(), Alarm(), Device(), Mine()],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: bottomNavigationBarItems,
        currentIndex: _selectedIndex,
        type: BottomNavigationBarType.fixed,
        fixedColor: Colors.pink,
        onTap: (index) {
          setState(() {
            _pageController.jumpToPage(index);
            _selectedIndex = index;
          });
        },
        // selectedItemColor: Theme.of(context).primaryColor,
        // backgroundColor: Colors.white,
      ),
    );
  }

  Widget _buildTitle(bool isBuildUnit) {
    return Row(
      children: [
        _buildCircleButton(() {
          print("打开消息");
        }, FcmIcon.message),
        Expanded(
          flex: 1,
          child: isBuildUnit ? _buildUnit() : Container(),
        ),
        _buildCircleButton(() {
          print("打开扫一扫");
        }, FcmIcon.scan)
      ],
    );
  }

  Widget _buildCircleButton(GestureTapCallback? onPressed, IconData iconData) {
    return Container(
      height: 40,
      width: 40,
      margin: EdgeInsets.all(5),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(20)),
      child: GestureDetector(
          onTap: onPressed,
          child: Icon(iconData, color: FireControlColor.base3)),
    );
  }

  Widget _buildUnit() {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, FireControlRouter.unitSelect);
      },
      child: Container(
        height: 40,
        padding: EdgeInsets.only(left: 10, top: 0, right: 10, bottom: 0),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(20)),
        child: Row(
          children: [
            Icon(FcmIcon.unit, color: FireControlColor.base3),
            Expanded(
                flex: 1,
                child: Container(
                  padding:
                      EdgeInsets.only(left: 5, top: 0, right: 5, bottom: 0),
                  child: Consumer<UnitModel>(
                      builder: (BuildContext context, unitModel, _) => Text(
                            unitModel.unit != null
                                ? unitModel.unit!.name
                                : "全部单位(${Global.units.length})",
                            style: TextStyle(color: FireControlColor.base3),
                          )),
                )),
            Icon(FcmIcon.right_arrow, color: FireControlColor.base3)
          ],
        ),
      ),
    );
  }
}
