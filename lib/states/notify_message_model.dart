import 'package:fire_control_app/models/notification.dart';
import 'package:flutter/material.dart';

/// websocket推送的消息
class NotifyMessageModel extends ChangeNotifier {

  // 当前播放的横幅信息
  NotifyMessage? _currentMessage;

  NotifyMessage? get currentMessage => _currentMessage;

  set currentMessage(NotifyMessage? message) {
    _currentMessage = message;
    super.notifyListeners();
  }

  // 即将播放的横幅信息
  NotifyMessage? _nextMessage;

  NotifyMessage? get nextMessage => _nextMessage;

  set nextMessage(NotifyMessage? message) {
    _nextMessage = message;
    super.notifyListeners();
  }

  // 剩余的信息数量
  int _remainCount = 0;

  int get remainCount => _remainCount;

  set remainCount(int count) {
    _remainCount = count;
    super.notifyListeners();
  }

  void clear() {
    _currentMessage = null;
    _nextMessage = null;
    _remainCount = 0;
  }
}