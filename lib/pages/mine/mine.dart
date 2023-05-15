import 'package:fire_control_app/common/fc_color.dart';
import 'package:flutter/material.dart';
import 'package:fire_control_app/http/login_api.dart';
import 'package:fire_control_app/http/mine_api.dart';
import 'package:fire_control_app/models/mine_entity.dart';
import 'package:fire_control_app/common/global.dart';

class Mine extends StatefulWidget {
  const Mine({super.key});

  @override
  State<Mine> createState() => _MineState();
}

class _MineState extends State<Mine> {
  late Info info = Info(
      unitName: '',
      nickName: '',
      cellPhone: '',
      roleName: '',
      createTime: '',
      reviewTime: '',
      reviewer: '',
      headImgUrl: '',
      message: 0);

  @override
  void initState() {
    init();
    super.initState();
  }

  init() async {
    info = await MineApi.useMyInfo();
    print('$info');
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // padding: const EdgeInsets.all(8.0),
      height: 400,
      child: Column(
        children: [
          SizedBox(
            // padding: const EdgeInsets.all(8.0),
            height: 290,
            width: MediaQuery.of(context).size.width,
            child: Stack(
              alignment: Alignment.center, //指定未定位或部分定位widget的对齐方式
              children: <Widget>[
                // Text('data'),
                Positioned(
                    top: 0,
                    child: Container(
                        height: 150,
                        // width: 200,
                        width: MediaQuery.of(context).size.width,
                        color: FcColor.barMineColor,
                        child: Column(
                          children: [
                            Container(
                              width: 90,
                              height: 90,
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                    fit: BoxFit.cover,
                                    // image: ExactAssetImage('assets/images/ceshi.png'),
                                    image: NetworkImage(
                                        '${Global.profile.apiInfo.imgUrl}/${info.headImgUrl != "" ? info.headImgUrl : "/xf/api/user_img/user_default.jpg"}'),
                                  ),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(45))),
                            ),
                          ],
                        ))),
                Positioned(
                    top: 148.0,
                    child: Container(
                      height: 200,
                      width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.only(top: 28),
                      color: FcColor.cardColor,
                      child: operate(),
                    )),
                Positioned(
                    top: 110,
                    child: Container(
                        // height: 50,
                        width: MediaQuery.of(context).size.width - 30,
                        padding: const EdgeInsets.only(
                            top: 15, bottom: 15, left: 25, right: 25),
                        margin: const EdgeInsets.all(10),
                        // color: FireControlColor.cardColor,
                        decoration: const BoxDecoration(
                            color: FcColor.cardColor,
                            borderRadius: BorderRadius.all(Radius.circular(40)),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black12,
                                  offset: Offset(0.0, 1.0), //阴影xy轴偏移量
                                  blurRadius: 15.0, //阴影模糊程度
                                  spreadRadius: 1.0)
                            ]),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.max,
                          //交叉轴的布局方式，对于column来说就是水平方向的布局方式
                          crossAxisAlignment: CrossAxisAlignment.center,
                          //就是字child的垂直布局方向，向上还是向下
                          verticalDirection: VerticalDirection.down,
                          children: <Widget>[
                            Container(
                              padding: const EdgeInsets.only(right: 20),
                              decoration: const BoxDecoration(
                                border: Border(
                                  right: BorderSide(
                                    width: 0.5, //宽度
                                    color: Color.fromARGB(
                                        255, 209, 209, 209), //边框颜色
                                  ),
                                ),
                              ),
                              child: Text(info.roleName),
                            ),
                            Text(
                              info.nickName,
                              textAlign: TextAlign.center,
                            ),
                            Container(
                              padding: const EdgeInsets.only(left: 20),
                              decoration: const BoxDecoration(
                                border: Border(
                                  left: BorderSide(
                                    width: 0.5, //宽度
                                    color: Color.fromARGB(
                                        255, 209, 209, 209), //边框颜色
                                  ),
                                ),
                              ),
                              child: Text(info.cellPhone),
                            ),
                          ],
                        ))),
              ],
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            margin: const EdgeInsets.only(top: 10),
            padding: const EdgeInsets.all(10),
            color: FcColor.cardColor,
            child: news(),
          ),
          SingleChildScrollView(
            child: Container(
              width: MediaQuery.of(context).size.width,
              // margin: EdgeInsets.only(top: 10),
              padding: const EdgeInsets.only(left: 10, right: 10),
              color: FcColor.cardColor,
              child: mineItem(),
            ),
          ),
        ],
      ),
    );
  }

  onTop() {
    print('object');
  }

  operate() {
    List<Map> listItem = [
      {
        'text': '工作日志',
        "color": const Color(0xffA2AEB5),
        "bgColor": const Color(0xffECEFF1),
        'onTap': () {
          Navigator.pushNamed(context, '/mainWorkMain',
              arguments: {"name": null, "id": null});
        },
        "iconData": const IconData(0xe606, fontFamily: 'fcm'),
      },
      {
        'text': '通讯录',
        "color": const Color(0xffA2AEB5),
        "bgColor": const Color(0xffECEFF1),
        'onTap': () {
          Navigator.pushNamed(
            context,
            '/mineMail',
          );
        },
        "iconData": const IconData(0xe7de, fontFamily: 'fcm'),
      },
      {
        'text': '系统设置',
        "color": const Color(0xffA2AEB5),
        "bgColor": const Color(0xffECEFF1),
        'onTap': () {
          Navigator.pushNamed(
            context,
            '/mineSystemSetting',
          );
        },
        "iconData": const IconData(0xe62a, fontFamily: 'fcm'),
      },
      {
        'text': '退出登录',
        "color": const Color(0xffFF0000),
        "bgColor": const Color(0xffFFCDD2),
        'onTap': () {
          LoginService.clearInfo();
        },
        "iconData": const IconData(0xe634, fontFamily: 'fcm'),
      }
    ];
    return Container(
        color: FcColor.cardColor,
        padding: const EdgeInsets.all(10),
        child: Flex(
            direction: Axis.horizontal,
            children: listItem.map((data) {
              return Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: data['onTap'],
                        child: Container(
                          width: 60,
                          height: 60,
                          margin: const EdgeInsets.only(bottom: 6),
                          decoration: BoxDecoration(
                              color: data['bgColor'],
                              // border:
                              //     Border(left: BorderSide(width: 1, color: Colors.red)),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(30))),
                          child: Icon(
                            data['iconData'],
                            color: data['color'],
                            size: 30,
                          ),
                        ),
                      ),
                      Text(
                        data['text'],
                        style: const TextStyle(fontSize: 14),
                      )
                    ],
                  ));
            }).toList()));
  }

  news() {
    return Flex(
      direction: Axis.horizontal,
      children: <Widget>[
        Expanded(
            flex: 1,
            child: InkWell(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  '/mineNews',
                );
              },
              child: Container(
                padding: const EdgeInsets.only(right: 10),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  // padding: const EdgeInsets.only(left: 10, right: 10),
                  color: const Color(0xffECEFF1),
                  child: Row(children: const [
                    Icon(
                      IconData(0xe8AE, fontFamily: 'fcm'),
                      color: Color(0xffA2AEB5),
                      size: 30,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 20),
                      child: Text(
                        '新闻资讯',
                        style: TextStyle(fontSize: 16),
                      ),
                    )
                  ]),
                ),
              ),
            )),
        Expanded(
            flex: 1,
            child: InkWell(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  '/mineHelp',
                );
              },
              child: Container(
                padding: const EdgeInsets.only(right: 10),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  // padding: const EdgeInsets.only(left: 10, right: 10),
                  color: const Color(0xffECEFF1),
                  child: Row(children: const [
                    Icon(
                      IconData(0xe65f, fontFamily: 'fcm'),
                      color: Color(0xffA2AEB5),
                      size: 30,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 20),
                      child: Text(
                        '帮助中心',
                        style: TextStyle(fontSize: 16),
                      ),
                    )
                  ]),
                ),
              ),
            )),
      ],
    );
  }

  mineItem() {
    return Column(
      children: [
        InkWell(
          onTap: () {
            print('object');
          },
          child: Container(
            padding: const EdgeInsets.only(top: 10, bottom: 16),
            margin: const EdgeInsets.only(left: 10, right: 10),
            decoration: const BoxDecoration(
                border: Border(
                    bottom: BorderSide(
              width: 0.5, //宽度
              color: Color.fromARGB(255, 207, 207, 207), //边框颜色
            ))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text('个人资料'),
                Icon(
                  IconData(0xe633, fontFamily: 'fcm'),
                  color: Color(0xffA2AEB5),
                  size: 18,
                )
              ],
            ),
          ),
        ),
        InkWell(
          onTap: () {
            print('object');
          },
          child: Container(
            padding: const EdgeInsets.only(top: 10, bottom: 16),
            margin: const EdgeInsets.only(left: 10, right: 10),
            decoration: const BoxDecoration(
                border: Border(
                    bottom: BorderSide(
              width: 0.5, //宽度
              color: Color.fromARGB(255, 207, 207, 207), //边框颜色
            ))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('检查更新'),
                Row(children: const [
                  Text('1.0.0'),
                  Icon(
                    IconData(0xe633, fontFamily: 'fcm'),
                    color: Color(0xffA2AEB5),
                    size: 18,
                  )
                ]),
              ],
            ),
          ),
        ),
        InkWell(
          onTap: () {
            print('object');
            Navigator.pushNamed(
              context,
              '/minePrivacy',
            );
          },
          child: Container(
            padding: const EdgeInsets.only(top: 10, bottom: 16),
            margin: const EdgeInsets.only(left: 10, right: 10),
            decoration: const BoxDecoration(
                border: Border(
                    bottom: BorderSide(
              width: 0.5, //宽度
              color: Color.fromARGB(255, 207, 207, 207), //边框颜色
            ))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text('协议政策'),
                Icon(
                  IconData(0xe633, fontFamily: 'fcm'),
                  color: Color(0xffA2AEB5),
                  size: 18,
                )
              ],
            ),
          ),
        ),
        InkWell(
          onTap: () {
            Navigator.pushNamed(
              context,
              '/mineAbout',
            );
          },
          child: Container(
            padding: const EdgeInsets.only(top: 10, bottom: 16),
            margin: const EdgeInsets.only(left: 10, right: 10),
            decoration: const BoxDecoration(
                border: Border(
                    bottom: BorderSide(
              width: 0.5, //宽度
              color: Color.fromARGB(255, 207, 207, 207), //边框颜色
            ))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text('关于我们'),
                Icon(
                  IconData(0xe633, fontFamily: 'fcm'),
                  color: Color(0xffA2AEB5),
                  size: 18,
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
