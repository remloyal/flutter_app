import 'package:fire_control_app/models/unit.dart';
import 'package:flutter/material.dart';

/// 选择的单位状态
class UnitModel extends ChangeNotifier {

  Unit? _unit;

  // 当前选中的单位
  Unit? get unit => _unit;

  // 单位更改后，通知依赖项
  set unit(Unit? unit) {
    _unit = unit;
    super.notifyListeners();
  }
}