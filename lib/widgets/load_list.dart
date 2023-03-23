import 'package:flutter/material.dart';
import 'package:fire_control_app/states/unit_model.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:fire_control_app/widgets/keep_alive.dart';

class LoadList extends StatefulWidget {
  const LoadList(
      {super.key,
      required this.setTtem,
      required this.header,
      this.param,
      this.api,
      this.precedent});
  final Function setTtem;
  final Function header;
  final dynamic param;
  final dynamic api;
  final dynamic precedent;
  @override
  State<LoadList> createState() => _LoadListState();
}

class _LoadListState extends State<LoadList> {
  final List<dynamic> _recordList = [];
  late dynamic record;
  late dynamic _recordParam;

  final ScrollController _listController = ScrollController();
  late bool isToTop = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Column(
          children: [
            record != null ? widget.header(record) : widget.header({}),
            Expanded(
                child: Container(
              child: deviceList(),
            ))
          ],
        ),
        Positioned(
            bottom: 18.0,
            right: 0,
            child: AnimatedOpacity(
              // If the widget is visible, animate to 0.0 (invisible).
              // If the widget is hidden, animate to 1.0 (fully visible).
              opacity: isToTop ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 500),
              // The green box must be a child of the AnimatedOpacity widget.
              child: FloatingActionButton(
                  mini: true,
                  heroTag: widget.key,
                  backgroundColor: const Color(0xff228CF5),
                  foregroundColor: const Color(0xffFFFFFF),
                  onPressed: () {
                    //返回到顶部时执行动画
                    _listController.animateTo(
                      .0,
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.ease,
                    );
                  },
                  child: const Icon(Icons.arrow_upward)),
            ))
      ],
    );
  }

  final RefreshController _controller =
      RefreshController(initialRefresh: false);
  _onLoading() {
    _loadData();
  }

  _onRefresh() {
    _recordParam.currentPage = 1;
    _loadData(isRefresh: true);
  }

  _loadData({bool isRefresh = false}) async {
    var value = await widget.api(_recordParam);
    setState(() {
      record = value;
      if (isRefresh) {
        _recordList.clear();
        _controller.refreshCompleted(resetFooterState: true);
      }
      _recordList.addAll(value.result);
      if (_recordParam.currentPage >= value.totalPage) {
        _controller.loadNoData();
      } else {
        if (!isRefresh) {
          _controller.loadComplete();
        }
      }
      _recordParam.currentPage++;
    });
  }

  deviceList() {
    return KeepAliveWrapper(
        child: Consumer<UnitModel>(builder: (context, UnitModel unitModel, _) {
      if (unitModel.unit != null) {
        if (_recordParam.unitId != unitModel.unit?.unitId) {
          _recordParam.unitId = unitModel.unit?.unitId;
          _recordParam.currentPage = 1;
          print('更新数据');
          _loadData(isRefresh: true);
          _listController.animateTo(
            .0,
            duration: const Duration(milliseconds: 10),
            curve: Curves.ease,
          );
        }
      }
      return SmartRefresher(
        controller: _controller,
        enablePullUp: true,
        onLoading: _onLoading,
        onRefresh: _onRefresh,
        child: ListView.builder(
          reverse: false,
          controller: _listController,
          itemBuilder: (c, i) => widget.setTtem(_recordList[i]),
          shrinkWrap: true,
          itemCount: _recordList.length,
        ),
      );
    }));
  }

  @override
  void initState() {
    super.initState();
    _recordParam = widget.param;
    record = widget.precedent;
    _loadData();
    // widget.itemParam
    _listController.addListener(() {
      // 为控制器注册滚动监听方法
      if (_listController.offset > 1000) {
        // 如果 ListView 已经向下滚动了 1000，则开启 Top 按钮
        setState(() {
          isToTop = true;
        });
      } else if (_listController.offset < 300) {
        // 如果 ListView 向下滚动距离不足 300，则禁用
        setState(() {
          isToTop = false;
        });
      }
      // print(_listController.offset);
    });
    // 监听父级改变
    _recordParam.addListener(() {
      print('更新数据');
      _onRefresh();
      _listController.animateTo(
        .0,
        duration: const Duration(milliseconds: 10),
        curve: Curves.ease,
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _listController.dispose();
    _recordParam.dispose(); //移除监听
    super.dispose();
  }
}
