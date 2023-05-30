
import 'package:fire_control_app/common/fc_color.dart';
import 'package:fire_control_app/common/fc_icon.dart';
import 'package:fire_control_app/http/message_api.dart';
import 'package:fire_control_app/models/message.dart';
import 'package:fire_control_app/utils/toast.dart';
import 'package:fire_control_app/widgets/button_group.dart';
import 'package:fire_control_app/widgets/card_father.dart';
import 'package:fire_control_app/widgets/fc_details.dart';
import 'package:fire_control_app/widgets/load_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class MessageCenterPage extends StatefulWidget {

  static const routeName = '/messageCenter';


  const MessageCenterPage({super.key});

  @override
  State<StatefulWidget> createState() => _MessageCenterPageState();
}

class _MessageCenterPageState extends State<MessageCenterPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List tabs = ["消息公告", "活动通知"];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: tabs.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return FcDetailPage(
      title: '消息中心',
      roll: false,
      actions: [
        IconButton(
          icon: const Icon(FcmIcon.read),
          onPressed: () {
            int index = _tabController.index;
            String content = '确定将所有消息公告的未读消息标为已读？';
            int type = 5;
            if (index == 1) {
              content = '确定将所有活动通知的未读消息标为已读？';
              type = 6;
            }
            showCupertinoDialog(context: context, builder: (BuildContext ctx) {
              return CupertinoAlertDialog(
                title: const Text('提示'),
                content: Text(content),
                actions: [
                  TextButton(
                    child: const Text('取消'),
                    onPressed: () {
                      Navigator.pop(ctx);
                    },
                  ),
                  TextButton(
                    child: const Text('确认'),
                    onPressed: () {
                      Navigator.pop(ctx);
                      MessageApi.read(type).then((value) {
                        if (value.code == 200) {
                          Message.show('标记成功!');
                        }
                      });
                    },
                  )
                ],
              );
            });
          },
        )
      ],
      body: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          color: Colors.white,
          child: TabBar(
            tabs: tabs.map((e) => Tab(text: e)).toList(),
            controller: _tabController,
            labelColor: Theme.of(context).primaryColor,
            unselectedLabelColor: Colors.black,
          ),
        ),
        Expanded(
          flex: 1,
          child: TabBarView(
            //构建
              controller: _tabController,
              children: [
                _MessageList(type: _MessageType.notice),
                _MessageList(type: _MessageType.activity),
              ]),
        )
      ],
    );
  }

  @override
  void dispose() {
    // 释放资源
    _tabController.dispose();
    super.dispose();
  }
}

enum _MessageType {
  notice,
  activity
}

extension _MessageTypeExtension on _MessageType {
  int get value {
    switch (this) {
      case _MessageType.notice:
        return 5;
      case _MessageType.activity:
        return 6;
    }
  }
}

class _MessageList extends StatelessWidget {

  final MessageParam _param;

  final _MessageType type;

  _MessageList({required this.type}) : _param = MessageParam()..type = type.value;

  @override
  Widget build(BuildContext context) {
    return LoadList<MessageApi, MessageParam, MessageItem>(
      api: MessageApi(),
      param: _param,
      toolbarBuilder: _buildToolbar,
      itemBuilder: _buildItem,
    );
  }

  Widget _buildToolbar(BuildContext context, int total) {
    return Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            Expanded(
              child: ButtonGroup(
                names: const ['未读', '已读'],
                height: 30,
                onTap: (index) {
                  _param.status = index + 1;
                  _param.change();
                },
              ),
            ),
            Text(
              '共 $total 条',
              style: const TextStyle(fontSize: 14, color: Color(0xff6A6A6A)),
            )
          ],
        ));
  }

  Widget _buildItem(BuildContext context, MessageItem item, int index) {

    String receiveLabel = type == _MessageType.notice ? '接收单位' : '活动单位';
    String contentLabel = type == _MessageType.notice ? '公告内容' : '活动内容';

    String receiveUnit = item.receiveUnitName.isNotEmpty ? item.receiveUnitName : '未知单位';
    String content = item.content.isNotEmpty ? item.content : '无详细内容';

    Color? titleColor;
    if (item.status == 2) titleColor = FcColor.base9;
    return InkWell(
      onTap: () {
        String routeName = type == _MessageType.notice
            ? NoticeDetailPage.routeName
            : ActivityDetailPage.routeName;
        Navigator.pushNamed(context, routeName, arguments: item.id);
      },
      child: CardContainer(
        bottomMargin: false,
        children: [
          CardHeader(
            leadingColor: titleColor,
            titleColor: titleColor,
            title: item.title,
            tail: Text(
              item.sendTime,
              style: const TextStyle(color: FcColor.base9, fontSize: 12),
            ),
          ),
          XfItem(
            label: receiveLabel,
            content: receiveUnit,
          ),
          XfItem(
            label: contentLabel,
            content: content,
          )
        ],
      ),
    );
  }
}

