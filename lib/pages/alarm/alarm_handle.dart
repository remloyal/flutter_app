import 'package:fire_control_app/common/fc_color.dart';
import 'package:fire_control_app/http/alarm_api.dart';
import 'package:fire_control_app/models/alarm_entity.dart';
import 'package:fire_control_app/models/home.dart';
import 'package:fire_control_app/models/response.dart';
import 'package:fire_control_app/pages/home/report/file_upload.dart';
import 'package:fire_control_app/utils/toast.dart';
import 'package:fire_control_app/widgets/button_group.dart';
import 'package:fire_control_app/widgets/card_father.dart';
import 'package:fire_control_app/widgets/fc_details.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

enum HandlePageType {
  fire,
  alarm,
  trouble,
  danger
}

class HandlePageParam {
  int id;
  HandlePageType type;

  HandlePageParam({required this.id, required this.type});
}

class HandlePage extends StatefulWidget {

  static const routeName = '/handlePage';

  final HandlePageParam param;

  const HandlePage({super.key, required this.param});

  @override
  State<StatefulWidget> createState() => _HandlePageState();
}

class _HandlePageState extends State<HandlePage> {
  late HandleParam _param;
  late FileData _fileData;

  int _selected = 0;

  @override
  void initState() {
    super.initState();
    _fileData = FileData();
    _param = _generateUploadParam();
  }

  HandleParam _generateUploadParam() {
    int id = widget.param.id;
    switch (widget.param.type) {
      case HandlePageType.fire:
        return FireHandleParam(alarmId: id);
      case HandlePageType.alarm:
        return AlarmHandleParam(alarmId: id);
      case HandlePageType.trouble:
        return TroubleHandleParam(troubleId: id);
      case HandlePageType.danger:
        return DangerHandleParam(dangerId: id);
    }
  }

  @override
  Widget build(BuildContext context) {

    String title = '关闭火情';

    if (widget.param.type == HandlePageType.alarm) {
      title = '处理告警';
    } else if (widget.param.type == HandlePageType.trouble) {
      title = '处理危险品';
    } else if (widget.param.type == HandlePageType.danger) {
      title = '处理隐患';
    }

    HandleDescription description = HandleDescription(
      onChanged: (String value) {
        _param.remark = value;
      },
    );

    List<Widget> children = [
      description,
      const SizedBox(height: 30,),
      FileUpdate(fileData: _fileData,)
    ];

    if (widget.param.type == HandlePageType.alarm) {
      children.insertAll(0, [
        const CardHeader(title: '是否发生火情',),
        StatefulBuilder(
          builder: (BuildContext ctx, StateSetter setter) {
            return SpaceRadioButtons(
              names: const ['是', '否'],
              selected: _selected,
              onTap: (index) {
                _selected = index;
                (_param as AlarmHandleParam).isFire = index + 1;
                setter((){});
              },
            );
          },
        ),
      ]);
    }

    return FcDetailPage(
      title: title,
      body: [
        CardContainer(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: children,
        )
      ],
      footer: [
        Expanded(
          child: HandleButton(
            title: '提交',
            onPressed: () {
              if (!description.validate()) return;
              if (_fileData.state == false) {
                Message.error('文件未全部上传完成，请稍后');
                return;
              }
              if (_fileData.fileIds.isEmpty) {
                Message.show('请选择附件');
                return;
              }
              _param.attachmentIds = _fileData.fileIds.join(',');
              _uploadData(context);
            },
          ),
        )
      ],
    );
  }

  Future<void> _uploadData(context) async {
    FcResponse? response;
    if (widget.param.type == HandlePageType.fire) {
      response = await FireApi.close(_param as FireHandleParam);
    } else if (widget.param.type == HandlePageType.alarm) {
      response = await AlarmApi.confirm(_param as AlarmHandleParam);
    } else if (widget.param.type == HandlePageType.trouble) {
      response = await TroubleApi.close(_param as TroubleHandleParam);
    } else if (widget.param.type == HandlePageType.danger) {
      response = await DangerApi.close(_param as DangerHandleParam);
    }

    if (response?.code == 200) {
      Message.show('操作成功');
      Navigator.pop(context, true);
    }
  }
}

