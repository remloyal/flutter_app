import 'package:fire_control_app/models/unit.dart';
import 'package:fire_control_app/states/unit_model.dart';
import 'package:flutter/material.dart';
import 'package:fire_control_app/common/global.dart';
import 'package:provider/provider.dart';

class UnitSelect<T> extends StatefulWidget {
  const UnitSelect({super.key, this.type = 'unit', this.param});
  final String? type;
  final Function(Unit)? param;

  @override
  State<StatefulWidget> createState() => _UnitSelectState();
}

class _UnitSelectState extends State<UnitSelect> {
  final TextEditingController _search = TextEditingController();
  // 搜索值
  late String searchValue = '';
  final List<Unit> unit = Global.units;
  // 渲染列表
  final List<Unit> showList = [];

  late Unit? unitMine;
  @override
  void initState() {
    super.initState();
    showList.addAll(unit);
    for (var element in unit) {
      if (element.unitId == Global.profile.apiInfo.user['unitId']) {
        unitMine = element;
      }
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: const Text("选择单位"),
        ),
        body: Consumer<UnitModel>(
          builder: (context, UnitModel unitModel, _) => Column(
            children: [
              Container(
                  width: MediaQuery.of(context).size.width,
                  height: 70,
                  padding: const EdgeInsets.only(top: 16, bottom: 16, left: 10, right: 10),
                  color: Color(0xFFF5F5F5),
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
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(24)),
                      hintText: '请输入搜索关键词',
                      hintStyle: const TextStyle(fontSize: 15, color: Color(0xffAEAEAE)),
                    ),
                    onChanged: (value) {
                      searchValue = value;
                      searchItem();
                      // _reloadTextSetter(() {
                      //   _alarmParam.keyword = value;
                      // });
                    },
                  )),
              Container(
                  color: const Color(0xFFF5F5F5),
                  child: Flex(
                    direction: Axis.horizontal,
                    children: [
                      Expanded(
                        flex: 1,
                        child: InkWell(
                          onTap: () {
                            if (widget.type == 'unit' || widget.type == null) {
                              unitModel.unit = null;
                            } else {
                              widget.param!(unitMine!);
                            }
                            Navigator.of(context).pop();
                          },
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            margin: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                color: const Color(0xffE3F2FD),
                                border: Border.all(width: 1, color: Colors.blue),
                                borderRadius: const BorderRadius.all(Radius.circular(20))),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '全部单位',
                                  style: TextStyle(
                                    color: Color(0xff4A94DC),
                                  ),
                                ),
                                Icon(
                                  Icons.arrow_forward_ios,
                                  color: Color(0xff4A94DC),
                                  size: 20,
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                          flex: 1,
                          child: InkWell(
                            onTap: () {
                              if (widget.type == 'unit' || widget.type == null) {
                                unitModel.unit = unitMine;
                              } else {
                                widget.param!(unitMine!);
                              }
                              Navigator.of(context).pop();
                            },
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              margin: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  color: const Color(0xffE3F2FD),
                                  border: Border.all(width: 1, color: Colors.blue),
                                  borderRadius: const BorderRadius.all(Radius.circular(20))),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    constraints: const BoxConstraints(maxWidth: 130),
                                    child: Text(
                                      unitMine!.name,
                                      // softWrap: true,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        color: Color(0xff4A94DC),
                                      ),
                                    ),
                                  ),
                                  const Icon(
                                    Icons.arrow_forward_ios,
                                    color: Color(0xff4A94DC),
                                    size: 20,
                                  )
                                ],
                              ),
                            ),
                          )),
                    ],
                  )),
              Expanded(
                  flex: 1,
                  child: Scrollbar(
                      child: showList.isNotEmpty
                          ? ListView.builder(
                              // separatorBuilder:
                              //     (BuildContext context, int index) =>
                              //         const Divider(color: Colors.black),
                              itemCount: showList.length,
                              itemBuilder: (BuildContext context, int index) => Container(
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      border: Border(bottom: BorderSide(width: 1, color: Color.fromARGB(255, 197, 197, 197))),
                                    ),
                                    child: ListTile(
                                      title: Text(showList[index].name),
                                      trailing: const Icon(Icons.arrow_forward_ios),
                                      onTap: () {
                                        if (widget.type == 'unit' || widget.type == null) {
                                          unitModel.unit = Global.units[index];
                                        } else {
                                          widget.param!(Global.units[index]);
                                        }
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ))
                          : const Center(
                              child: Text('暂无数据'),
                            )))
            ],
          ),
        ));
  }

  // 筛选
  void searchItem() {
    showList.clear();
    if (searchValue == '') {
      showList.addAll(unit);
      setState(() {});
      return;
    }
    for (var i = 0; i < unit.length; i++) {
      if (unit[i].name.contains(searchValue)) {
        showList.add(unit[i]);
      }
    }
    setState(() {});
  }
}
