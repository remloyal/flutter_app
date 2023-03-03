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
        body: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            padding: const EdgeInsets.only(top: 60),
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    // verticalDirection:,
                    // mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: const <Widget>[
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
