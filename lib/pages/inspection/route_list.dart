import 'package:fire_control_app/common/colors.dart';
import 'package:fire_control_app/common/fcm_icon.dart';
import 'package:fire_control_app/http/inspection_api.dart';
import 'package:fire_control_app/models/inspection.dart';
import 'package:fire_control_app/widgets/button_group.dart';
import 'package:fire_control_app/widgets/filter_dialog.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class RouteList extends StatefulWidget {
  const RouteList({super.key});

  @override
  State<StatefulWidget> createState() => _RouteListState();
}

class _RouteListState extends State<RouteList> {
  final List<InspectionRoute> _items = [];

  int _total = 0;

  final RouteParam _param = RouteParam();

  final RefreshController _controller = RefreshController(initialRefresh: true);

  @override
  Widget build(BuildContext context) {
    print("create route list");
    return Scaffold(
      endDrawer: Drawer(
        child: Text("abc"),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(10),
            child: Row(
              children: [
                ButtonGroup(
                  names: ['可领取', '已领取'],
                  onTap: (index) {
                    if (index == 1) {
                      _param.status = 2;
                    } else {
                      _param.status = 1;
                    }
                    _onRefresh();
                  },
                ),
                Expanded(flex: 1, child: Container()),
                Text("共$_total条"),
                TextButton.icon(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (ctx) => FilterDialog(
                                body: Text(
                                    "dkjfalkdjfkaldsjfkdlsajjjjjjjjjfklsdfjllaskfj\njjjjjjjjjjjjjjj"),
                              ));
                    },
                    icon: Icon(
                      FcmIcon.alarm,
                      size: 20,
                    ),
                    label: Text("筛选"))
              ],
            ),
          ),
          Expanded(
              child: SmartRefresher(
            controller: _controller,
            enablePullUp: true,
            onLoading: _onLoading,
            onRefresh: _onRefresh,
            child: ListView.builder(
              itemBuilder: (c, i) => _RouteItem(route: _items[i]),
              shrinkWrap: true,
              itemCount: _items.length,
            ),
          ))
        ],
      ),
    );
  }

  void _onLoading() async {
    _loadData();
  }

  void _onRefresh() async {
    _param.currentPage = 1;
    _loadData(isRefresh: true);
  }

  void _loadData({bool isRefresh = false}) {
    InspectionApi.getInspectionList(_param).then((value) {
      if (isRefresh) {
        _items.clear();
        _controller.refreshCompleted(resetFooterState: true);
      }
      _items.addAll(value.result);
      _total = value.totalRow;
      if (_param.currentPage >= value.totalPage) {
        _controller.loadNoData();
      } else {
        if (!isRefresh) {
          _controller.loadComplete();
        }
      }
      _param.currentPage++;
      setState(() {});
    });
  }
}

class _RouteItem extends StatelessWidget {
  final InspectionRoute route;

  const _RouteItem({required this.route});

  @override
  Widget build(BuildContext context) {
    return Card(
        child: Padding(
            padding: EdgeInsets.all(10),
            child: Column(children: [
              Row(children: [
                Container(
                    width: 3,
                    height: 20,
                    color: FireControlColor.baseColor,
                    margin: EdgeInsets.fromLTRB(0, 0, 10, 0)),
                Expanded(
                  child: Text(route.name),
                  flex: 1,
                ),
                OutlinedButton(onPressed: () {}, child: Text("可领取"))
              ]),
              Divider(),
              SingleItem(name: "单位名称", content: Text(route.unitName)),
              Row(children: [
                Expanded(
                  child:
                      SingleItem(name: "巡检类型", content: Text(route.type.desc)),
                  flex: 1,
                ),
                Expanded(
                  child: SingleItem(
                      name: "巡检限时",
                      content: Text(
                          "${route.limitedTime != null ? '${route.limitedTime}分钟' : '无'}")),
                  flex: 1,
                ),
              ]),
              Row(children: [
                Expanded(
                  child:
                      SingleItem(name: "巡检方式", content: Text(route.way.desc)),
                  flex: 1,
                ),
                Expanded(
                  child: SingleItem(
                      name: "节点数量", content: Text(route.nodeCount.toString())),
                  flex: 1,
                ),
              ]),
              Padding(
                padding: EdgeInsets.only(top: 8),
                child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.grey),
                    clipBehavior: Clip.hardEdge,
                    height: 30,
                    child: Row(children: [
                      Expanded(
                          child: Container(
                              color: Colors.white10,
                              child: Center(child: Text("今日概况"))),
                          flex: 1),
                      Expanded(child: Center(child: Text("额定")), flex: 1),
                      Expanded(child: Center(child: Text("额定")), flex: 1),
                      Expanded(child: Center(child: Text("额定")), flex: 1)
                    ])),
              )
            ])));
  }
}

class SingleItem extends StatelessWidget {
  String name;
  Widget? content;

  SingleItem({super.key, required this.name, this.content});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 3),
      child: Row(children: [
        Text(
          name,
          style: TextStyle(color: Colors.grey),
        ),
        Expanded(
          child: Padding(padding: EdgeInsets.only(left: 10), child: content),
          flex: 1,
        )
      ]),
    );
  }
}
