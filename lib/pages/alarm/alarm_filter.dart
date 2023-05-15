import 'package:fire_control_app/http/alarm_api.dart';
import 'package:fire_control_app/http/device_api.dart';
import 'package:fire_control_app/models/alarm_entity.dart';
import 'package:fire_control_app/models/device_entity.dart';
import 'package:fire_control_app/widgets/fc_drawer.dart';
import 'package:fire_control_app/widgets/filter_dialog.dart';
import 'package:flutter/material.dart';

/// 火情列表筛选
class FireFilter extends StatelessWidget {
  final FireParam param;
  final FireParam _param;

  FireFilter({super.key, required this.param}) : _param = FireParam();

  void _initParam() {
    _param
      ..beginTime = param.beginTime
      ..endTime = param.endTime
      ..sourceType = param.sourceType;
  }

  @override
  Widget build(BuildContext context) {
    FilterController controller = FilterController(reset: () {
      _param
        ..sourceType = 0
        ..beginTime = null
        ..endTime = null;
    }, confirm: () {
      param
        ..sourceType = _param.sourceType
        ..beginTime = _param.beginTime
        ..endTime = _param.endTime;
      param.change();
    });
    return FilterButton(
      controller: controller,
      filterBodyBuilder: (BuildContext context) {
        _initParam();
        return [
          ButtonsFilterItem(
              title: '报警方式',
              selected: _param.sourceType,
              items: FireAlarmType.values
                  .map((e) => e.desc)
                  .toList(growable: false),
              onTap: (index) {
                _param.sourceType = FireAlarmType.values[index].value;
              },
              controller: controller),
          DateTimeFilterItem(
            param: _param,
            controller: controller,
          )
        ];
      },
    );
  }
}

/// 报警故障列表筛选
class AlarmFaultFilter extends StatefulWidget {
  final AlarmParam param;

  const AlarmFaultFilter({super.key, required this.param});

  @override
  State<StatefulWidget> createState() => _AlarmFaultFilterState();
}

class _AlarmFaultFilterState extends State<AlarmFaultFilter> {
  late final AlarmParam _param;

  List<DeviceType>? _deviceTypes;
  List<String>? _names;

  @override
  void initState() {
    _param = AlarmParam();
    DeviceApi.getDeviceTypes().then((value) {
      _deviceTypes = value;
      _names = value.map((e) => e.name).toList(growable: false);
    });
    super.initState();
  }

  void _initParam() {
    _param
      ..deviceTypeId = widget.param.deviceTypeId
      ..beginTime = widget.param.beginTime
      ..endTime = widget.param.endTime
      ..keyword = widget.param.keyword;
  }

  @override
  Widget build(BuildContext context) {
    FilterController controller = FilterController(reset: () {
      _param
        ..deviceTypeId = null
        ..keyword = null
        ..beginTime = null
        ..endTime = null;
    }, confirm: () {
      widget.param
        ..deviceTypeId = _param.deviceTypeId
        ..keyword = _param.keyword
        ..beginTime = _param.beginTime
        ..endTime = _param.endTime;
      widget.param.change();
    });

    return FilterButton(
      controller: controller,
      filterBodyBuilder: (BuildContext context) {
        _initParam();
        int index = _deviceTypes?.indexWhere(
                (element) => element.type == _param.deviceTypeId) ??
            -1;
        return [
          BottomPickerFilterItem(
            title: '设备类型',
            controller: controller,
            hintText: '选择设备类型',
            selected: index >= 0 ? index : null,
            search: true,
            onConfirm: (value) {
              String name = _names![value];
              DeviceType type =
                  _deviceTypes!.firstWhere((element) => element.name == name);
              _param.deviceTypeId = type.type;
            },
            items: _names ?? [],
          ),
          KeywordFilterItem(
            hintText: '请输入设备名称、设备MAC或告警事件',
            param: _param,
            controller: controller,
          ),
          DateTimeFilterItem(
            param: _param,
            controller: controller,
          )
        ];
      },
    );
  }
}

/// 隐患列表筛选
class TroubleFilter extends StatelessWidget {
  final TroubleParam param;
  final TroubleParam _param;

  TroubleFilter({super.key, required this.param}) : _param = TroubleParam();

  void _initParam() {
    _param
      ..beginTime = param.beginTime
      ..endTime = param.endTime
      ..type = param.type
      ..levels = param.levels;
  }

