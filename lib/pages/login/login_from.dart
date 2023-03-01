import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:fire_control_app/common/global.dart';
import './slideVerify.dart';
import 'package:fire_control_app/http/login_api.dart';
import 'package:flutter/cupertino.dart';
import 'package:fire_control_app/utils/toast.dart';

class LoginFrom extends StatefulWidget {
  const LoginFrom({super.key});

  @override
  State<LoginFrom> createState() => _LoginFromState();
}

class _LoginFromState extends State<LoginFrom> {
  final GlobalKey _formKey = GlobalKey<FormState>();
  final Global global = Global();
  final LoginService loginApi = LoginService();
  late BuildContext dialogContext;

  late String _username = '', _code = '';

  // 倒计时
  late Timer _timer;
  int _countdownTime = 0;

  late List<dynamic> unitMethod = [];
  late String unitText = '';

  late String serial = '';

  late num code;

  Map imgList = {
    'top': 0,
    "imgMain": '',
    "imgBlock": '',
  };

  getUserUnit(String user) async {
    var data = await loginApi.getUserUnits(user);
    setState(() {
      unitMethod = data;
    });
    print(unitMethod);
  }

  // 图片验证正确
  success() {
    getCode();
    Navigator.pop(dialogContext);
  }

  // 重新请求
  refresh() async {
    var images = await loginApi.getImage(serial, '');
    return {
      'top': images['data']['y'],
      "imgMain": images['data']['img'].replaceAll('\n', ''),
      "imgBlock": images['data']['mark'].replaceAll('\n', ''),
    };
  }

  // 比对
  check(top) async {
    var state = await loginApi.getValid(serial, top.toString(), '');
    print('refresh $state');
    if (state['errorCode'] == 0) {
      return true;
    } else {
      return false;
    }
  }

  // 倒计时
  void startCountdownTimer() {
    const oneSec = Duration(seconds: 1);
    callback(timer) => {
          setState(() {
            if (_countdownTime < 1) {
              _timer.cancel();
            } else {
              _countdownTime = _countdownTime - 1;
            }
          })
        };
    _timer = Timer.periodic(oneSec, callback);
  }

  // 获取验证码
  getCode() async {
    var data = await loginApi.getCode(_username, serial);
    print('data   $data');
    // json.decoder(data);
    if (data['errorCode'] == 20201) {
      userCheck();
      return;
    } else {
      countDown();
    }
  }

  userCheck() async {
    var data = await loginApi.preCheck(_username);
    if (data['errorCode'] == 20200) {
      serial = data['data']['serial'];
      showCaptchaPopup();
    } else {
      // var checkData = await loginApi.check(_username, serial);
    }
  }

  // 图片验证
  showCaptchaPopup() async {
    var images = await loginApi.getImage(serial, '');
    setState(() {
      imgList = {
        'top': images['data']['y'],
        "imgMain": images['data']['img'].replaceAll('\n', ''),
        "imgBlock": images['data']['mark'].replaceAll('\n', ''),
      };
      Future.delayed(const Duration(milliseconds: 200)).then((e) {
        showCaptcha();
      });
    });
  }

