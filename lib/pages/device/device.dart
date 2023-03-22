import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:fire_control_app/widgets/card_father.dart';
import 'package:fire_control_app/states/unit_model.dart';
import 'package:provider/provider.dart';
import 'package:fire_control_app/models/device_entity.dart';
import 'package:fire_control_app/http/device_api.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:fire_control_app/utils/value.dart';
import 'package:fire_control_app/widgets/keep_alive.dart';

class Device extends StatefulWidget {
  const Device({super.key});

  @override
  State<Device> createState() => _DeviceState();
}

class _DeviceState extends State<Device> {
  late List<DeviceItem> _deviceList = [];
  late DeviceList _device = DeviceList();
  final DeviceParams _deviceParam = DeviceParams();

  final ScrollController _listController = ScrollController();
  late bool isToTop = false;

  @override
  void initState() {
    _loadData();
    _listController.addListener(() {
      // 为控制器注册滚动监听方法
      if (_listController.offset > 1000) {
        // 如果 ListView 已经向下滚动了 1000，则开启 Top 按钮
        setState(() {
          isToTop = true;
        });
      } else if (_listController.offset < 300) {
        // 如果 ListView 向下滚动距离不足 300，则禁用
        setState(() {
          isToTop = false;
        });
      }
      // print(_listController.offset);
    });
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    _listController.dispose();
    super.dispose();
  }

