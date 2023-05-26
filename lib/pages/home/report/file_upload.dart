import 'package:fire_control_app/common/fc_color.dart';
import 'package:fire_control_app/models/home.dart';
import 'package:fire_control_app/utils/toast.dart';
import 'package:fire_control_app/widgets/card_father.dart';
import 'package:fire_control_app/widgets/popup/popup.dart';
import 'package:fire_control_app/widgets/videoPlayerScreen.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fire_control_app/http/home_api.dart';
import 'package:dio/dio.dart';

class FileUpdate<T> extends StatefulWidget {
  const FileUpdate({super.key, required this.fileData});
  final FileData fileData;

  @override
  State<FileUpdate> createState() => _FileUpdateState();
}

class _FileUpdateState extends State<FileUpdate> {
  List images = [];
  final ImagePicker _imagePicker = ImagePicker();

  // final FileData fileData = FileData();

  @override
  Widget build(BuildContext context) {
    double spread = (MediaQuery.of(context).size.width - 40) / 3;
    return CardParent(
        header: Row(children: [
          Container(width: 3, height: 14, color: FcColor.baseColor, margin: const EdgeInsets.fromLTRB(0, 0, 10, 0)),
          const Expanded(
            flex: 1,
            child: Text('附件上传'),
          ),
          const Text(
            '支持图片和视频',
            style: TextStyle(color: Color(0xff999999), fontSize: 14),
          )
        ]),
        body: Wrap(
          // spacing: 10,
          // runSpacing: 10,
          children: [
            ...widget.fileData.converts.map((FileTerm item) {
              return Container(
                  width: spread,
                  height: spread,
                  padding: const EdgeInsets.all(10),
                  child: Container(
                      color: const Color(0xffF5F5F5),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          InkWell(
                            onTap: () {
                              if (item.type == 'image') {
                                Navigator.push(
                                    context,
                                    Popup(
                                        child: DetailScreenImg(
                                      url: item.uint8List,
                                      type: 'memory',
                                    )));
                              }
                              if (item.type == 'video') {
                                Navigator.push(
                                    context,
                                    Popup(
                                      child: VideoPlayerScreen(file: item.file),
                                    ));
                              }
                            },
                            child: item.type == 'image'
                                ? Image.memory(item.uint8List!, fit: BoxFit.cover)
                                : Image.memory(item.videoImage!, fit: BoxFit.cover),
                          ),
                          Positioned(
                              right: 0,
                              top: 0,
                              child: InkWell(
                                onTap: () {
                                  deleteFile(item);
                                },
                                child: Container(
                                  width: 14,
                                  height: 14,
                                  // color: const Color(0xFF8A8A8A),
                                  decoration:
                                      const BoxDecoration(color: Color(0xFF8A8A8A), borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10))),
                                  child: const Icon(
                                    Icons.close,
                                    size: 10,
                                    color: Color.fromARGB(255, 226, 226, 226),
                                  ),
                                ),
                              )),
                          Positioned(
                            left: 0,
                            bottom: 0,
                            child: SizedBox(
                                width: spread,
                                child: LinearProgressIndicator(
                                  value: item.progress ?? 0,
                                  minHeight: 2,
                                  backgroundColor: const Color(0xFFFF0000),
                                  valueColor: const AlwaysStoppedAnimation(Colors.blue),
                                )),
                          )
                        ],
                      )));
            }).toList(),
            if (widget.fileData.converts.length < 6)
              InkWell(
                onTap: () {
                  showBottomMenu();
                },
                child: Container(
                    width: spread,
                    height: spread,
                    padding: const EdgeInsets.all(10),
                    child: Container(
                      color: const Color(0xffF5F5F5),
                      child: const Center(
                          child: Icon(
                        Icons.add,
                        size: 36,
                      )),
                    )),
              ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text('${widget.fileData.converts.length} / 6'),
              ],
            )
          ],
        ));
  }

  showBottomMenu() {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true, //设为true，此时为全屏展示
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        backgroundColor: Colors.white,
        builder: (BuildContext context) {
          return SizedBox(
            height: 280,
            // padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Center(
                    child: Text(
                      '选取图片/视频',
                      style: TextStyle(fontSize: 14, color: Color(0xff969799)),
                    ),
                  ),
                ),
                const Divider(
                  height: 1.0,
                  // indent: 60.0,
                  color: Color(0xFFCCCCCC),
                ),
                ListTile(
                  title: const Column(
                    children: [
                      Text('本地图库'),
                      Text(
                        '长安批量选择',
                        style: TextStyle(fontSize: 12, color: Color(0xff969799)),
                      )
                    ],
                  ),
                  onTap: () {
                    _openPhotoAlbum();
                    Navigator.pop(context);
                  },
                ),
                const Divider(
                  height: 1,
                ),
                ListTile(
                  title: const Text('拍照', textAlign: TextAlign.center, style: TextStyle(fontSize: 16)),
                  onTap: () {
                    _takePhoto();
                    Navigator.pop(context);
                  },
                ),
                const Divider(
                  height: 1,
                ),
                ListTile(
                  title: const Text('录像',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                      )),
                  onTap: () {
                    _openPhotoPicture();
                    Navigator.pop(context);
                  },
                ),
                Container(
                  color: const Color.fromARGB(255, 247, 247, 247),
                  height: 10,
                ),
                ListTile(
                  title: const Text('取消',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                      )),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          );
        });
  }

  //拍照
  Future _takePhoto() async {
    final XFile? image = await _imagePicker.pickImage(
      source: ImageSource.camera,
    );
    if ((widget.fileData.converts.length + 1) > 6) {
      Message.error('最多上传6个文件');
      return;
    }
    if (image != null) {
      List data = await widget.fileData.addFile(image);
      setState(() {
        update(data);
      });
    }
  }

  //打开相册
  Future _openPhotoAlbum() async {
    List<XFile> data = await _imagePicker.pickMultiImage();
    if ((widget.fileData.converts.length + data.length) > 6) {
      Message.error('最多上传6个文件');
      return;
    }
    if (data != null) {
      List todo = await widget.fileData.addAllFile(data);
      setState(() {
        for (var i = 0; i < todo.length; i++) {
          update(todo[i]);
        }
      });
    }
  }

  //拍摄视频
  Future _openPhotoPicture() async {
    final XFile? cameraVideo = await _imagePicker.pickVideo(source: ImageSource.camera);
    if ((widget.fileData.converts.length + 1) > 6) {
      Message.error('最多上传6个文件');
      return;
    }
    if (cameraVideo != null) {
      List data = await widget.fileData.addVideoFile(cameraVideo);
      setState(() {
        update(data);
      });
    }
  }

  update(data) async {
    FormData formDatas = FormData.fromMap({
      'attachments': data[0].data,
    });
    formDatas.fields.add(MapEntry('type', widget.fileData.type.toString()));
    widget.fileData.state = false;
    var response = await HomeApi.uploadFile(data[1], formDatas, uploadrogress);
    if (response['code'] == 200) {
      widget.fileData.converts[data[1]].id = response['data'][0];
      widget.fileData.fileIds.addAll(response['data']);
      widget.fileData.state = true;
    }
  }

  uploadrogress(index, value) {
    widget.fileData.converts[index].progress = value;
    setState(() {});
  }

  // 删除选择的文件
  deleteFile(FileTerm file) async {
    await showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("提示"),
            content: const Text("是否删除该文件"),
            actions: [
              TextButton(
                  onPressed: () {
                    widget.fileData.converts.remove(file);
                    widget.fileData.fileIds.remove(file.id);
                    Navigator.of(context).pop(true);
                  },
                  child: const Text("确定")),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: const Text(
                    "取消",
                    style: TextStyle(color: Color(0xffcccccc)),
                  ))
            ],
          );
        });
    setState(() {});
  }
}
