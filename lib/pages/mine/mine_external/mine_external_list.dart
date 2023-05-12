import 'package:fire_control_app/http/mine_api.dart';
import 'package:fire_control_app/widgets/keep_alive.dart';
import 'package:flutter/material.dart';
import 'package:fire_control_app/models/mine_entity.dart';
import 'package:fire_control_app/widgets/card_father.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class MineLoadList extends StatefulWidget {
  const MineLoadList({super.key, required this.url, required this.type});
  final String url;
  final String type;
  @override
  State<MineLoadList> createState() => _MineLoadListState();
}

class _MineLoadListState extends State<MineLoadList> {
  late int totalPages = 0;
  late final List<MineExternalItem> _list = [];
  late int index = 0;
  late List urlList = [];

  late MineExternalList? _mineExternalList;
  final ScrollController _listController = ScrollController();
  final RefreshController _controller =
      RefreshController(initialRefresh: false);
  late bool _isToTop = false;
  @override
  void initState() {
    super.initState();
    _init();
    // _mineWorkCommon.init();

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
  }

  void _init() async {
    _mineExternalList = await MineApi.useMailExternalList(widget.url);
    _list.addAll(_mineExternalList!.articles);
    for (var i = 1; i <= _mineExternalList!.totalPages; i++) {
      if (i == 1) {
        urlList.add(widget.url);
      } else {
        urlList.add('${widget.url}index_$i.html');
      }
    }
    setState(() {});
  }

  void _loadData() async {
    index++;
    if (index < _mineExternalList!.totalPages) {
      final MineExternalList List =
          await MineApi.useMailExternalList(urlList[index]);
      _list.addAll(List.articles);
      _controller.loadComplete();
    } else {
      _controller.loadNoData();
    }
    setState(() {});
  }

  void _onRefresh() async {
    _mineExternalList = await MineApi.useMailExternalList(widget.url);
    setState(() {
      _list.clear();
      index = 0;
      _controller.refreshCompleted(resetFooterState: true);
      _list.addAll(_mineExternalList!.articles);
      _controller.refreshCompleted();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            // widget.listBuilder.buildToolbar(context, _total) ?? Container(),
            Expanded(child: _getList())
          ],
        ),
        Positioned(
          bottom: 18.0,
          right: 0,
          child: AnimatedOpacity(
            opacity: _isToTop ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 500),
            child: FloatingActionButton(
                mini: true,
                heroTag: widget.key,
                backgroundColor: const Color(0xff228CF5),
                foregroundColor: const Color(0xffFFFFFF),
                onPressed: () {
                  //返回到顶部时执行动画
                  if (_listController.offset < 2000) {
                    _moveToTop(200);
                  } else {
                    _moveToTop(30);
                  }
                },
                child: const Icon(Icons.arrow_upward)),
          ),
        )
      ],
    );
  }

  void _moveToTop(int duration) {
    _listController.animateTo(
      .0,
      duration: Duration(milliseconds: duration),
      curve: Curves.ease,
    );
  }

  Widget _getList() {
    return KeepAliveWrapper(
      child: SmartRefresher(
        controller: _controller,
        enablePullUp: true,
        onLoading: _loadData,
        onRefresh: _onRefresh,
        child: _list.isEmpty
            ? const Center(
                child: Text('暂无数据'),
              )
            : ListView.builder(
                shrinkWrap: true,
                reverse: false,
                itemCount: _list.length,
                controller: _listController,
                itemBuilder: (c, i) {
                  MineExternalItem data = _list[i];
                  return InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, '/mineexternalDetails',
                            arguments: {"url": data.url, "type": widget.type});
                      },
                      child: CardParent(
                        header: Text(
                          data.title,
                          softWrap: true,
                          textAlign: TextAlign.left,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: const TextStyle(
                            fontSize: 12,
                          ),
                        ),
                        body: Row(children: [
                          SizedBox(
                            width: 100,
                            height: 70,
                            child: Image.network(data.imgUrl),
                          ),
                          Container(
                            width: 210,
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  data.des,
                                  softWrap: true,
                                  textAlign: TextAlign.left,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 3,
                                  style: const TextStyle(
                                      fontSize: 12, height: 2.0),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 10),
                                  child: Text(
                                    data.publishDate,
                                    softWrap: true,
                                    textAlign: TextAlign.left,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: const TextStyle(
                                      fontSize: 12,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          )
                        ]),
                      ));
                }),
      ),
    );
  }
}
