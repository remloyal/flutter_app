import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fire_control_app/common/fc_color.dart';
import 'package:fire_control_app/http/mine_api.dart';
import 'package:fire_control_app/models/mine_entity.dart';
import 'package:fire_control_app/common/global.dart';

class MineMail extends StatefulWidget {
  const MineMail({super.key});

  @override
  State<MineMail> createState() => _MineMailState();
}

class _MineMailState extends State<MineMail> {
  final TextEditingController _search = TextEditingController();
  final ScrollController _listController = ScrollController();

  late List<MineMailItem> originalList = [];
  final List unrealList = [];
  final List indexList = [];

  double itemHeight = 70;
  double keyHeight = 30;

  // 滚动高度
  double rollHeight = 0.0;

  // 是否查看在线
  late bool isOnline = false;

  // 搜索值
  late String searchValue = '';

  @override
  void initState() {
    super.initState();
    _init();
    _listController.addListener(() {
      rollHeight = _listController.offset;
      throttle();
    });
  }

  void _init() async {
    originalList = await MineApi.useMailList();
    for (var i = 0; i < originalList.length; i++) {
      if (indexList.contains(originalList[i].group) == false) {
        indexList.add(originalList[i].group);
        unrealList.add(originalList[i].group);
      }
      unrealList.add(originalList[i]);
    }
    _initHeight();
    setState(() {});
  }

  // 计算索引滚动高度
  late Map rollingHeight = {};
  late List rollingList = [];
  late String itemKey = '';
  void _initHeight() {
    for (var i = 0; i < indexList.length; i++) {
      int lastIndex = unrealList.indexOf(indexList[i]);
      if (i == 0) {
        rollingHeight[indexList[i]] = 0.0;
      } else {
        int itemFund = lastIndex - i;
        rollingHeight[indexList[i]] =
            i * keyHeight + itemFund * itemHeight + itemFund * 10;
      }
    }
    rollingList = rollingHeight.values.toList();
    itemKey = indexList.isEmpty ? '' : indexList[0];
  }

  void catalogIndex() {
    List overtakeList = [];
    for (var i = 0; i < rollingList.length; i++) {
      if (rollHeight >= rollingList[i]) {
        overtakeList.add(rollingList[i]);
      }
    }

    String initkey = overtakeList.isEmpty
        ? indexList[0]
        : indexList[overtakeList.length - 1];
    if (initkey != itemKey) {
      itemKey = initkey;
      setState(() {});
    }
  }

  // timer
  late Timer? timer = null;
  void throttle() {
    if (timer != null) {
      return;
    }

    ///do something
    timer = Timer(
      const Duration(milliseconds: 200),
      () {
        catalogIndex();
        timer = null;
      },
    );
  }

  void showList() {
    isOnline = !isOnline;
    if (isOnline) {
      indexList.clear();
      unrealList.clear();
      for (var i = 0; i < originalList.length; i++) {
        if (originalList[i].online) {
          if (indexList.contains(originalList[i].group) == false) {
            indexList.add(originalList[i].group);
            unrealList.add(originalList[i].group);
          }
          unrealList.add(originalList[i]);
        }
      }
      setState(() {});
    } else {
      indexList.clear();
      unrealList.clear();
      for (var i = 0; i < originalList.length; i++) {
        if (indexList.contains(originalList[i].group) == false) {
          indexList.add(originalList[i].group);
          unrealList.add(originalList[i].group);
        }
        unrealList.add(originalList[i]);
      }
      setState(() {});
    }
    _initHeight();
  }