class _MessageDetailTitle extends StatelessWidget {

  final String? title;
  final String? time;

  const _MessageDetailTitle({this.title, this.time});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        children: [
          Text(title ?? '-', style: const TextStyle(fontSize: 16),),
          const SizedBox(height: 8,),
          Text(
              time ?? '-',
              style: const TextStyle(fontSize: 12, color: FcColor.base9)
          )
        ],
      ),
    );
  }
}

class NoticeDetailPage extends StatefulWidget {

  static const routeName = '/noticeDetail';

  final int noticeId;

  const NoticeDetailPage({super.key, required this.noticeId});

  @override
  State<StatefulWidget> createState() => _NoticeDetailPageState();
}

class _NoticeDetailPageState extends State<NoticeDetailPage> {

  NoticeDetail? _detail;

  @override
  void initState() {
    super.initState();
    MessageApi.getNoticeDetail(widget.noticeId).then((value) {
      _detail = value;
      setState(() {

      });
    });
  }

  @override
  Widget build(BuildContext context) {
    //分割线
    CardDivider divider = const CardDivider();

    //内容
    Widget content = Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            '接收单位: ${_detail?.receiveUnitName ?? ''}',
            style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold
            ),
          ),
          const SizedBox(height: 8,),
          Text(
            _detail?.content ?? '',
            style: const TextStyle(color: FcColor.base6),
          )
        ],
      ),
    );
    return FcDetailPage(
      title: '公告详情',
      body: [
        CardContainer(
          children: [
            _MessageDetailTitle(title: _detail?.title, time: _detail?.sendTime),
            divider,
            content,
            divider,
            XfItem(
              label: '发布人员',
              content: _detail?.senderName,
            ),
            XfItem(
              label: '发布单位',
              content: _detail?.senderUnitName,
            ),
          ],
        )
      ],
    );
  }
}

class ActivityDetailPage extends StatefulWidget {

  static const routeName = '/activityDetail';

  final int activityId;

  const ActivityDetailPage({super.key, required this.activityId});

  @override
  State<StatefulWidget> createState() => _ActivityDetailPageState();
}

class _ActivityDetailPageState extends State<ActivityDetailPage> {

  ActivityDetail? _detail;

  final List<String> _levels = [
    "囯事重要活动",
    "民事重要活动",
    "民事一般活动"
  ];

  @override
  void initState() {
    super.initState();
    MessageApi.getActivityDetail(widget.activityId).then((value) {
      _detail = value;
      setState(() {

      });
    });
  }

  @override
  Widget build(BuildContext context) {
    //分割线
    CardDivider divider = const CardDivider();

    //活动信息
    Widget info = Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        children: [
          XfItem(
            label: '活动单位',
            content: _detail?.unitName,
          ),
          XfItem(
            label: '活动地点',
            content: _detail?.location,
          ),
          XfItem(
            label: '举办时间',
            content: _detail?.startTime,
          ),
          XfItem(
            label: '重要性',
            content: _levels[_detail?.levels ?? 0],
          ),
          Row(
            children: [
              Expanded(
                child: XfItem(
                  label: '参加人数',
                  content: _detail?.activeUserNumber.toString(),
                ),
              ),
              Expanded(
                child: XfItem(
                  label: '危险源',
                  content: _detail?.dangerSource == 1 ? '多' : _detail?.dangerSource == 2 ? '中' : '少',
                ),
              )
            ],
          ),
          Row(
            children: [
              Expanded(
                child: XfItem(
                  label: '有无明火',
                  content: _detail?.fire == 1 ? '有' : '无',
                ),
              ),
              Expanded(
                child: XfItem(
                  label: '是否禁烟',
                  content: _detail?.smoking == 1 ? '是' : '否',
                ),
              )
            ],
          )
        ],
      ),
    );

    //内容
    Widget content = Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
      alignment: Alignment.topLeft,
      child: Text(
        _detail?.content ?? '',
        style: const TextStyle(color: FcColor.base6),
      ),
    );

    return FcDetailPage(
      title: '活动详情',
      body: [
        CardContainer(
          children: [
            _MessageDetailTitle(title: _detail?.name, time: _detail?.startTime),
            divider,
            const CardHeader(title: '活动信息',),
            info,
            const CardHeader(title: '活动内容',),
            content,
            divider,
            XfItem(
              label: '发布人员',
              content: _detail?.sendUserName,
            ),
            XfItem(
              label: '发布单位',
              content: _detail?.senderUnitName ?? '-',
            ),
          ],
        )
      ],
    );
  }
}