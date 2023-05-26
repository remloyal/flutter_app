import 'package:fire_control_app/common/fc_color.dart';
import 'package:fire_control_app/common/fc_icon.dart';
import 'package:flutter/material.dart';

/// websocket推送的opt消息体
class NotifyMessage {
    String code;
    int type;
    String title;
    String description;
    String time;
    // int messageId;
    int? referenceId;
    int? referenceUnitId;
    bool voice;
    bool popup;

    NotifyMessage.fromJson(Map<String, dynamic> json)
        : code = json['code'],
          type = json['type'],
          title = json['title'],
          description = json['description'],
          time = json['time'],
          // messageId = json['messageId'],
          referenceId = json['referenceId'],
          referenceUnitId = json['referenceUnitId'],
          voice = json['voice'],
          popup = json['popup'];

    @override
    bool operator ==(Object other) {
        if (identical(this, other)) return true;
        if (other is NotifyMessage) return code == other.code;
        return false;
    }

  @override
  int get hashCode => code.hashCode;
}

enum BannerType {
    none,
    alarm,
    fire,
    fault,
    trouble,
    danger
}

class BannerConfig {
    String name;
    IconData iconData;
    Color bgColor;
    BannerType type;

    BannerConfig.of(this.name, this.iconData, this.bgColor, this.type);
}

//需要弹卡片点击跳路由的socketType
// socket-level-1  (1-6,9)
// 设备告警
// 1级 火警
// 2级 设备重点事件报警
// 3级 设备一般事件报警、设备风险
// 4级 设备故障、离线、
// 5级 自检、设备布控、消音等
// 6级 预留
// 9级 关闭、复位
// 平台事件
// 3级 危险品，隐患，活动（国事）、单位风险
// 4级 任务未完成，活动（民事重要）、建筑风险
// 5级 公告、消息通知，自检，活动（一般）
// 9级 复位
Map<int, BannerConfig> notificationTypes = {
    // 系统报警
    1: BannerConfig.of("告警", MsgIcon.alarm, FcColor.bannerLevel2, BannerType.alarm),
    // 人工上报火情
    2: BannerConfig.of("上报火情", MsgIcon.fire, FcColor.bannerLevel1, BannerType.fire),
    // 关闭人工报警
    3: BannerConfig.of("关闭火情", MsgIcon.fire, FcColor.bannerLevel7, BannerType.fire),
    // 重置系统报警
    4: BannerConfig.of("告警复位", MsgIcon.alarm, FcColor.bannerLevel7, BannerType.alarm),
    // 确认火情
    5: BannerConfig.of("确认火情", MsgIcon.fire, FcColor.bannerLevel1, BannerType.fire),
    // 关闭火情
    6: BannerConfig.of("关闭火情", MsgIcon.fire, FcColor.bannerLevel7, BannerType.fire),
    // 系统故障
    7: BannerConfig.of("故障", MsgIcon.fault, FcColor.bannerLevel4, BannerType.fault),
    // 重置系统故障
    8: BannerConfig.of("故障恢复", MsgIcon.fault, FcColor.bannerLevel7, BannerType.fault),
    // 发现隐患
    9: BannerConfig.of("发现隐患", MsgIcon.trouble, FcColor.bannerLevel4, BannerType.trouble),
    // 解决隐患
    10: BannerConfig.of("解决隐患", MsgIcon.trouble, FcColor.bannerLevel7, BannerType.trouble),
    // 确认未发生火情
    20: BannerConfig.of("确认未发生火情", MsgIcon.alarm, FcColor.bannerLevel7, BannerType.none),
    // 语音合成
    25: BannerConfig.of("自检", MsgIcon.remind, FcColor.bannerLevel5, BannerType.none),
    // 添加危险品
    34: BannerConfig.of("危险品", MsgIcon.danger, FcColor.bannerLevel4, BannerType.danger),
    // 	处理危险品
    35: BannerConfig.of("危险品", MsgIcon.danger, FcColor.bannerLevel7, BannerType.danger),
    // 手动复位系统报警
    37: BannerConfig.of("复位", MsgIcon.alarm, FcColor.bannerLevel7, BannerType.none),
    // 手动复位主机
    38: BannerConfig.of("复位", MsgIcon.alarm, FcColor.bannerLevel7, BannerType.none),
    // 系统报警
    39: BannerConfig.of("告警", MsgIcon.alarm, FcColor.bannerLevel2, BannerType.alarm),
    // 系统故障
    40: BannerConfig.of("故障", MsgIcon.fault, FcColor.bannerLevel4, BannerType.fault),
    // 报警恢复
    41: BannerConfig.of("复位", MsgIcon.alarm, FcColor.bannerLevel7, BannerType.alarm),
    // 故障恢复
    42: BannerConfig.of("复位", MsgIcon.fault, FcColor.bannerLevel7, BannerType.fault),
    // 设备风险报警
    65: BannerConfig.of("设备风险告警", MsgIcon.risk, FcColor.bannerLevel3, BannerType.none),
    // 建筑风险报警
    66: BannerConfig.of("建筑风险告警", MsgIcon.risk, FcColor.bannerLevel4, BannerType.none),
    // 单位风险报警
    67: BannerConfig.of("单位风险告警", MsgIcon.risk, FcColor.bannerLevel3, BannerType.none),
    // 设备风险报警解除
    89: BannerConfig.of("设备风险解除", MsgIcon.risk, FcColor.bannerLevel7, BannerType.none),
    // 建筑风险报警
    90: BannerConfig.of("建筑风险解除", MsgIcon.risk, FcColor.bannerLevel7, BannerType.none),
    // 单位风险报警解除
    91: BannerConfig.of("单位风险解除", MsgIcon.risk, FcColor.bannerLevel7, BannerType.none),
    // 消防栓报警
    92: BannerConfig.of("消防栓水量超限解除", MsgIcon.risk, FcColor.bannerLevel7, BannerType.none),

    // 二次人工上报火情
    73: BannerConfig.of("人工上报火情", MsgIcon.fire, FcColor.bannerLevel1, BannerType.fire),
    // 二次设备报警
    77: BannerConfig.of("设备报警", MsgIcon.alarm, FcColor.bannerLevel2, BannerType.alarm),
    // 二次设备故障
    79: BannerConfig.of("设备故障", MsgIcon.fault, FcColor.bannerLevel4, BannerType.fault),
    // 二次隐患上报
    84: BannerConfig.of("隐患", MsgIcon.trouble, FcColor.bannerLevel3, BannerType.trouble),
    // 二次危险品上报
    86: BannerConfig.of("危险品", MsgIcon.danger, FcColor.bannerLevel3, BannerType.danger),

    // 提示-设备自检
    72: BannerConfig.of("设备提醒", MsgIcon.remind, FcColor.bannerLevel5, BannerType.none),
    // 巡检未完成
    71: BannerConfig.of("巡检未完成", MsgIcon.inspection, FcColor.bannerLevel4, BannerType.none),
    // 巡检未完成
    93: BannerConfig.of("巡检未完成", MsgIcon.inspection, FcColor.bannerLevel4, BannerType.none),
};