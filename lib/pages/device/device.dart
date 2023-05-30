import 'package:fire_control_app/widgets/filter_dialog.dart';
import 'package:flutter/material.dart';
import 'package:fire_control_app/widgets/card_father.dart';
import 'package:fire_control_app/models/device_entity.dart';
import 'package:fire_control_app/http/device_api.dart';
import 'package:fire_control_app/utils/value.dart';
import 'package:fire_control_app/widgets/load_list.dart';
import './device_filter.dart';
import 'package:fire_control_app/widgets/popup/popup_main.dart';

class Device extends StatelessWidget {

  final bool showToolbar;

  final DeviceParams? params;
  final DeviceParams _deviceParam;

  Device({super.key, this.showToolbar = true, this.params})
      : _deviceParam = params ?? DeviceParams();


  @override
  Widget build(BuildContext context) {
    return LoadList<DeviceApi, DeviceParams, DeviceItem>(
      api: DeviceApi(),
      param: _deviceParam,
      toolbarBuilder: showToolbar ? _buildToolbar : null,
      itemBuilder: _buildItem,
    );
  }

  final GlobalKey<FilterDialogState> modelkey = GlobalKey();

  Widget _buildToolbar(BuildContext context, int total) {
    return SizedBox(
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
                    '共 $total 条',
                    style:
                        const TextStyle(fontSize: 14, color: Color(0xff6A6A6A)),
                  ),
                  Builder(builder: (ctx) {
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            Popup(
                                child: FilterDialog(
                              key: modelkey,
                              body: DeviceFilter(
                                  param: _deviceParam,
                                  onChange: (DeviceParams data) {
                                    // _deviceParam = data;
                                    // _deviceParam.change();
                                    modelkey.currentState!.closeModel();
                                  }),
                            )));
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

  Widget _buildItem(BuildContext context, DeviceItem item, int index) {
    return InkWell(
      highlightColor: Colors.amberAccent,
      onTap: () {
        Navigator.pushNamed(context, '/deviceDetails', arguments: item.id);
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
