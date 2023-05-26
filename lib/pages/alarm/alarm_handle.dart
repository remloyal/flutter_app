import 'dart:io';

import 'package:fire_control_app/common/fc_color.dart';
import 'package:fire_control_app/utils/toast.dart';
import 'package:fire_control_app/widgets/card_father.dart';
import 'package:fire_control_app/widgets/fc_details.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class FireHandlePage extends StatelessWidget {

  static const routeName = '/fireHandle';

  final int fireId;

  const FireHandlePage({super.key, required this.fireId});

  @override
  Widget build(BuildContext context) {
    return FcDetailPage(
      title: '关闭火情',
      body: [
        CardContainer(
          children: [
            HandleDescription(),
            SizedBox(height: 30,),
            HandleAttachment(),
          ],
        )
      ],
      footer: [
        Expanded(
          child: HandleButton(
            title: '提交',
            onPressed: () {

            },
          ),
        )
      ],
    );
  }
}

class HandleDescription extends StatelessWidget {

  final ValueChanged<String>? onChanged;

  const HandleDescription({super.key, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const CardHeader(title: '事件描述',),
        Form(
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
            // onChanged: onChanged,
            onSaved: (value) {

            },
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