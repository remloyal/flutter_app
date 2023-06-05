import 'package:fire_control_app/common/fc_color.dart';
import 'package:fire_control_app/common/router.dart';
import 'package:fire_control_app/http/home_api.dart';
import 'package:fire_control_app/http/unit_api.dart';
import 'package:fire_control_app/models/home.dart';
import 'package:fire_control_app/models/unit.dart';
import 'package:fire_control_app/pages/home/report/danger_report.dart';
import 'package:fire_control_app/pages/home/report/file_upload.dart';
import 'package:fire_control_app/pages/home/report/fire_report.dart';
import 'package:fire_control_app/pages/home/report/trouble_report.dart';
import 'package:fire_control_app/pages/map/map.dart';
import 'package:fire_control_app/pages/map/map_method.dart';
import 'package:fire_control_app/utils/toast.dart';
import 'package:fire_control_app/widgets/button_group.dart';
import 'package:fire_control_app/widgets/card_father.dart';
import 'package:fire_control_app/widgets/cascader.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fire_control_app/widgets/fc_details.dart';
import 'package:permission_handler/permission_handler.dart';

class HomeReport extends StatefulWidget {
  const HomeReport({super.key});

  static const routeName = '/homeReport';

  @override
  State<HomeReport> createState() => _HomeReportState();
}

class _HomeReportState extends State<HomeReport> {
  final FileData fileData = FileData();

  final FileUpdateParam _fileUpdateParam = FileUpdateParam();
  final TroubleUpdateParam _troubleUpdateParam = TroubleUpdateParam();
  final DangerUpdateParam _dangerUpdateParam = DangerUpdateParam();

  List buildingData = [];
  MapInfo mapInfo = MapInfo();
  late int tableIndex = 0;
  late bool shouldPop = false;

  late bool permissionState = false;

