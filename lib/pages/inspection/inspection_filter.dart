import 'package:fire_control_app/models/inspection.dart';
import 'package:fire_control_app/widgets/fc_drawer.dart';
import 'package:fire_control_app/widgets/filter_dialog.dart';
import 'package:flutter/cupertino.dart';

/// 任务列表筛选
class TaskFilter extends StatelessWidget {
  final TaskParam param;
  final TaskParam _param;

  TaskFilter({super.key, required this.param}) : _param = TaskParam();

  @override
  Widget build(BuildContext context) {
    FilterController controller = FilterController(reset: () {
      _param
        ..planType = null
        ..type = null
        ..keyword = null
        ..beginTime = null
        ..endTime = null;
    }, confirm: () {
      param
        ..planType = _param.planType
        ..type = _param.type
        ..keyword = _param.keyword
        ..beginTime = _param.beginTime
        ..endTime = _param.endTime;
      param.change();
    });
    return FilterButton(
      controller: controller,
      filterBodyBuilder: (BuildContext context) {
        _initParam();
        return [
          _InspectionTypeAndWay(controller: controller, param: _param),
          KeywordFilterItem(controller: controller, param: _param),
          DateTimeFilterItem(controller: controller, param: _param,)
        ];
      },
    );
  }

  void _initParam() {
    _param
      ..planType = param.planType
      ..type = param.type
      ..keyword = param.keyword
      ..beginTime = param.beginTime
      ..endTime = param.endTime;
  }
}

/// 路线列表筛选
class RouteFilter extends StatelessWidget {
  final RouteParam param;
  final RouteParam _param;

  RouteFilter({super.key, required this.param})
      : _param = RouteParam()
          ..planType = param.planType
          ..type = param.type;

  @override
  Widget build(BuildContext context) {
    FilterController controller = FilterController(reset: () {
      _param
        ..planType = null
        ..type = null;
    }, confirm: () {
      param
        ..planType = _param.planType
        ..type = _param.type;
      param.change();
    });
    return FilterButton(
      controller: controller,
      filterBodyBuilder: (BuildContext context) {
        _initParam();
        return [
          _InspectionTypeAndWay(controller: controller, param: _param),
        ];
      },
    );
  }

  void _initParam() {
    _param
      ..planType = param.planType
      ..type = param.type;
  }
}

class _InspectionTypeAndWay extends StatelessWidget {
  final FilterController controller;
  final RouteParam param;

  const _InspectionTypeAndWay({required this.controller, required this.param});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BottomPickerFilterItem(
          controller: controller,
          title: '巡检类型',
          hintText: '选择巡检类型',
          selected: param.type != null
              ? InspectionTypeExtension.byValue(param.type!).index
              : null,
          onConfirm: (value) {
            param.type = InspectionType.values[value].value;
          },
          items: InspectionType.values.map((e) => e.desc).toList(),
        ),
        ButtonsFilterItem(
          title: '巡检方式',
          selected: InspectionWayExtension.byValue(param.planType).index,
          items: InspectionWay.values.map((e) => e.desc).toList(),
          onTap: (index) {
            param.planType = InspectionWayExtension.byValue(index).value;
          },
          controller: controller,
        )
      ],
    );
  }
}
