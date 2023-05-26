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
import 'package:fire_control_app/utils/toast.dart';
import 'package:fire_control_app/widgets/button_group.dart';
import 'package:fire_control_app/widgets/card_father.dart';
import 'package:fire_control_app/widgets/cascader.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fire_control_app/widgets/fc_details.dart';

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
  UpdateInfo updateInfo = UpdateInfo();
  late int tableIndex = 0;
  late bool shouldPop = false;

  @override
  void initState() {
    super.initState();
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
                      updateInfo.unit = unit;
                      setState(() {});
                    }
                  });
                },
                child: setPositionItem('单位名称', '选择单位', updateInfo.unit != null ? updateInfo.unit!.name : ''),
              ),
              const Divider(
                height: 1.0,
                // indent: 60.0,
                color: Color(0xFFCCCCCC),
              ),
              InkWell(
                onTap: () async {
                  buildingData = await _getBuilding();
                  showSelect();
                },
                child: setPositionItem('发生地点', '发生地点', updateInfo.textName),
              ),
              const Divider(
                height: 1.0,
                // indent: 60.0,
                color: Color(0xFFCCCCCC),
              ),
              InkWell(
                child: setPositionItem('坐标信息', '坐标信息', ''),
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
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)), color: Colors.grey[200]),
            child: Cascader(
              title: '请选择发生地点',
              customField: 'name',
              asyncCallBack: (item, tabIndex, itemIndex) async {
                // if (item['type'] == 'unit') {
                //   var data = await _getBuilding(item['unitId']);
                //   _deviceParam.unitId = item['unitId'];
                //   _deviceParam.buildId = null;
                //   _deviceParam.floorId = null;
                //   _deviceParam.roomId = null;
                //   return data;
                // }

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
    var data = await UnitApi.getBuilding(updateInfo.unit!.unitId);
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
      Map item = {'name': data[i].name, 'id': data[i].id, "type": 'floor', 'buildingId': buildingId};
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
        updateInfo.building = item;
      }
      if (item["type"] == 'floor') {
        updateInfo.floor = item;
      }
      if (item["type"] == 'room') {
        updateInfo.room = item;
      }
    }
    if (todo.length == 1) {
      updateInfo.floor = null;
      updateInfo.room = null;
    }
    if (todo.length == 2) {
      updateInfo.room = null;
    }
    updateInfo.initText();
    setState(() {});
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
    if (updateInfo.unit == null) {
      Message.error('请选择单位');
      return;
    }
    _fileUpdateParam.unitId = updateInfo.unit!.unitId;
    _fileUpdateParam.buildingId = updateInfo.building!['id'];
    _fileUpdateParam.floorId = updateInfo.floor == null ? null : updateInfo.floor!['id'];
    _fileUpdateParam.roomId = updateInfo.room == null ? null : updateInfo.room!['id'];
    _fileUpdateParam.pointX = 112.938156;
    _fileUpdateParam.pointY = 28.129494;
    _fileUpdateParam.fileNumber = fileData.converts.length;
    _fileUpdateParam.attachmentIds = fileData.fileIds.join(',');

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
    if (updateInfo.unit == null) {
      Message.error('请选择单位');
      return;
    }
    _troubleUpdateParam.unitId = updateInfo.unit!.unitId;
    _troubleUpdateParam.buildingId = updateInfo.building!['id'];
    _troubleUpdateParam.floorId = updateInfo.floor == null ? null : updateInfo.floor!['id'];
    _troubleUpdateParam.roomId = updateInfo.room == null ? null : updateInfo.room!['id'];
    _troubleUpdateParam.pointX = 112.938156;
    _troubleUpdateParam.pointY = 28.129494;
    _troubleUpdateParam.fileNumber = fileData.converts.length;
    _troubleUpdateParam.attachmentIds = fileData.fileIds.join(',');

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
    if (updateInfo.unit == null) {
      Message.error('请选择单位');
      return;
    }
    _dangerUpdateParam.unitId = updateInfo.unit!.unitId;
    _dangerUpdateParam.buildingId = updateInfo.building!['id'];
    _dangerUpdateParam.floorId = updateInfo.floor == null ? null : updateInfo.floor!['id'];
    _dangerUpdateParam.roomId = updateInfo.room == null ? null : updateInfo.room!['id'];
    _dangerUpdateParam.pointX = 112.938156;
    _dangerUpdateParam.pointY = 28.129494;
    _dangerUpdateParam.fileNumber = fileData.converts.length;
    _dangerUpdateParam.attachmentIds = fileData.fileIds.join(',');

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
}