  @override
  void initState() {
    super.initState();
    mapInfo.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return FcDetailPage(
      title: '立即上报',
      // roll: false,
      shouldPop: shouldPop,
      onBackPressed: () async {
        return await showTips();
      },
      body: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ButtonGroup(
                names: const ['火情', '隐患', '危险品'],
                height: 36,
                width: 90,
                onTap: (index) {
                  tableIndex = index;
                  mapInfo.typeIndex = index;
                  setState(() {});
                },
              ),
            ],
          ),
        ),
        CardParent(
          header: Row(children: [
            Container(width: 3, height: 14, color: FcColor.baseColor, margin: const EdgeInsets.fromLTRB(0, 0, 10, 0)),
            const Expanded(
              flex: 1,
              child: Text('发生位置'),
            ),
          ]),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: () {
                  Navigator.pushNamed(context, RouterUtil.unitSelect, arguments: {
                    "type": 'select',
                    "param": (Unit unit) {
                      mapInfo.unit = unit;
                      mapInfo.building = null;
                      mapInfo.textName = '';
                      setState(() {});
                    }
                  });
                },
                child: setPositionItem('单位名称', '选择单位', mapInfo.unit != null ? mapInfo.unit!.name : ''),
              ),
              if (mapInfo.unit != null)
                const Divider(
                  height: 1.0,
                  // indent: 60.0,
                  color: Color(0xFFCCCCCC),
                ),
              if (mapInfo.unit != null)
                InkWell(
                  onTap: () async {
                    buildingData = await _getBuilding();
                    showSelect();
                  },
                  child: setPositionItem('发生地点', '发生地点', mapInfo.textName),
                ),
              if (mapInfo.floor != null || mapInfo.textName == '室外')
                const Divider(
                  height: 1.0,
                  // indent: 60.0,
                  color: Color(0xFFCCCCCC),
                ),
              if (mapInfo.floor != null || mapInfo.textName == '室外')
                InkWell(
                  onTap: () {
                    mapInfo.type = mapInfo.building!['name'] == '室外' ? MapType.map : MapType.planView;
                    if (permissionState) {
                      callback();
                    } else {
                      requestPermission();
                    }
                  },
                  child: setPositionItem('坐标信息', '坐标信息', mapInfo.point != null ? mapInfo.point!.join(',') : ''),
                ),
            ],
          ),
        ),
        if (tableIndex == 0)
          FireReport(
            param: _fileUpdateParam,
          ),
        if (tableIndex == 1)
          TroubleReport(
            param: _troubleUpdateParam,
          ),
        if (tableIndex == 2)
          DangerReport(
            param: _dangerUpdateParam,
          ),
        FileUpdate(
          fileData: fileData,
        )
      ],
      footer: [
        Expanded(
          child: HandleButton(
            onPressed: () {
              // Navigator.pop(context);
              onSubmit();
            },
            title: '提交',
          ),
        )
      ],
    );
  }

  Widget setPositionItem(String name, String defaultValue, String? price) {
    return Padding(
      padding: const EdgeInsets.only(top: 12, bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text(name),
              Container(
                width: 220,
                padding: const EdgeInsets.only(left: 40),
                child: price != ''
                    ? Text(price!)
                    : Text(
                        defaultValue,
                        // maxLines: 6,
                        // softWrap: true,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: Color(0XFFCCCCCC)),
                      ),
              )
            ],
          ),
          const Icon(
            Icons.arrow_forward_ios,
            size: 18,
            color: Color(0xFF999999),
          ),
        ],
      ),
    );
  }

  showTips() async {
    bool? flag = await showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("提示"),
            content: const Text("当前页面数据将不做保存，您确定要退出吗?"),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                  child: const Text("确定")),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: const Text(
                    "取消",
                    style: TextStyle(color: Color(0xffcccccc)),
                  ))
            ],
          );
        });
    return flag;
  }

  //
  showSelect() {
    showCupertinoModalPopup(
        context: context,
        builder: (ctx) {
          return Container(
            height: 400,
            width: MediaQuery.of(ctx).size.width,
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                color: Colors.grey[200]),
            child: Cascader(
              title: '请选择发生地点',
              customField: 'name',
              asyncCallBack: (item, tabIndex, itemIndex) async {
                if (item['type'] == 'build') {
                  if (item['id'] == null) return [];
                  var data = await _getBuildingFloors(item['id']);
                  return data;
                }
                if (item['type'] == 'floor') {
                  var data = await _getuildingRooms(item['buildingId'], item['id']);

                  return data;
                }

                if (item['type'] == 'room') {}
                return [];
              },
              onClose: (List todo) {
                setUpdateInfo(todo);
                Navigator.pop(ctx);
              },
              options: buildingData,
            ),
          );
        });
  }

  _getBuilding() async {
    var data = await UnitApi.getBuilding(mapInfo.unit!.unitId);
    List todo = [];
    for (var i = 0; i < data.length; i++) {
      Map item = {'name': data[i].name, 'id': data[i].id, "type": 'build'};
      todo.add(item);
    }
    todo.add({'name': '室外', 'id': null, "type": 'build'});
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
        'buildingId': buildingId,
        'svgUrl': data[i].svgUrl
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

  void setUpdateInfo(List todo) {
    for (var item in todo) {
      if (item["type"] == 'build') {
        mapInfo.building = item;
      }
      if (item["type"] == 'floor') {
        mapInfo.floor = item;
      }
      if (item["type"] == 'room') {
        mapInfo.room = item;
      }
    }
    if (todo.length == 1) {
      mapInfo.floor = null;
      mapInfo.room = null;
    }
    if (todo.length == 2) {
      mapInfo.room = null;
    }
    mapInfo.point = null;
    mapInfo.initText();
    setState(() {});
  }

  callback() {
    Navigator.pushNamed(context, MapCase.routeName, arguments: {
      'info': mapInfo,
    });
  }

  onSubmit() {
    if (fileData.state == false) {
      Message.error('文件未全部上传完成，请稍后');
      return;
    }
    if (tableIndex == 0) {
      onFileSubmit();
    }
    if (tableIndex == 1) {
      onTroubleSubmit();
    }
    if (tableIndex == 2) {
      onDangerSubmit();
    }
  }

  onFileSubmit() async {
    if (mapInfo.unit == null) {
      Message.error('请选择单位');
      return;
    }
    _fileUpdateParam.unitId = mapInfo.unit!.unitId;
    _fileUpdateParam.buildingId = mapInfo.building!['id'];
    _fileUpdateParam.floorId = mapInfo.floor == null ? null : mapInfo.floor!['id'];
    _fileUpdateParam.roomId = mapInfo.room == null ? null : mapInfo.room!['id'];
    _fileUpdateParam.fileNumber = fileData.converts.length;
    _fileUpdateParam.attachmentIds = fileData.fileIds.join(',');

    if (mapInfo.building!["name"] == "室外" && mapInfo.point != null) {
      _fileUpdateParam.pointX = mapInfo.point![0];
      _fileUpdateParam.pointY = mapInfo.point![1];
    }

    if (mapInfo.floor != null && mapInfo.point != null) {
      _fileUpdateParam.xRate = mapInfo.point![0];
      _fileUpdateParam.yRate = mapInfo.point![1];
    }

    var data = _fileUpdateParam.check();
    if (data == true) {
      var response = await HomeApi.reportFire(_fileUpdateParam);
      if (response['code'] == 200) {
        shouldPop = true;
        Message.show('上报火情成功');
        setState(() {
          Future.delayed(const Duration(milliseconds: 2000), () {
            Navigator.pop(context);
          });
        });
      } else {
        Message.error(response['message'] ?? '上报失败');
      }
    } else {
      Message.error(data);
    }
  }

  onTroubleSubmit() async {
    if (mapInfo.unit == null) {
      Message.error('请选择单位');
      return;
    }
    _troubleUpdateParam.unitId = mapInfo.unit!.unitId;
    _troubleUpdateParam.buildingId = mapInfo.building!['id'];
    _troubleUpdateParam.floorId = mapInfo.floor == null ? null : mapInfo.floor!['id'];
    _troubleUpdateParam.roomId = mapInfo.room == null ? null : mapInfo.room!['id'];
    _troubleUpdateParam.fileNumber = fileData.converts.length;
    _troubleUpdateParam.attachmentIds = fileData.fileIds.join(',');

    if (mapInfo.building!["name"] == "室外" && mapInfo.point != null) {
      _troubleUpdateParam.pointX = mapInfo.point![0];
      _troubleUpdateParam.pointY = mapInfo.point![1];
    }

    if (mapInfo.floor != null && mapInfo.point != null) {
      _troubleUpdateParam.xRate = mapInfo.point![0];
      _troubleUpdateParam.yRate = mapInfo.point![1];
    }

    var data = _troubleUpdateParam.check();
    if (data == true) {
      var response = await HomeApi.reportTrouble(_troubleUpdateParam);
      if (response['code'] == 200) {
        shouldPop = true;
        Message.show('上报隐患成功');
        setState(() {
          Future.delayed(const Duration(milliseconds: 2000), () {
            Navigator.pop(context);
          });
        });
      } else {
        Message.error(response['message'] ?? '上报失败');
      }
    } else {
      Message.error(data);
    }
  }

  onDangerSubmit() async {
    if (mapInfo.unit == null) {
      Message.error('请选择单位');
      return;
    }

    _dangerUpdateParam.unitId = mapInfo.unit!.unitId;
    _dangerUpdateParam.buildingId = mapInfo.building!['id'];
    _dangerUpdateParam.floorId = mapInfo.floor == null ? null : mapInfo.floor!['id'];
    _dangerUpdateParam.roomId = mapInfo.room == null ? null : mapInfo.room!['id'];
    _dangerUpdateParam.fileNumber = fileData.converts.length;
    _dangerUpdateParam.attachmentIds = fileData.fileIds.join(',');

    if (mapInfo.building!["name"] == "室外" && mapInfo.point != null) {
      _dangerUpdateParam.pointX = mapInfo.point![0];
      _dangerUpdateParam.pointY = mapInfo.point![1];
    }

    if (mapInfo.floor != null && mapInfo.point != null) {
      _dangerUpdateParam.xRate = mapInfo.point![0];
      _dangerUpdateParam.yRate = mapInfo.point![1];
    }

    var data = _dangerUpdateParam.check();
    if (data == true) {
      var response = await HomeApi.reportDanger(_dangerUpdateParam);
      if (response['code'] == 200) {
        shouldPop = true;
        Message.show('上报危险品成功');
        setState(() {
          Future.delayed(const Duration(milliseconds: 2000), () {
            Navigator.pop(context);
          });
        });
      } else {
        Message.error(response['message'] ?? '上报失败');
      }
    } else {
      Message.error(data);
    }
  }

  // 申请权限
  // final PermissionStatus permissionStatus = PermissionStatus.denied;

  requestPermission() async {
    getMicrophonePermission().then((value) => {
          setState(() {
            permissionState = value;
          })
        });
  }

  Future<bool> getMicrophonePermission() async {
    // You can request multiple permissions at once.
    Map<Permission, PermissionStatus> statuses = await [
      Permission.location,
    ].request();

    // PermissionStatus status = await Permission.location.request();

    // 拒绝前往设置
    if (statuses[Permission.location]!.isPermanentlyDenied) {
      openApp();
    }

    if (statuses[Permission.location]!.isGranted) {
      callback();
      return true;
    }
    // openAppSettings();
    return false;
  }

  openApp() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('允许应用访问您位置?'),
        content: const Text('您需要在设置中启用相应权限，才能在应用程序中使用您的地图'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('拒绝'),
          ),
          TextButton(
            onPressed: () {
              openAppSettings();
              Navigator.pop(ctx);
            },
            child: const Text('允许'),
          ),
        ],
      ),
    );
  }
}