  init() async {
    var data = await DeviceApi.useDeviceList(_deviceParam);
    _device = data;
    _deviceList = data.result;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Column(
          children: [
            header(),
            Expanded(
                child: Container(
              child: deviceList(),
            ))
          ],
        ),
        Positioned(
            bottom: 18.0,
            right: 0,
            child: AnimatedOpacity(
              // If the widget is visible, animate to 0.0 (invisible).
              // If the widget is hidden, animate to 1.0 (fully visible).
              opacity: isToTop ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 500),
              // The green box must be a child of the AnimatedOpacity widget.
              child: FloatingActionButton(
                  mini: true,
                  backgroundColor: const Color(0xff228CF5),
                  foregroundColor: const Color(0xffFFFFFF),
                  onPressed: () {
                    //返回到顶部时执行动画
                    _listController.animateTo(
                      .0,
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.ease,
                    );
                  },
                  child: const Icon(Icons.arrow_upward)),
            ))
      ],
    );
  }

  header() {
    return Container(
        height: 50,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                onTap: () {
                  print('说明');
                },
                child: Row(
                  children: const [
                    Icon(
                      IconData(0xe617, fontFamily: 'fcm'),
                      color: Color(0xffFCA400),
                      size: 18,
                    ),
                    Text(
                      '说明',
                      style: TextStyle(color: Color(0xffFCA400)),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Text('${_device.totalRow ?? 0}'),
                  InkWell(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          const Icon(
                            IconData(0xe628, fontFamily: 'fcm'),
                            color: Color.fromARGB(255, 0, 0, 0),
                            size: 18,
                          ),
                          Container(
                            margin: const EdgeInsets.only(left: 10),
                            child: const Text('筛选'),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ));
  }

  final RefreshController _controller =
      RefreshController(initialRefresh: false);
  void _onLoading() async {
    _loadData();
  }

  void _onRefresh() async {
    _deviceParam.currentPage = 1;
    _loadData(isRefresh: true);
  }

  void _loadData({bool isRefresh = false}) {
    DeviceApi.useDeviceList(_deviceParam).then((value) {
      _device = value;
      if (isRefresh) {
        _deviceList.clear();
        _controller.refreshCompleted(resetFooterState: true);
      }
      _deviceList.addAll(value.result);
      if (_deviceParam.currentPage >= value.totalPage) {
        _controller.loadNoData();
      } else {
        if (!isRefresh) {
          _controller.loadComplete();
        }
      }
      _deviceParam.currentPage++;
      setState(() {});
    });
  }

  deviceList() {
    return KeepAliveWrapper(
        child: Consumer<UnitModel>(builder: (context, UnitModel unitModel, _) {
      if (unitModel.unit != null) {
        if (_deviceParam.unitId != unitModel.unit?.unitId) {
          _deviceParam.unitId = unitModel.unit?.unitId;
          _deviceParam.currentPage = 1;
          _loadData(isRefresh: true);
          _listController.animateTo(
            .0,
            duration: const Duration(milliseconds: 10),
            curve: Curves.ease,
          );
        }
      }
      return SmartRefresher(
        controller: _controller,
        enablePullUp: true,
        onLoading: _onLoading,
        onRefresh: _onRefresh,
        child: ListView.builder(
          reverse: false,
          controller: _listController,
          itemBuilder: (c, i) => _buildItem(c, i),
          shrinkWrap: true,
          itemCount: _deviceList.length,
        ),
        // footer: const Text('data'),
      );
    }));
  }

  _buildItem(c, i) {
    var item = _deviceList[i];
    return InkWell(
      onTap: () {
        print('${item.mac}');
      },
      child: CardParent(
          header: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Padding(
                      padding: const EdgeInsets.only(right: 4),
                      child: Row(
                        children: [
                          if (item.alarm == 1)
                            const Padding(
                              padding: EdgeInsets.only(right: 4),
                              child: Icon(
                                IconData(0xe6d3, fontFamily: 'fcm'),
                                color: Color(0xffE53935),
                                size: 16,
                              ),
                            ),
                          if (item.fault == 1)
                            const Padding(
                              padding: EdgeInsets.only(right: 4),
                              child: Icon(
                                IconData(0xe612, fontFamily: 'fcm'),
                                color: Color(0xffFF9C09),
                                size: 16,
                              ),
                            ),
                          if (item.expire == 1)
                            const Padding(
                              padding: EdgeInsets.only(right: 4),
                              child: Icon(
                                IconData(0xe884, fontFamily: 'fcm'),
                                color: Color(0xffFF5722),
                                size: 16,
                              ),
                            ),
                          if (item.stop == 1)
                            const Padding(
                              padding: EdgeInsets.only(right: 4),
                              child: Icon(
                                IconData(0xe6bd, fontFamily: 'fcm'),
                                color: Color(0xffE53935),
                                size: 16,
                              ),
                            ),
                          if (item.alarm == 0 &&
                              item.fault == 0 &&
                              item.stop == 0 &&
                              item.alarm == 0 &&
                              item.expire == 0)
                            const Padding(
                              padding: EdgeInsets.only(right: 10),
                              child: Icon(
                                IconData(0xe8bd, fontFamily: 'fcm'),
                                color: Color(0xff4CAF50),
                                size: 16,
                              ),
                            ),
                        ],
                      )),
                  Text(
                    item.name,
                    style: const TextStyle(fontSize: 14),
                  )
                ],
              ),
              if (item.online == 1)
                const Text(
                  '未上线',
                  style: TextStyle(color: Color(0XFF999999), fontSize: 14),
                ),
              if (item.online == 2)
                const Text(
                  '在线',
                  style: TextStyle(color: Color(0XFF4CAF50), fontSize: 14),
                ),
              if (item.online == 3)
                const Text(
                  '离线',
                  style: TextStyle(color: Color(0XFFE53935), fontSize: 14),
                ),
            ],
          ),
          body: Column(
            children: [
              XfItem(
                label: '单位名称',
                content: item.unitName,
              ),
              XfItem(
                label: '设备位置',
                content: formatStrWithDefault(
                        item.buildingName, defaultValueOutdoor) +
                    ' ' +
                    formatStr(item.floorNumber) +
                    ' ' +
                    formatStr(item.roomNumber),
              ),
              XfItem(
                label: '设备类型',
                content: item.deviceTypeName,
              ),
              XfItem(
                label: '设备MAC',
                content: item.mac,
              )
            ],
          )),
    );
  }
}
