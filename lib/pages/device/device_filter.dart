import 'package:fire_control_app/widgets/button_group.dart';
import 'package:fire_control_app/widgets/cell.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fire_control_app/widgets/card_father.dart';
import 'package:fire_control_app/models/device_entity.dart';
import 'package:fire_control_app/http/device_api.dart';
import 'package:fire_control_app/widgets/cascader.dart';
import 'package:fire_control_app/http/unit_api.dart';
import 'package:fire_control_app/common/global.dart';

class DeviceFilter extends StatefulWidget {
  const DeviceFilter({super.key, required this.param, required this.onChange});

  final DeviceParams param;
  final Function(DeviceParams) onChange;
  @override
  State<DeviceFilter> createState() => _DeviceFilterState();
}

class _DeviceFilterState extends State<DeviceFilter> {
  GlobalKey stateKey = GlobalKey();
  late DeviceParams _deviceParam = DeviceParams();
  List data = [];
  List _position = [];

  //初始化控制器
  final TextEditingController _search = TextEditingController();
  late StateSetter _reloadTextSetter;

  int? selectedValue;
  List deviceTypes = [];

  @override
  void initState() {
    super.initState();
    List unit = Global.units;
    for (var i = 0; i < unit.length; i++) {
      Map todo = {
        'name': unit[i].name,
        'unitId': unit[i].unitId,
        "type": 'unit'
      };
      data.add(todo);
    }
    _deviceParam = widget.param;
    if (_deviceParam.deviceTypeId != null) {
      _initDeviceType();
    }
  }

