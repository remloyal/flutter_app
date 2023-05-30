import 'package:fire_control_app/http/http.dart';
import 'package:fire_control_app/models/param.dart';
import 'package:fire_control_app/models/response.dart';
import 'package:flutter/material.dart';
import 'package:fire_control_app/states/unit_model.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:fire_control_app/widgets/keep_alive.dart';

// 创建列表的item
typedef ItemBuilder<T> = Widget Function(BuildContext context, T item, int index);

// 创建过滤的工具栏
typedef ToolbarBuilder = Widget Function(BuildContext context, int total);

class LoadList<T extends ListApi, P extends Param, I> extends StatefulWidget {
  const LoadList({
    super.key,
    required this.api,
    required this.param,
    required this.itemBuilder,
    this.toolbarBuilder
  });

  //获取数据接口类
  final T api;
  //获取数据的参数
  final P param;

  final ItemBuilder<I> itemBuilder;

  final ToolbarBuilder? toolbarBuilder;

  Widget _itemBuilder(BuildContext context, dynamic item, int index) {
    return itemBuilder(context, item as I, index);
  }

  @override
  State<LoadList> createState() => _LoadListState();
}

class _LoadListState extends State<LoadList> {
  final List _records = [];
  int _total = 0;

  final ScrollController _listController = ScrollController();

  final RefreshController _controller =
      RefreshController(initialRefresh: false);

  late bool _isToTop = false;

  @override
  void initState() {
    super.initState();
    _loadData();
    _listController.addListener(() {
      // 为控制器注册滚动监听方法
      if (_listController.offset > 1000) {
        // 如果 ListView 已经向下滚动了 1000，则开启 Top 按钮
        setState(() {
          _isToTop = true;
        });
      } else if (_listController.offset < 300) {
        // 如果 ListView 向下滚动距离不足 300，则禁用
        setState(() {
          _isToTop = false;
        });
      }
      // print(_listController.offset);
    });
    // 监听父级改变
    widget.param.addListener(() {
      _moveToTop(10);
      _onRefresh();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Column(
          children: [
            if (widget.toolbarBuilder != null)
              widget.toolbarBuilder!(context, _total),
            Expanded(child: Container(child: _buildList()))
          ],
        ),
        Positioned(
            bottom: 18.0,
            right: 0,
            child: AnimatedOpacity(
              // If the widget is visible, animate to 0.0 (invisible).
              // If the widget is hidden, animate to 1.0 (fully visible).
              opacity: _isToTop ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 500),
              // The green box must be a child of the AnimatedOpacity widget.
              child: FloatingActionButton(
                  mini: true,
                  heroTag: widget.key,
                  backgroundColor: const Color(0xff228CF5),
                  foregroundColor: const Color(0xffFFFFFF),
                  onPressed: () {
                    //返回到顶部时执行动画
                    _moveToTop(200);
                  },
                  child: const Icon(Icons.arrow_upward)),
            ))
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _listController.dispose();
    widget.param.dispose(); //移除监听
    super.dispose();
  }

  _buildList() {
    return KeepAliveWrapper(
        child: Consumer<UnitModel>(builder: (context, UnitModel unitModel, _) {
      if (unitModel.unit != null) {
        if (widget.param.unitId != unitModel.unit!.unitId) {
          widget.param.unitId = unitModel.unit!.unitId;
          widget.param.currentPage = 1;

          _moveToTop(10);
          _loadData(isRefresh: true);
        }
      }
      return SmartRefresher(
        controller: _controller,
        enablePullUp: true,
        onLoading: _loadData,
        onRefresh: _onRefresh,
        child: ListView.builder(
          reverse: false,
          controller: _listController,
          itemBuilder: (c, i) => widget._itemBuilder(context, _records[i], i),
          shrinkWrap: true,
          itemCount: _records.length,
        ),
      );
    }));
  }

  _onRefresh() {
    widget.param.currentPage = 1;
    _loadData(isRefresh: true);
  }

  _loadData({bool isRefresh = false}) async {
    ListResponse response = await widget.api.loadList(widget.param);
    setState(() {
      _total = response.totalRow;
      if (isRefresh) {
        _records.clear();
        _controller.refreshCompleted(resetFooterState: true);
      }
      _records.addAll(response.records);
      if (widget.param.currentPage >= response.totalPage) {
        _controller.loadNoData();
      } else {
        if (!isRefresh) {
          _controller.loadComplete();
        }
      }
      widget.param.currentPage++;
    });
  }

  void _moveToTop(int duration) {
    _listController.animateTo(
      .0,
      duration: Duration(milliseconds: duration),
      curve: Curves.ease,
    );
  }
}
