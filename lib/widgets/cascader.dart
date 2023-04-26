// 级联选择
import 'package:flutter/material.dart';

const String _titleText = '请选择地区';
const String _tabText = '请选择';
const double _headerHeight = 40.0;
const double _itemHeight = 50.0;
const double _titleFontSize = 14.0;
const String _customField = 'text';

class Cascader extends StatefulWidget {
  const Cascader({
    super.key,
    this.title = _titleText,
    this.tabText = _tabText,
    this.clickCallBack,
    required this.asyncCallBack,
    required this.options,
    required this.onClose,
    this.customField = _customField,
  });

  final String title;
  final String? tabText;
  final Function(dynamic selectValue)? clickCallBack;
  // 多维数组
  final List options;

  // 异步加载函数
  final Function(dynamic, dynamic, dynamic) asyncCallBack;

  // 关闭
  final Function onClose;

  // 自定义显示字段
  final String? customField;

  @override
  State<Cascader> createState() => _CascaderState();
}

class _CascaderState extends State<Cascader> with TickerProviderStateMixin {
  TabController? _tabController;

  // TabBar 数组
  final List<Tab> _myTabs = <Tab>[];

  // 当前列表数据
  final List<List> _mList = [];

  // 多级联动选择的position
  final List<int> _positions = [];
  // 控制器组
  final List<ScrollController> _scrollList = [];

  // 索引
  final List<int> _itemIndex = [];

  int _index = 0;

  // 数据合集
  final List dataCollection = [];

  @override
  void initState() {
    super.initState();
    _initData();
  }

  _initScrollList(int index) {
    var scrollController = ScrollController();
    return scrollController;
  }

  void _initData() {
    _myTabs.add(Tab(text: widget.tabText));
    _mList.add(widget.options);
    _itemIndex.add(0);
    _positions.add(0);
    _scrollList.add(_initScrollList(0));
    _tabController = TabController(length: _myTabs.length, vsync: this);
  }

  void _setIndex(int index) {
    _index = index;
  }

