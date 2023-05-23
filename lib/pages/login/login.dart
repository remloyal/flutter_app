import 'package:fire_control_app/http/login_api.dart';
import 'package:fire_control_app/models/account.dart';
import 'package:fire_control_app/widgets/fc_details.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import './login_from.dart';
import './reg_from.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  late String name = 'login';

  change(String type) {
    setState(() {
      if (type == 'login') {
        name = type;
      } else {
        name = type;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // resizeToAvoidBottomInset: false,
        body: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            padding: const EdgeInsets.only(top: 60, left: 20, right: 20),
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 255, 0, 0),
              image: DecorationImage(
                fit: BoxFit.cover,
                image: ExactAssetImage('assets/images/bg-login.png'),
              ),
            ),
            child: SingleChildScrollView(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    // verticalDirection:,
                    // mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Image(
                        image: AssetImage("assets/images/logo1.png"),
                        width: 100,
                      )
                    ],
                  ),
                  const Text(
                    '智慧消防系统',
                    // maxLines: 100,
                    style: TextStyle(
                        fontSize: 28,
                        color: Color.fromARGB(255, 255, 255, 255)),
                  ),
                  const Text(
                    '移动版',
                    style: TextStyle(
                        fontSize: 22,
                        color: Color.fromARGB(255, 255, 255, 255)),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10, bottom: 10),
                    child: Text(
                      name == 'login' ? '欢迎登录' : '用户注册',
                      style: const TextStyle(
                          fontSize: 30,
                          color: Color.fromARGB(255, 255, 255, 255)),
                    ),
                  ),
                  Container(
                      width: 350,
                      padding: const EdgeInsets.all(20),
                      decoration: const BoxDecoration(
                        color: Color.fromARGB(255, 255, 255, 255),
                        borderRadius: BorderRadius.all(Radius.circular(25.0)),
                      ),
                      child: Column(
                        children: [
                          AnimatedSwitcher(
                              duration: const Duration(milliseconds: 1000),
                              child: name == 'login'
                                  ? LoginFrom(
                                      change: change,
                                    )
                                  : RegFrom(
                                      change: change,
                                    )),
                        ],
                      )),
                ]))));
  }
}

class LoginScanPage extends StatefulWidget {
  static const routeName = '/loginScan';

  final String url;

  const LoginScanPage({super.key, required this.url});

  @override
  State<StatefulWidget> createState() => _LoginScanPageState();
}

class _LoginScanPageState extends State<LoginScanPage> {

  late LoginScanParam _param;

  @override
  void initState() {
    super.initState();
    _param = LoginScanParam(widget.url);
    _login(isBack: false);
  }

  void _login({bool isBack = true, bool? result}) {
    LoginApi.scan(_param).then((value) {
      if (value.errorCode != 0) {
        showCupertinoDialog(
            context: context,
            builder: (BuildContext context) {
              return CupertinoAlertDialog(
                title: const Text('提示'),
                content: Text(value.message!),
                actions: [
                  TextButton(
                    child: const Text('确认'),
                    onPressed: () {
                      Navigator.of(context)..pop()..pop();
                    },
                  )
                ],
              );
            });
      } else {
        if (isBack) {
          Navigator.pop(context, result);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width * 0.5;
    double space = width * 0.5;
    return FcDetailPage(
      roll: false,
      title: '授权登录',
      body: [
        Center(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 40),
                child: Image.asset(
                  'assets/images/diannao.png',
                  width: width,
                  height: width,
                ),
              ),
              const Text(
                '浏览器消防系统登陆确认',
                style: TextStyle(fontSize: 18),
              )
            ],
          ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(bottom: 100, left: space, right: space),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                HandleButton(
                  onPressed: () {
                    _param.scanStatus = 3;
                    _login(result: true);
                  },
                  title: '确认登陆',
                ),
                const SizedBox(height: 8,),
                FcTextButton(
                  onPressed: () {
                    _param.scanStatus = 4;
                    _login();
                  },
                  text: '取消登陆',
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}