  _initDeviceType() async {
    deviceTypes = await _getDeviceTypes();
    int index = deviceTypes
        .indexWhere((element) => element['type'] == _deviceParam.deviceTypeId);
    selectedValue = index;
    _reloadTextSetter(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topLeft,
      fit: StackFit.expand,
      children: [
        Positioned(
          child: StatefulBuilder(
            builder: (ctx, stateSetter) {
              _reloadTextSetter = stateSetter;
              return _filter(ctx);
            },
          ),
        ),
        Positioned(
            bottom: 30,
            left: 20,
            child: SizedBox(
              width: 230,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    TextButton(
                        style: ButtonStyle(
                          foregroundColor: MaterialStateProperty.all(
                              const Color.fromARGB(255, 0, 0, 0)),
                          backgroundColor: MaterialStateProperty.all(
                              const Color.fromARGB(255, 250, 250, 250)),
                          side: MaterialStateProperty.all(
                              const BorderSide(color: Colors.red, width: 1)),
                          textStyle: MaterialStateProperty.all(
                              const TextStyle(fontSize: 14, color: Colors.red)),
                          minimumSize:
                              MaterialStateProperty.all(const Size(100, 15)),
                          shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50))),
                        ),
                        onPressed: () {
                          _deviceParam.initial();
                          stateKey = GlobalKey();
                          _position.clear();
                          selectedValue = null;
                          _reloadTextSetter(() {});
                        },
                        child: const Text(
                          '重置条件',
                          style: TextStyle(color: Colors.red),
                        )),
                    TextButton(
                        style: ButtonStyle(
                          foregroundColor: MaterialStateProperty.all(
                              const Color.fromARGB(255, 0, 0, 0)),
                          backgroundColor:
                              MaterialStateProperty.all(Colors.red),
                          side: MaterialStateProperty.all(
                              const BorderSide(color: Colors.red, width: 1)),
                          textStyle: MaterialStateProperty.all(
                              const TextStyle(fontSize: 14, color: Colors.red)),
                          minimumSize:
                              MaterialStateProperty.all(const Size(100, 15)),
                          shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50))),
                        ),
                        onPressed: () {
                          widget.onChange(_deviceParam);
                        },
                        child: const Text(
                          '确定',
                          style: TextStyle(
                              color: Color.fromARGB(255, 255, 255, 255)),
                        )),
                  ]),
            ))
      ],
    );
  }

  Widget _filter(context) {
    _search.text = _deviceParam.keyword.toString();
    return Padding(
      key: stateKey,
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CardHeader(title: '设备类型'),
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Cell(
              text: selectedValue != null && selectedValue! >= 0
                  ? deviceTypes[selectedValue!]['name']
                  : '选择类型',
              onTap: () async {
                if (deviceTypes.isEmpty) {
                  deviceTypes = await _getDeviceTypes();
                }
                showCupertinoModalPopup(
                  builder: (context) {
                    var controllr = FixedExtentScrollController(
                        initialItem: selectedValue ?? 0);
                    return Container(
                      height: 300,
                      padding: const EdgeInsets.all(10),
                      width: MediaQuery.of(context).size.width,
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10)),
                          color: Colors.white),
                      child: Column(
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text(
                                  "取消",
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(
                                      context, controllr.selectedItem);
                                },
                                child: const Text(
                                  "确认",
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                            ],
                          ),
                          Expanded(
                            child: DefaultTextStyle(
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 22,
                              ),
                              child: SizedBox(
                                height: 300,
                                child: CupertinoPicker(
                                  scrollController: controllr,
                                  itemExtent: 50, //行高
                                  onSelectedItemChanged: (value) {},
                                  children: deviceTypes.map((data) {
                                    return Center(
                                      child: Text(
                                        data['name'],
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  context: context,
                ).then((value) {
                  if (value != null) {
                    setState(() {
                      selectedValue = value;
                      _deviceParam.deviceTypeId =
                          deviceTypes[selectedValue!]['type'];
                    });
                    _reloadTextSetter(() {});
                  }
                });
              },
            ),
          ),
          const CardHeader(title: '设备状态'),
          ButtonBarState(
            index: _deviceParam.alarm,
            names: const [
              {'text': '全部', 'value': null},
              {'text': '正常', 'value': 1},
              {'text': '报警', 'value': 2},
              {'text': '故障', 'value': 3}
            ],
            onTap: (index) {
              _deviceParam.alarm = index;
            },
          ),
          const CardHeader(title: '在线状态'),
          ButtonBarState(
            index: _deviceParam.online,
            names: const [
              {'text': '全部', 'value': null},
              {'text': '在线', 'value': 2},
              {'text': '离线', 'value': 3},
              {'text': '未上线', 'value': 1}
            ],
            onTap: (index) {
              _reloadTextSetter(() {
                _deviceParam.online = index;
              });
            },
          ),
          const CardHeader(title: '封停状态'),
          ButtonBarState(
            index: _deviceParam.stop,
            names: const [
              {'text': '全部', 'value': null},
              {'text': '正常', 'value': 0},
              {'text': '封停', 'value': 1}
            ],
            onTap: (index) {
              _reloadTextSetter(() {
                _deviceParam.stop = index;
              });
            },
          ),
          const CardHeader(title: '设备位置'),
          Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Cell(
                text: _position.isNotEmpty ? _setPositionText() : '请选择设备位置',
                onTap: () {
                  showCupertinoModalPopup(
                      context: context,
                      builder: (ctx) {
                        return Container(
                          height: 400,
                          width: MediaQuery.of(ctx).size.width,
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
                                _deviceParam.unitId = item['unitId'];
                                _deviceParam.buildId = null;
                                _deviceParam.floorId = null;
                                _deviceParam.roomId = null;
                                return data;
                              }

                              if (item['type'] == 'build') {
                                var data = await _getBuildingFloors(item['id']);
                                _deviceParam.buildId = item['id'];
                                _deviceParam.floorId = null;
                                _deviceParam.roomId = null;
                                return data;
                              }
                              if (item['type'] == 'floor') {
                                var data = await _getuildingRooms(
                                    item['buildingId'], item['id']);
                                _deviceParam.floorId = item['id'];
                                _deviceParam.roomId = null;
                                return data;
                              }

                              if (item['type'] == 'room') {
                                _deviceParam.roomId = item['id'];
                              }
                              return [];
                            },
                            onClose: (todo) {
                              Navigator.pop(ctx);
                              _setPosition(todo);
                              _reloadTextSetter(() {});
                            },
                            options: data,
                          ),
                        );
                      });
                },
              )),
          const CardHeader(title: '搜索'),
          TextField(
            controller: _search
              ..selection = TextSelection.fromPosition(
                  TextPosition(offset: _deviceParam.keyword!.length)),
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
              _reloadTextSetter(() {
                _deviceParam.keyword = value;
              });
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

  _setPosition(todo) {
    setState(() {
      _position = todo;
    });
  }

  String _setPositionText() {
    String message = '';
    for (int i = 0; i < _position.length; i++) {
      message = '$message ${_position[i]["name"]}';
    }
    return message;
  }

  _getDeviceTypes() async {
    List data = await DeviceApi.useDeviceTypes();
    return data;
  }
}