  void _indexIncrement() {
    _index++;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
        child: Column(
          children: [
            Container(
              height: _headerHeight,
              color: Colors.white,
              alignment: Alignment.center,
              child: Text(widget.title,
                  style: const TextStyle(
                      fontSize: _titleFontSize,
                      color: Color(0xFF787878),
                      decoration: TextDecoration.none)),
            ),
            const Divider(
              indent: 0.0,
              color: Color.fromARGB(255, 190, 190, 190),
            ),
            Expanded(
              child: Column(children: [
                Expanded(
                  child: Scaffold(
                    appBar: TabBar(
                      tabs: _myTabs,
                      controller: _tabController,
                      isScrollable: true,
                      indicatorSize: TabBarIndicatorSize.label,
                      labelColor: const Color(0xFF409DFB),
                      unselectedLabelColor: const Color(0xFF333333),
                      indicatorColor: const Color(0xFF409DFB),
                      onTap: (index) {
                        if (index == _index) return;
                        setState(() {
                          _setIndex(index);
                        });
                        _tabController?.animateTo(_index);
                        int scrollTop = _positions[_index];
                        Future.delayed(const Duration(milliseconds: 100))
                            .then((e) {
                          _scrollList[_index].animateTo(
                            scrollTop.toDouble(),
                            duration: const Duration(milliseconds: 1),
                            curve: Curves.ease,
                          );
                        });
                      },
                    ),
                    body: _tabBarView(),
                  ),
                ),
              ]),
            )
          ],
        ));
  }

  TabBarView _tabBarView() {
    return TabBarView(controller: _tabController, children: _tabViews());
  }

  List<Widget> _tabViews() {
    List<Widget> tabViewList = [];
    for (var i = 0; i < _myTabs.length; i++) {
      final List contents = _mList[i];
      tabViewList.add(
        ListView.builder(
          shrinkWrap: true,
          controller: _scrollList[i],
          itemExtent: _itemHeight,
          scrollDirection: Axis.vertical,
          itemBuilder: (_, index) {
            return _buildItem(contents[index], index, i);
          },
          itemCount: contents.length,
        ),
      );
    }
    return tabViewList;
  }

  Widget _buildItem(data, int itemIndex, int tabIndex) {
    return Container(
        height: 50,
        decoration: BoxDecoration(
            color: getBgColor(tabIndex, itemIndex),
            border: const Border(
                bottom: BorderSide(width: 1, color: Color(0xffe5e5e5)))),
        child: ListTile(
          title: Text(data[widget.customField]),
          trailing: getIcon(tabIndex, itemIndex),
          textColor: getColor(tabIndex, itemIndex),
          onTap: () async {
            // 获取新数据
            List datas = await widget.asyncCallBack(
                _mList[tabIndex][itemIndex], tabIndex, itemIndex);

            // print(_positions);
            _positions[tabIndex] = (itemIndex * _itemHeight).toInt();
            setIndex(tabIndex, itemIndex);
            _indexIncrement();
            if (datas.isEmpty) {
              _onClose();
              return;
            }
            _setListAndChangeTab(datas, tabIndex);
            setState(() {});
            _myTabs[tabIndex] = Tab(text: data[widget.customField]);
            _tabController?.animateTo(_index);
            // Future.delayed(const Duration(milliseconds: 200)).then((e) {
            //   _scrollList[tabIndex].animateTo(0.0,
            //       duration: const Duration(milliseconds: 1),
            //       curve: Curves.ease);
            // });
          },
        ));
  }

  /// 选项点击后设置下一级数据并改变tabBar
  void _setListAndChangeTab(datas, tabIndex) {
    // print(tabIndex);
    if ((tabIndex + 1) < _myTabs.length) {
      _mList[tabIndex + 1] = datas;
      _itemIndex[tabIndex + 1] = 0;
      _positions[tabIndex + 1] = 0;
      _myTabs[tabIndex + 1] = const Tab(text: '请选择');

      var deleteIndex = tabIndex;
      if (tabIndex == 0) {
        deleteIndex += 3;
      } else {
        deleteIndex += 2;
      }
      _itemIndex.removeRange(deleteIndex, _itemIndex.length);
      _positions.removeRange(deleteIndex, _positions.length);
      _myTabs.removeRange(tabIndex + 2, _myTabs.length);
      _scrollList.removeRange(deleteIndex, _scrollList.length);
      _tabController = TabController(
          length: _myTabs.length, vsync: this, initialIndex: _index);
    } else {
      _mList.add(datas);
      _myTabs.add(const Tab(text: '请选择'));
      _itemIndex.add(0);
      _positions.add(0);
      _scrollList.add(_initScrollList(_positions.length - 1));
      _tabController = TabController(
          length: _myTabs.length, vsync: this, initialIndex: _index);
    }
  }

  _onClose() {
    List data = [];
    for (var i = 0; i < _mList.length; i++) {
      var index = _itemIndex[i];
      data.add(_mList[i][index]);
    }
    widget.onClose(data);
  }

  setIndex(tabIndex, itemIndex) {
    if (_itemIndex.isEmpty) {
      _itemIndex.add(itemIndex);
    }
    if (_itemIndex.length >= tabIndex) {
      _itemIndex[tabIndex] = itemIndex;
    } else {
      _itemIndex.add(itemIndex);
    }
  }

  getBgColor(tabIndex, itemIndex) {
    if (_itemIndex.isEmpty) {
      return const Color.fromARGB(255, 247, 247, 247);
    }
    var color;
    if (_itemIndex.length >= tabIndex) {
      color = _itemIndex[tabIndex] == itemIndex
          ? const Color.fromARGB(255, 235, 235, 235)
          : const Color.fromARGB(255, 247, 247, 247);
    } else {
      color = const Color.fromARGB(255, 247, 247, 247);
    }
    return color;
  }

  getColor(tabIndex, itemIndex) {
    if (_itemIndex.isEmpty) {
      return const Color.fromARGB(255, 0, 0, 0);
    }
    var color = _itemIndex[tabIndex] == itemIndex
        ? const Color(0xFF409DFB)
        : const Color.fromARGB(255, 0, 0, 0);
    return color;
  }

  getIcon(tabIndex, itemIndex) {
    double size = 12;
    if (_itemIndex.isEmpty) {
      size = 0;
    } else {
      size = _itemIndex[tabIndex] == itemIndex ? 24 : 0;
    }
    return Icon(
      Icons.check,
      color: getColor(tabIndex, itemIndex),
      size: size,
    );
  }
}