class HandleDescription extends StatelessWidget {

  final ValueChanged<String>? onChanged;

  final GlobalKey<FormState> _formKey;

  HandleDescription({super.key, this.onChanged}) : _formKey = GlobalKey<FormState>();

  bool validate() {
    return _formKey.currentState?.validate() ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const CardHeader(title: '事件描述',),
        Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: TextFormField(
            maxLength: 140,
            minLines: 3,
            maxLines: null,
            keyboardType: TextInputType.text,
            decoration: const InputDecoration(
                hintText: '请输入描述内容，可使用输入法自带的语音转文字功能实现快速录入',
                hintMaxLines: 3,
                hintStyle: TextStyle(color: FcColor.base9)
            ),
            onChanged: onChanged,
            validator: (text) {
              if (text == null || text.isEmpty) {
                return '请输入描述内容';
              }
            },
          ),
        )
      ],
    );
  }
}

class HandleAttachment extends StatefulWidget {
  const HandleAttachment({super.key});

  @override
  State<StatefulWidget> createState() => _HandleAttachmentState();
}

class _HandleAttachmentState extends State<HandleAttachment> {

  List<XFile> _files = [];

  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const CardHeader(
          title: '附件上传',
          tail: Text('支持图片和视频', style: TextStyle(fontSize: 12, color: FcColor.base9),),
        ),
        Container(
          color: FcColor.baseF5,
          alignment: Alignment.center,
          width: 110.0,
          height: 110.0,
          child: InkWell(
            onTap: () {
              _chooseFile();
            },
            child: const Icon(Icons.add, size: 40),
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: Text('${_files.length}/6'),
        ),
        const Padding(
          padding: EdgeInsets.only(top: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _UploadStatus(hintText: '上传中', hintColor: FcColor.info,),
              _UploadStatus(hintText: '上传成功', hintColor: FcColor.ok,),
              _UploadStatus(hintText: '上传失败', hintColor: FcColor.err,),
            ],
          ),
        )
      ],
    );
  }

  void _chooseFile({int? index}) {
    showModalBottomSheet(
        context: context,
        useSafeArea: true,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
        ),
        builder: (BuildContext context) {

          Widget header = const Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 15),
                child: Text(
                  '选择图片/视频',
                  style: TextStyle(color: FcColor.base9, fontSize: 18),
                ),
              ),
              Divider(height: 1, indent: 10, endIndent: 10,)
            ],
          );

          return SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                header,
                _BottomSheetItem(title: '本地图库', onTap: () async {
                  Navigator.pop(context);
                  XFile? file = await _picker.pickImage(source: ImageSource.gallery);
                  _processFile(file);
                }),
                _BottomSheetItem(title: '拍照', onTap: () async {
                  Navigator.pop(context);
                  XFile? file = await _picker.pickImage(source: ImageSource.camera);
                  _processFile(file);
                }),
                _BottomSheetItem(title: '录像', onTap: () async {
                  Navigator.pop(context);
                  XFile? file = await _picker.pickVideo(source: ImageSource.camera);
                  _processFile(file);
                }),
                Container(color: FcColor.bodyColor, height: 10),
                _BottomSheetItem(title: '取消', onTap: () {
                  Navigator.pop(context);
                }),
              ],
            ),
          );
        });
  }

  void _processFile(XFile? file) {
    if (file == null) return;
    if (_files.length == 6) {
      Message.show('最多只能选择6个附件');
      return;
    }
    _files.add(file);
    setState(() { });
  }
}

class _BottomSheetItem extends StatelessWidget {

  final String title;
  final VoidCallback? onTap;

  const _BottomSheetItem({required this.title, this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 18)
      ),
      onTap: onTap,
    );
  }
}

class _UploadStatus extends StatelessWidget {

  final Color hintColor;
  final String hintText;

  const _UploadStatus({required this.hintText, required this.hintColor});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(width: 25, height: 12, color: hintColor,),
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Text(
            hintText,
            style: const TextStyle(fontSize: 13),
          ),
        )
      ],
    );
  }
}