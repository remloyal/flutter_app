import 'dart:math';
import 'package:fire_control_app/widgets/button_group.dart';
import 'package:fire_control_app/widgets/cell.dart';
import 'package:fire_control_app/widgets/filter_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fire_control_app/widgets/card_father.dart';
import 'package:fire_control_app/models/device_entity.dart';
import 'package:fire_control_app/http/device_api.dart';
import 'package:fire_control_app/utils/value.dart';
import 'package:fire_control_app/widgets/load_list.dart';
import 'package:fire_control_app/widgets/cascader.dart';
import 'package:fire_control_app/http/unit_api.dart';
import 'package:fire_control_app/common/global.dart';

class Device extends StatefulWidget {
  const Device({super.key});

  @override
  State<Device> createState() => _DeviceState();
}

class _DeviceState extends State<Device> {
  final DeviceParams _deviceParam = DeviceParams();

  @override
  Widget build(BuildContext context) {
    return LoadList(
        api: DeviceApi.useDeviceList,
        param: _deviceParam,
        precedent: DeviceList(),
        setTtem: _buildItem,
        header: _header);
  }

  _header(device) {
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
                  Text(
                    '共 ${device.totalRow ?? 0} 条',
                    style:
                        const TextStyle(fontSize: 14, color: Color(0xff6A6A6A)),
                  ),
                  Builder(builder: (ctx) {
                    return InkWell(
                      onTap: () {
                        print('object');
                        // Scaffold.of(ctx).openEndDrawer();
                        showDialog(
                            context: context,
                            builder: (ctx) => FilterDialog(
                                  body: _filter(ctx),
                                ));
                      },
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
                    );
                  })
                ],
              ),
            )
          ],
        ));
  }

  _buildItem(DeviceItem item) {
    return InkWell(
      highlightColor: Colors.amberAccent,
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

  //初始化控制器
  final TextEditingController _search = TextEditingController();
  _filter(context) {
    _search.text = 'hhhhhhhhhhhhhh';
    List unit = Global.units;
    List data = [];
    for (var i = 0; i < unit.length; i++) {
      Map todo = {
        'name': unit[i].name,
        'unitId': unit[i].unitId,
        "type": 'unit'
      };
      data.add(todo);
    }
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CardTitle(text: '设备类型'),
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Cell(
              text: '选择类型',
              onTap: () {
                print('object');
              },
            ),
          ),
          const CardTitle(text: '设备状态'),
          ButtonBarState(
            names: const [
              {'text': '全部', 'value': '0'},
              {'text': '正常', 'value': '1'},
              {'text': '报警', 'value': '2'},
              {'text': '故障', 'value': '3'}
            ],
            onTap: (index) {
              // _alarmStatsParam.type = date[index];
              print(index);
              // _onRefresh();
              // alarmInit();
            },
          ),
          const CardTitle(text: '在线状态'),
          ButtonBarState(
            names: const [
              {'text': '全部', 'value': '0'},
              {'text': '在线', 'value': '1'},
              {'text': '离线', 'value': '2'},
              {'text': '未上线', 'value': '3'}
            ],
            onTap: (index) {
              // _alarmStatsParam.type = date[index];
              print(index);
              // _onRefresh();
              // alarmInit();
            },
          ),
          const CardTitle(text: '封停状态'),
          ButtonBarState(
            names: const [
              {'text': '全部', 'value': '0'},
              {'text': '正常', 'value': '1'},
              {'text': '封停', 'value': '2'}
            ],
            // height: 30,
            onTap: (index) {
              // _alarmStatsParam.type = date[index];
              print(index);
              // _onRefresh();
              // alarmInit();
            },
          ),
          const CardTitle(text: '设备位置'),
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Cell(
              text: '请选择设备位置',
              onTap: () {
                showCupertinoModalPopup(
                    context: context,
                    builder: (BuildContext context) {
                      return Container(
                        height: 400,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10)),
                            color: Colors.grey[200]),
                        child: Cascader(
                          title: '请选择位置',
                          customField: 'name',
                          asyncCallBack: (item, tabIndex, itemIndex) async {
                            if (item['type'] == 'unit') {
                              var data = await _getBuilding(item['unitId']);
                              return data;
                            }

                            if (item['type'] == 'build') {
                              var data = await _getBuildingFloors(item['id']);
                              return data;
                            }
                            if (item['type'] == 'floor') {
                              var data = await _getuildingRooms(
                                  item['buildingId'], item['id']);
                              return data;
                            }
                            return [];
                          },
                          onClose: (todo) {
                            print('object  $todo');
                            Navigator.pop(context);
                          },
                          options: data,
                        ),
                      );
                    });
              },
            ),
          ),
          const CardTitle(text: '搜索'),
          TextField(
            controller: _search,
            style: const TextStyle(fontSize: 12),
            scrollPadding: const EdgeInsets.symmetric(vertical: 4.0),
            decoration: const InputDecoration(
              filled: true,
              isCollapsed: true,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 5,
              ),
              border: OutlineInputBorder(),
              hintText: '请输入设备MAC或设备名称',
            ),
            onChanged: (value) {
              print(value);
            },
          )
        ],
      ),
    );
  }

  _getBuilding(unitId) async {
    var data = await UnitApi.getBuilding(unitId);
    List todo = [];
    for (var i = 0; i < data.length; i++) {
      Map item = {'name': data[i].name, 'id': data[i].id, "type": 'build'};
      todo.add(item);
    }
    return todo;
  }

  _getBuildingFloors(buildingId) async {
    var data = await UnitApi.getBuildingFloors(buildingId);
    List todo = [];
    for (var i = 0; i < data.length; i++) {
      Map item = {
        'name': data[i].name,
        'id': data[i].id,
        "type": 'floor',
        'buildingId': buildingId
      };
      todo.add(item);
    }
    return todo;
  }

  _getuildingRooms(buildingId, floorId) async {
    var data = await UnitApi.getBuildingRooms(buildingId, floorId);
    List todo = [];
    for (var i = 0; i < data.length; i++) {
      Map item = {'name': data[i].name, 'id': data[i].id, "type": 'room'};
      todo.add(item);
    }
    return todo;
  }

  String getRandomString(int length) {
    const characters =
        '+-*=?AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz';
    Random random = Random();
    return String.fromCharCodes(Iterable.generate(length,
        (_) => characters.codeUnitAt(random.nextInt(characters.length))));
  }
}