  void searchItem() {
    List<MineMailItem> data = [];
    for (var i = 0; i < originalList.length; i++) {
      if (originalList[i].nickName.contains(searchValue) ||
          (originalList[i].cellPhone).toString().contains(searchValue)) {
        data.add(originalList[i]);
      }
    }

    indexList.clear();
    unrealList.clear();
    for (var i = 0; i < data.length; i++) {
      if (indexList.contains(data[i].group) == false) {
        indexList.add(data[i].group);
        unrealList.add(data[i].group);
      }
      unrealList.add(data[i]);
    }

    if (searchValue == '') {
      indexList.clear();
      unrealList.clear();
      for (var i = 0; i < originalList.length; i++) {
        if (indexList.contains(originalList[i].group) == false) {
          indexList.add(originalList[i].group);
          unrealList.add(originalList[i].group);
        }
        unrealList.add(originalList[i]);
      }
    }

    _initHeight();
    setState(() {});
    Future.delayed(const Duration(milliseconds: 200)).then((e) {
      _moveToIndex(0.0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          titleSpacing: 0,
          elevation: 0.5,
          title: const Text(
            '通讯录',
            style: TextStyle(fontSize: 18),
          ),
          backgroundColor: FcColor.bodyTitleColor,
          actions: [
            Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: InkWell(
                  onTap: () {
                    showList();
                  },
                  child: Text(
                    isOnline ? '显示全部' : '查看在线',
                    style:
                        const TextStyle(fontSize: 12, color: Color(0xFF1976D2)),
                  ),
                ),
              ),
            )
          ],
        ),
        backgroundColor: FcColor.bodyColor,
        body: Stack(
          children: [
            Column(
              children: [
                Container(
                    width: MediaQuery.of(context).size.width,
                    height: 70,
                    padding: const EdgeInsets.only(
                        top: 16, bottom: 16, left: 10, right: 10),
                    color: Colors.white,
                    child: TextField(
                      controller: _search,
                      style: const TextStyle(fontSize: 12),
                      decoration: InputDecoration(
                        filled: true,
                        isCollapsed: true,
                        prefixIcon: const Icon(
                          Icons.search,
                          size: 20,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 8,
                        ),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(24)),
                        hintText: '请输入姓名或电话号码',
                        hintStyle: const TextStyle(
                            fontSize: 15, color: Color(0xffAEAEAE)),
                      ),
                      onChanged: (value) {
                        searchValue = value;
                        searchItem();
                        // _reloadTextSetter(() {
                        //   _alarmParam.keyword = value;
                        // });
                      },
                    )),
                Expanded(
                    child: unrealList.isEmpty
                        ? const Center(
                            child: Text('暂无数据'),
                          )
                        : ListView.builder(
                            shrinkWrap: true,
                            reverse: false,
                            itemCount: unrealList.length,
                            controller: _listController,
                            itemBuilder: (c, i) {
                              var data = unrealList[i];
                              if (data is String) {
                                return Container(
                                  height: keyHeight,
                                  margin: const EdgeInsets.only(left: 10),
                                  padding: const EdgeInsets.only(top: 10),
                                  child: Text(
                                    data,
                                    style: const TextStyle(
                                      fontSize: 18,
                                    ),
                                  ),
                                );
                              } else {
                                if (i == (unrealList.length - 1)) {
                                  return Container(
                                    margin: const EdgeInsets.only(bottom: 20),
                                    child: _setItem(data),
                                  );
                                } else {
                                  return _setItem(data);
                                }
                              }
                            }))
              ],
            ),
            Positioned(
                top: 150,
                right: 0,
                child: Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Column(
                    children: [
                      ...indexList.map((e) {
                        return InkWell(
                            onTap: () {
                              itemKey = e;
                              _moveToIndex(rollingHeight[e]);
                              setState(() {});
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(2),
                              child: Text(
                                e,
                                style: TextStyle(
                                    fontSize: 12,
                                    color: itemKey == e
                                        ? Colors.red
                                        : Colors.black),
                              ),
                            ));
                      })
                    ],
                  ),
                ))
          ],
        ));
  }

  Widget _setItem(data) {
    return Container(
      color: Colors.white,
      margin: const EdgeInsets.only(top: 10, left: 10, right: 10),
      padding: const EdgeInsets.all(10),
      height: itemHeight,
      child: Row(
        children: [
          Expanded(
              child: Row(
            children: [
              Stack(
                children: [
                  ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: Image.network(
                          Global.profile.apiInfo.imgUrl + data.headImgUrl,
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover)),
                  Positioned(
                      bottom: -2,
                      left: 9,
                      child: Container(
                        padding: const EdgeInsets.only(
                            left: 4, right: 4, top: 1, bottom: 1),
                        decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 235, 235, 235),
                            borderRadius: BorderRadius.circular(12)),
                        child: Text(
                          data.online ? '在线' : '离线',
                          style: TextStyle(
                              fontSize: 12,
                              color: data.online
                                  ? Colors.blue
                                  : const Color.fromARGB(255, 148, 148, 148)),
                        ),
                      ))
                ],
              ),
              const SizedBox(
                width: 6,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(data.nickName),
                      Container(
                        margin: const EdgeInsets.only(left: 10),
                        padding: const EdgeInsets.only(left: 6, right: 6),
                        decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 235, 235, 235),
                            borderRadius: BorderRadius.circular(12)),
                        child: Text(
                          data.roleName,
                          style: const TextStyle(fontSize: 12),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Text(
                    data.unitName,
                    style:
                        const TextStyle(fontSize: 12, color: Color(0xFFA7A7A7)),
                  )
                ],
              ),
            ],
          )),
          Align(
            alignment: Alignment.centerRight,
            child: Row(
              children: [
                InkWell(
                  onTap: () {
                    print('object1');
                  },
                  child: Container(
                    width: 30,
                    height: 30,
                    decoration: const BoxDecoration(
                        color: Color(0xFFECEFF1),
                        borderRadius: BorderRadius.all(Radius.circular(30))),
                    child: const Icon(
                      IconData(0xe600, fontFamily: 'fcm'),
                      size: 14,
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    print('object2');
                  },
                  child: Container(
                    width: 30,
                    height: 30,
                    margin: const EdgeInsets.only(right: 4, left: 10),
                    decoration: const BoxDecoration(
                        color: Color(0xFFECEFF1),
                        borderRadius: BorderRadius.all(Radius.circular(30))),
                    child: const Icon(
                      IconData(0xe606, fontFamily: 'fcm'),
                      size: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _moveToIndex(double index) {
    if (unrealList.isNotEmpty) {
      _listController.animateTo(
        index,
        duration: const Duration(milliseconds: 30),
        curve: Curves.ease,
      );
    }
  }
}
