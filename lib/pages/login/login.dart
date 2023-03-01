import 'package:flutter/material.dart';
import 'package:fire_control_app/http/login_api.dart';
import './login_from.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final LoginService loginApi = LoginService();

  late List<dynamic> unitMethod = [];
  late String unitText = '';

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
                  const Padding(
                    padding: EdgeInsets.only(top: 10, bottom: 10),
                    child: Text(
                      '欢迎登录',
                      style: TextStyle(
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
                        children: const [
                          LoginFrom(),
                        ],
                      )),
                ]))));
  }
}