  @override
  Widget build(BuildContext context) {
    FilterController controller = FilterController(reset: () {
      _param
        ..levels = null
        ..type = null
        ..beginTime = null
        ..endTime = null;
    }, confirm: () {
      param
        ..levels = _param.levels
        ..type = _param.type
        ..beginTime = _param.beginTime
        ..endTime = _param.endTime;
      param.change();
    });

    return FilterButton(
      controller: controller,
      filterBodyBuilder: (BuildContext context) {
        _initParam();
        return [
          ButtonsFilterItem(
              title: '隐患类型',
              selected: _param.type != null ? _param.type! + 1 : 0,
              items:
                  TroubleType.values.map((e) => e.desc).toList(growable: false),
              onTap: (index) {
                _param.type = index > 0 ? index : null;
              },
              controller: controller),
          ButtonsFilterItem(
              title: '隐患级别',
              selected: _param.levels ?? 0,
              items: TroubleLevel.values
                  .map((e) => e.desc)
                  .toList(growable: false),
              onTap: (index) {
                _param.levels = index > 0 ? index : null;
              },
              controller: controller),
          DateTimeFilterItem(
            param: _param,
            controller: controller,
          )
        ];
      },
    );
  }
}

/// 危险品列表筛选
class DangerFilter extends StatefulWidget {
  final DangerParam param;

  const DangerFilter({super.key, required this.param});

  @override
  State<StatefulWidget> createState() => _DangerFilterState();
}

class _DangerFilterState extends State<DangerFilter> {
  late final DangerParam _param;

  List<DangerType>? _dangerTypes;
  List<String>? _names;

  @override
  void initState() {
    _param = DangerParam();
    DangerApi.getDangerTypes().then((value) {
      _dangerTypes = value;
      _names = value.map((e) => e.name).toList(growable: false);
    });
    super.initState();
  }

  void _initParam() {
    _param
      ..type = widget.param.type
      ..beginTime = widget.param.beginTime
      ..endTime = widget.param.endTime;
  }

  @override
  Widget build(BuildContext context) {
    FilterController controller = FilterController(reset: () {
      _param
        ..type = null
        ..beginTime = null
        ..endTime = null;
    }, confirm: () {
      widget.param
        ..type = _param.type
        ..beginTime = _param.beginTime
        ..endTime = _param.endTime;
      widget.param.change();
    });

    return FilterButton(
      controller: controller,
      filterBodyBuilder: (BuildContext context) {
        _initParam();
        int index = _dangerTypes?.indexWhere(
                (element) => element.id == _param.type) ??
            -1;
        return [
          BottomPickerFilterItem(
            title: '危险品类型',
            controller: controller,
            hintText: '选择危险品类型',
            selected: index >= 0 ? index : null,
            onConfirm: (value) {
              String name = _names![value];
              DangerType type =
              _dangerTypes!.firstWhere((element) => element.name == name);
              _param.type = type.id;
            },
            items: _names ?? [],
          ),
          DateTimeFilterItem(
            param: _param,
            controller: controller,
          )
        ];
      },
    );
  }
}


/// 风险列表筛选
class RiskFilter extends StatelessWidget {
  final RiskParam param;
  final RiskParam _param;

  RiskFilter({super.key, required this.param}) : _param = RiskParam();

  void _initParam() {
    _param
      ..beginTime = param.beginTime
      ..endTime = param.endTime
      ..warnType = param.warnType;
  }

  @override
  Widget build(BuildContext context) {
    FilterController controller = FilterController(reset: () {
      _param
        ..warnType = null
        ..beginTime = null
        ..endTime = null;
    }, confirm: () {
      param
        ..warnType = _param.warnType
        ..beginTime = _param.beginTime
        ..endTime = _param.endTime;
      param.change();
    });

    return FilterButton(
      controller: controller,
      filterBodyBuilder: (BuildContext context) {
        _initParam();
        return [
          BottomPickerFilterItem(
            controller: controller,
            title: '风险类型',
            hintText: '选择风险类型',
            selected: _param.warnType,
            onConfirm: (value) {
              _param.warnType = value > 0 ? value : null;
            },
            items: RiskType.values.map((e) => e.desc).toList(growable: false),
          ),
          DateTimeFilterItem(
            param: _param,
            controller: controller,
          )
        ];
      },
    );
  }
}

/// 提醒列表筛选
class RemindFilter extends StatelessWidget {
  final RemindParam param;
  final RemindParam _param;

  RemindFilter({super.key, required this.param}) : _param = RemindParam();

  void _initParam() {
    _param
      ..beginTime = param.beginTime
      ..endTime = param.endTime
      ..type = param.type;
  }

  @override
  Widget build(BuildContext context) {
    FilterController controller = FilterController(reset: () {
      _param
        ..type = null
        ..beginTime = null
        ..endTime = null;
    }, confirm: () {
      param
        ..type = _param.type
        ..beginTime = _param.beginTime
        ..endTime = _param.endTime;
      param.change();
    });

    return FilterButton(
      controller: controller,
      filterBodyBuilder: (BuildContext context) {
        _initParam();
        return [
          BottomPickerFilterItem(
            controller: controller,
            title: '提醒类型',
            hintText: '选择提醒类型',
            selected: _param.type,
            onConfirm: (value) {
              _param.type = value > 0 ? value : null;
            },
            items: RemindType.values.map((e) => e.desc).toList(growable: false),
          ),
          DateTimeFilterItem(
            param: _param,
            controller: controller,
          )
        ];
      },
    );
  }
}