  // 登录
  onSubmit() async {
    var data = await loginApi.login(_username, _code, serial);

    if (data['errorCode'] == 20201) {
      userCheck();
      return;
    }
    if (data['errorCode'] != 0) {
      Message.show(data['message']);
      return;
    }
    Navigator.pushReplacementNamed(context, "/");
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey, // 设置globalKey，用于后面获取FormStat
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        children: [
          buildPhoneTextField(), // 输入手机号
          buildUnitTextField(), // 选择单位
          buildCodeTextField(context),
          buildLoginButton(context),
          buildRegisterText(context) // 注册
        ],
      ),
    );
  }

  Widget buildLoginButton(BuildContext context) {
    return Align(
      child: SizedBox(
        height: 45,
        width: 320,
        child: ElevatedButton(
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.red),
              // 设置圆角
              shape: MaterialStateProperty.all(const StadiumBorder(
                  side: BorderSide(style: BorderStyle.none)))),
          child: const Text('登录',
              style: TextStyle(
                  color: Color.fromARGB(255, 255, 255, 255), fontSize: 18)),
          onPressed: () {
            // 表单校验通过才会继续执行
            if ((_formKey.currentState as FormState).validate()) {
              (_formKey.currentState as FormState).save();
              //TODO 执行登录方法
              onSubmit();
              print('_username: $_username, _code: $_code');
            }
          },
        ),
      ),
    );
  }

  Widget buildPhoneTextField() {
    RegExp phoneReg = RegExp(
        r'^((13[0-9])|(14[0-9])|(15[0-9])|(16[0-9])|(17[0-9])|(18[0-9])|(19[0-9]))\d{8}$');
    return Container(
        width: 320,
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: const Color.fromARGB(245, 245, 245, 245),
          borderRadius: const BorderRadius.all(Radius.circular(25.0)),
          border: Border.all(
              width: 1, color: const Color.fromARGB(245, 245, 245, 245)),
        ),
        child: Flex(direction: Axis.horizontal, children: <Widget>[
          const Expanded(
            flex: 1,
            child: Icon(
              IconData(0xe6df, fontFamily: 'fcm'),
              color: Colors.red,
            ),
          ),
          Expanded(
              flex: 4,
              child: TextFormField(
                keyboardType: TextInputType.number,
                maxLength: 11,
                maxLines: 1,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
                ],
                decoration: const InputDecoration(
                    counterText: '',
                    hintText: "您的手机号",
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    focusedErrorBorder: InputBorder.none),
                validator: (v) {
                  if (!phoneReg.hasMatch(v!)) {
                    print(unitMethod.isNotEmpty);
                    return '请输入正确的手机号';
                  } else {
                    return null;
                  }
                },
                onChanged: (value) {
                  if (phoneReg.hasMatch(value)) {
                    getUserUnit(value);
                    print('输入正确的手机号');
                  }
                  if (unitMethod.isNotEmpty) {
                    Future.delayed(const Duration(milliseconds: 200)).then((e) {
                      setState(() {
                        unitMethod = [];
                        unitText = '';
                      });
                    });
                  }
                  setState(() {
                    _username = value;
                  });
                  print(phoneReg.hasMatch(value));
                },
                onSaved: (v) => _username = v!,
              )),
        ]));
  }

  Widget buildUnitTextField() {
    return Container(
        width: 320,
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: const Color.fromARGB(245, 245, 245, 245),
          borderRadius: const BorderRadius.all(Radius.circular(25.0)),
          border: Border.all(
              width: 1, color: const Color.fromARGB(245, 245, 245, 245)),
        ),
        child: Flex(direction: Axis.horizontal, children: <Widget>[
          const Expanded(
            flex: 1,
            child: Icon(
              IconData(0xe62c, fontFamily: 'fcm'),
              color: Colors.red,
            ),
          ),
          Expanded(
            flex: 4,
            child: SizedBox(
                height: 40.0,
                width: 100,
                // color: Colors.green,
                child: Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: InkWell(
                    onTap: () {
                      print('object');
                      if (unitMethod.isNotEmpty) {
                        showBottomSheet();
                      } else {
                        Message.show('未获取到单位信息');
                      }
                    },
                    child: unitText == ''
                        ? const Text('请输入单位识别码',
                            style: TextStyle(
                              color: Color.fromARGB(152, 152, 152, 152),
                              fontSize: 18,
                              height: 1.2,
                              fontFamily: "Courier",
                            ))
                        : Text(unitText,
                            style: const TextStyle(
                              color: Color.fromARGB(151, 0, 0, 0),
                              fontSize: 18,
                              height: 1.2,
                              fontFamily: "Courier",
                            )),
                  ),
                )),
          ),
          const Expanded(
            flex: 1,
            child: Icon(
              IconData(0xe633, fontFamily: 'fcm'),
              color: Color.fromARGB(97, 24, 24, 24),
              size: 18,
            ),
          ),
        ]));
  }

  Widget buildCodeTextField(BuildContext context) {
    RegExp codeReg = RegExp(r'^[0-9]');
    return Container(
        width: 320,
        margin: const EdgeInsets.only(bottom: 10),
        padding: _countdownTime > 0
            ? const EdgeInsets.only(left: 4)
            : const EdgeInsets.only(left: 8),
        decoration: BoxDecoration(
          color: const Color.fromARGB(245, 245, 245, 245),
          borderRadius: const BorderRadius.all(Radius.circular(25.0)),
          border: Border.all(
              width: 1, color: const Color.fromARGB(245, 245, 245, 245)),
        ),
        child: Flex(direction: Axis.horizontal, children: <Widget>[
          const Expanded(
            flex: 1,
            child: Icon(
              IconData(0xe624, fontFamily: 'fcm'),
              color: Colors.red,
            ),
          ),
          Expanded(
              flex: 4,
              child: TextFormField(
                // enabled: _countdownTime > 0 ? true : false,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
                ],
                decoration: const InputDecoration(
                    counterText: '',
                    hintText: "验证码",
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    focusedErrorBorder: InputBorder.none),
                onSaved: (v) => _code = v!,
                maxLength: 6,
                maxLines: 1,
                validator: (v) {
                  if (v!.runes.length != 6) {
                    return '请输入正确的验证码';
                  }
                  return null;
                },
                onChanged: (value) {
                  _code = value;
                },
              )),
          Expanded(
            flex: _countdownTime > 0 ? 1 : 2,
            child: GestureDetector(
              child: Text(_countdownTime > 0 ? '$_countdownTime' : '获取验证码'),
              onTap: () {
                if (_username.isNotEmpty) {
                  getCode();
                }
              },
            ),
          ),
        ]));
  }

  Widget buildRegisterText(context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('没有账号?'),
            GestureDetector(
              child: const Text('点击注册', style: TextStyle(color: Colors.green)),
              onTap: () {
                print("点击注册");
              },
            )
          ],
        ),
      ),
    );
  }

  // 倒计时
  countDown() {
    if (_countdownTime == 0) {
      //Http请求发送验证码
      setState(() {
        _countdownTime = 60;
      });
      //开始倒计时
      startCountdownTimer();
    }
  }

  // 滑动验证
  showCaptcha() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        dialogContext = context;
        return AlertDialog(
          // title: const Center(heightFactor: 1, child: Text("滑块验证")),
          content: Center(
              heightFactor: 1,
              child: SlideVerify(
                imgBlock: imgList['imgBlock'],
                imgMain: imgList['imgMain'],
                check: check,
                success: success,
                refresh: refresh,
                top: imgList['top'],
              )),
        );
      },
    );
  }

  // 底部弹窗框
  void showBottomSheet() {
    int selectedValue = 0;
    showCupertinoModalPopup(
        context: context,
        builder: (BuildContext context) {
          var controllr =
              FixedExtentScrollController(initialItem: selectedValue);
          return Container(
            height: 350,
            color: Colors.grey[200],
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
                        print('unitText  $unitText');
                        Navigator.pop(context, controllr.selectedItem);
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
                        // diameterRatio: 1.5,
                        // offAxisFraction: 0.2, //轴偏离系数
                        // useMagnifier: true, //使用放大镜
                        // magnification: 1.5, //当前选中item放大倍数
                        itemExtent: 50, //行高
                        // backgroundColor: Colors.amber, //选中器背景色
                        onSelectedItemChanged: (value) {
                          // print("value = $value, 性别：${pickerChildren[value]}");
                          print(unitMethod[value]);
                        },
                        children: unitMethod.map((data) {
                          return Center(
                            child: Text(data['name'] + ' - ${data['code']}'),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }).then((value) {
      print('value  $value');
      if (value == 0) {
        setState(() {
          unitText = unitMethod[value]['name'];
          global.setString('appDomain', unitMethod[value]['domain']);
          global.apiInfo();
        });
        return;
      }
      if (value != selectedValue && value != null) {
        setState(() {
          selectedValue = value;
          unitText = unitMethod[value]['name'];
          global.setString('appDomain', unitMethod[value]['domain']);
          global.apiInfo();
          // global.setString('appDomain', unitMethod[value]['domain']);
        });
        // Future.delayed(const Duration(milliseconds: 200)).then((e) {
        //   global.apiInfo();
        // });
      }
    });
  }
}
