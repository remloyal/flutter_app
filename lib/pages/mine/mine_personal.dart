import 'package:dio/dio.dart';
import 'package:fire_control_app/http/mine_api.dart';
import 'package:fire_control_app/models/mine_entity.dart';
import 'package:fire_control_app/utils/toast.dart';
import 'package:flutter/material.dart';
import 'package:fire_control_app/widgets/fc_details.dart';
import 'package:fire_control_app/common/global.dart';
import 'package:fire_control_app/widgets/popup/popup.dart';
import 'package:image_picker/image_picker.dart';

class MinePersonal extends StatefulWidget {
  const MinePersonal({super.key, this.index = 1});
  final int index;
  @override
  State<MinePersonal> createState() => _MinePersonalState();
}

class _MinePersonalState extends State<MinePersonal> {
  late Info info = Info(
      unitName: '',
      nickName: '',
      cellPhone: '',
      roleName: '',
      createTime: '',
      reviewTime: '',
      reviewer: '',
      headImgUrl: '',
      message: 0);
  late Map data = {};
  late bool _loadingState = false;

  XFile? image;
  final ImagePicker _imagePicker = ImagePicker();

  @override
  void initState() {
    super.initState();
    init();
    setState(() {});
  }

  init() async {
    info = await MineApi.useMyInfo();
    data = info.toJsonPersonal();
    _loadingState = true;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return FcDetailPage(
      title: '个人资料',
      loadingState: _loadingState,
      roll: false,
      body: [
        Container(
          padding: const EdgeInsets.all(10),
          margin: const EdgeInsets.all(10),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(8)),
          child: Column(children: [...setList()]),
        )
      ],
    );
  }

  List<Widget> setList() {
    List<Widget> todo = [];
    data.forEach(
      (key, value) {
        todo.add(_setItem(key, value));
      },
    );
    return todo;
  }

  Widget _setItem(String text, String value) {
    if (text == '头像') {
      return Container(
        padding: const EdgeInsets.only(top: 10, bottom: 10),
        decoration: const BoxDecoration(
            border: Border(
                bottom: BorderSide(
                    width: 0.5, color: Color.fromARGB(255, 211, 211, 211)))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(text),
            Row(children: [
              InkWell(
                child: Container(
                  padding: const EdgeInsets.all(1),
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 228, 228, 228),
                  ),
                  child: Image.network(Global.profile.apiInfo.imgUrl + value,
                      width: 80, height: 80, fit: BoxFit.cover),
                ),
                onTap: () {
                  Navigator.push(
                      context,
                      Popup(
                          child: DetailScreenImg(
                        url: Global.profile.apiInfo.imgUrl + value,
                      )));
                },
              ),
              InkWell(
                onTap: () {
                  showBottomMenu();
                },
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    '修改',
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              ),
            ]),
          ],
        ),
      );
    }
    return Container(
      padding: const EdgeInsets.only(top: 10, bottom: 10),
      decoration: const BoxDecoration(
          border: Border(
              bottom: BorderSide(
                  width: 0.5, color: Color.fromARGB(255, 211, 211, 211)))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(text),
          Text(
            value.isNotEmpty ? value : '暂无数据',
            style: const TextStyle(color: Color(0xFFA5A5A5)),
          )
        ],
      ),
    );
  }

  showBottomMenu() {
    image = null;
    showModalBottomSheet(
        context: context,
        //isScrollControlled: true,//设为true，此时为全屏展示
        builder: (BuildContext context) {
          return Container(
            color: Colors.white,
            height: 180,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                ListTile(
                  title: const Text('拍照',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16)),
                  onTap: () {
                    _takePhoto();
                    Navigator.pop(context);
                  },
                ),
                const Divider(
                  height: 1,
                ),
                ListTile(
                  title: const Text('相册',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                      )),
                  onTap: () {
                    _openPhotoAlbum();
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

  ///拍照
  Future _takePhoto() async {
    image = await _imagePicker.pickImage(
      source: ImageSource.camera,
    );
    if (image != null) {
      uploadMyImg(image);
    }
  }

  ///打开相册
  Future _openPhotoAlbum() async {
    image = await _imagePicker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      uploadMyImg(image);
    }
  }

  // 更改头像
  uploadMyImg(image) async {
    FormData formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(
        image.path,
      )
    });
    Message.show('上传头像中...');
    var data = await MineApi.uploadMyImg(formData);
    if (data['code'] == 200) {
      Message.show('更换头像成功');
      _loadingState = false;
      init();
    } else {
      Message.error(data['message'] ?? '更换头像失败');
    }
  }
}
