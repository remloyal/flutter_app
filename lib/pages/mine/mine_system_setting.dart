import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fire_control_app/utils/toast.dart';
import 'package:fire_control_app/widgets/card_father.dart';
import 'package:fire_control_app/widgets/fc_details.dart';
import 'package:fire_control_app/common/global.dart';
import 'package:fire_control_app/http/mine_api.dart';
import 'package:fire_control_app/http/login_api.dart';
import 'package:fire_control_app/pages/map/cache/app_dir.dart';

class MineSystemSetting extends StatefulWidget {
  const MineSystemSetting({super.key});

  @override
  State<MineSystemSetting> createState() => _MineSystemSettingState();
}

class _MineSystemSettingState extends State<MineSystemSetting> {
  // 倒计时
  late Timer _timer;
  late int _countdownTime = 0;
  late String? logOffCode = '';
  late int size = 0;
  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    size = await CacheUtil.total();
    setState(() {});
  }

  // 倒计时
  void startCountdownTimer() {
    const oneSec = Duration(seconds: 1);
    callback(timer) => {
          _reloadTextSetter(() {
            if (_countdownTime < 1) {
              _timer.cancel();
            } else {
              _countdownTime = _countdownTime - 1;
            }
          })
        };
    _timer = Timer.periodic(oneSec, callback);
  }

  // 倒计时
  countDown() {
    if (_countdownTime == 0) {
      //Http请求发送验证码
      _reloadTextSetter(() {
        _countdownTime = 60;
        //开始倒计时
        startCountdownTimer();
      });
    }
  }

  late StateSetter _reloadTextSetter;

  @override
  Widget build(BuildContext context) {
    return FcDetailPage(
      title: '系统设置',
      body: [
        CardContainer(children: [
          const CardHeader(
            title: "提醒设置",
          ),
          CardHeader(
              standStart: false,
              title: '报警声音',
              tail: SizedBox(
                height: 30,
                child: Switch(
                    activeColor: const Color(0xFF4CAF50),
                    value: Global.profile.apiInfo.voice,
                    onChanged: (bool state) {
                      Global.profile.apiInfo.voice = state;
                      Global.saveProfile();
                      setState(() {});
                    }),
              )),
          CardHeader(
              standStart: false,
              title: '报警语音',
              tail: SizedBox(
                height: 30,
                child: Switch(
                    activeColor: const Color(0xFF4CAF50),
                    value: Global.profile.apiInfo.pronunciation,
                    onChanged: (bool state) {
                      Global.profile.apiInfo.pronunciation = state;
                      Global.saveProfile();
                      setState(() {});
                    }),
              )),
          CardHeader(
              standStart: false,
              title: '报警震动',
              tail: SizedBox(
                height: 30,
                child: Switch(
                    activeColor: const Color(0xFF4CAF50),
                    value: Global.profile.apiInfo.shock,
                    onChanged: (bool state) {
                      Global.profile.apiInfo.shock = state;
                      Global.saveProfile();
                      setState(() {});
                    }),
              )),
          CardHeader(
              standStart: false,
              title: '短信通知',
              tail: SizedBox(
                height: 30,
                child: Switch(
                    activeColor: const Color(0xFF4CAF50),
                    value: Global.profile.apiInfo.message,
                    onChanged: (bool state) async {
                      var response = await MineApi.changeMessage(state ? 0 : 1);
                      if (response['code'] == 200) {
                        Global.profile.apiInfo.message = state;
                        Global.saveProfile();
                      } else {
                        Global.profile.apiInfo.message = false;
                        Global.saveProfile();
                      }
                      setState(() {});
                    }),
              )),
        ]),
        CardContainer(
          children: [
            const CardHeader(
              title: "其他",
            ),
            CardHeader(
              standStart: false,
              title: '缓存',
              tail: Row(children: [
                Text('${CacheUtil.renderSize(size)}'),
                TextButton(
                    onPressed: () async {
                      setState(() {
                        showDialog(
                          context: context,
                          builder: (BuildContext removeContext) {
                            return AlertDialog(
                              title: const Text("提示"),
                              content: const Text("是否清除缓存？"),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text(
                                    "取消",
                                    style: TextStyle(color: Colors.blue),
                                  ),
                                ),
                                TextButton(
                                    onPressed: () async {
                                      clear();
                                      Navigator.pop(context);
                                    },
                                    child: const Text("确定",
                                        style: TextStyle(
                                          color: Colors.red,
                                        ))),
                              ],
                            );
                          },
                        );
                      });
                    },
                    child: const Text('清除缓存'))
              ]),
            ),
          ],
        ),
        CardContainer(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CardHeader(
              title: "账号注销",
              tail: Text('请谨慎操作', style: TextStyle(color: Colors.red, fontSize: 14)),
            ),
            const Text(
              '注销后您的帐号将发生如下变化：',
              style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 14),
            ),
            const Text(
              '1、永久注销，无法登录',
              style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 14),
            ),
            const Text('为了保障您的用户权利，注销后我们会永久删除您的数据，且解除第三方帐号的绑定关系'),
            const Text(
              '2、此帐号关联的信息将无法找回',
              style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 14),
            ),
            const Text('为了保障您的数据安全，我们将永久删除本帐号所属的产品数据，无法恢复'),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: OutlinedButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (BuildContext context) {
                        return AlertDialog(
                            title: const Center(
                              child: Text('账号注销'),
                            ),
                            content: StatefulBuilder(
                              builder: (context, stateSetter) {
                                _reloadTextSetter = stateSetter;
                                return _setLogOff();
                              },
                            ));
                      });
                },
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.red),
                    side: MaterialStateProperty.all(const BorderSide(color: Colors.red, width: 1)),
                    minimumSize: const MaterialStatePropertyAll(Size.fromHeight(40)),
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)))),
                child: const Text(
                  '已知晓，确认注销',
                  style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
                ),
              ),
            )
          ],
        )
      ],
    );
  }

  // 账号注销验证
  Widget _setLogOff() {
    return SizedBox(
        height: 130,
        child: Column(
          children: [
            TextField(
              keyboardType: TextInputType.number,
              maxLength: 6,
              onChanged: (value) {
                setState(() {
                  logOffCode = value;
                });
              },
              decoration: InputDecoration(
                  // border: InputBorder.none,
                  contentPadding: const EdgeInsets.only(top: 4.0, left: 10.0, right: 10.0, bottom: 4.0),
                  border: const OutlineInputBorder(
                    ///设置边框四个角的弧度
                    borderRadius: BorderRadius.all(Radius.circular(10)),

                    ///用来配置边框的样式
                    borderSide: BorderSide(
                      ///设置边框的颜色
                      color: Colors.red,

                      ///设置边框的粗细
                      width: 1.0,
                    ),
                  ),
                  suffixIcon: TextButton(
                    onPressed: () async {
                      if (_countdownTime == 0) {
                        var data = await MineApi.getUnregisterCode();
                        if (data['code'] == 0) {
                          Message.show('获取验证码成功');
                          countDown();
                        }
                      }
                    },
                    child: Text(
                      _countdownTime > 0 ? '$_countdownTime' : '获取验证码',
                      style: const TextStyle(fontSize: 14),
                    ),
                  )),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Expanded(
                    flex: 2,
                    child: OutlinedButton(
                      onPressed: () {
                        if (_countdownTime > 0) {
                          _reloadTextSetter(
                            () {
                              _countdownTime = 0;
                              _timer.cancel();
                            },
                          );
                        }
                        Navigator.pop(context);
                      },
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(const Color(0xFFD6D6D6)),
                          side: MaterialStateProperty.all(const BorderSide(color: Color(0xFFD6D6D6), width: 1)),
                          minimumSize: const MaterialStatePropertyAll(Size.fromHeight(40)),
                          shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)))),
                      child: const Text(
                        '取消',
                        style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
                      ),
                    )),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                    flex: 2,
                    child: OutlinedButton(
                      onPressed: () {
                        removeDialog(context);
                      },
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(Colors.red),
                          side: MaterialStateProperty.all(const BorderSide(color: Colors.red, width: 1)),
                          minimumSize: const MaterialStatePropertyAll(Size.fromHeight(40)),
                          shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)))),
                      child: const Text(
                        '确认注销',
                        style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
                      ),
                    ))
              ],
            )
          ],
        ));
  }

  // 二次确认删除组件
  removeDialog(ctx) {
    print(logOffCode?.length);
    if (logOffCode?.length != 6) {
      Message.error('请正确填写验证码');
      return;
    }
    showDialog(
      context: context,
      builder: (BuildContext removeContext) {
        return AlertDialog(
          title: const Text("提示"),
          content: const Text("确定注销该账号？"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                "取消",
                style: TextStyle(color: Colors.blue),
              ),
            ),
            TextButton(
                onPressed: () async {
                  var data = await MineApi.unregister(logOffCode!);
                  if (data['code'] == 200) {
                    _reloadTextSetter(
                      () {
                        if (_countdownTime > 0) {
                          _timer.cancel();
                        }
                      },
                    );
                    if (removeContext.mounted) {
                      Navigator.pop(removeContext);
                    }
                    Message.error('账号已注销，退出中...');
                    Navigator.pop(ctx);
                    Future.delayed(const Duration(milliseconds: 2000)).then((e) {
                      LoginService.clearInfo();
                    });
                  } else {
                    if (removeContext.mounted) {
                      Navigator.pop(removeContext);
                    }
                    Message.error(data['message'] ?? '未知错误');
                  }
                },
                child: const Text("确定",
                    style: TextStyle(
                      color: Colors.red,
                    ))),
          ],
        );
      },
    );
  }

  clear() async {
    await CacheUtil.clear();
    await init();
  }
}
