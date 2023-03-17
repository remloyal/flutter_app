import 'dart:typed_data';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:fire_control_app/utils/toast.dart';

class SlideVerify extends StatefulWidget {
  const SlideVerify({
    super.key,
    required this.refresh,
    required this.imgMain,
    required this.imgBlock,
    required this.success,
    required this.check,
    required this.top,
    this.w,
    this.h,
  });

  // 正确比对
  final Function success;
  // 重新请求
  final Function refresh;
  // 比对
  final Function check;
  // 大图片
  final String imgMain;
  // 块图片
  final String imgBlock;
  // 块纵坐标
  final int top;
  // 原图片宽高，等比例缩放
  final int? w;
  final int? h;

  @override
  State<SlideVerify> createState() => _SlideVerifyState();
}

class _SlideVerifyState extends State<SlideVerify>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final GlobalKey _keyImg = GlobalKey();
  final GlobalKey _keySlider = GlobalKey();

  // 图片原本宽高
  double width = 300;
  double height = 150;

  double sliderStartX = 0; //滑块未拖前的X坐标
  double sliderStartY = 0; //滑块未拖前的Y坐标
  double sliderXMoved = 0;

  double sliderWidth = 300;
  double sliderHeight = 250;

  double imgWidth = 300;
  double imgHeight = 150;
  int imgTop = 0;

  bool imgResult = false; //图片校验结果

  double sliderDistance = 0;
  double initial = 0.0;

  // 正常 normal 成功 success  失败  fail
  late String status = 'normal';

  late Uint8List imgMainPrice;
  late Uint8List imgBlockPrice;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    imgMainPrice = const Base64Decoder().convert(widget.imgMain);
    imgBlockPrice = const Base64Decoder().convert(widget.imgBlock);
    imgTop = widget.top;
    SchedulerBinding.instance.addPostFrameCallback((time) {
      BuildContext? context = _keySlider.currentContext;
      RenderBox? renderBox = context?.findRenderObject() as RenderBox?;
      Size? size = renderBox?.paintBounds.size;

      BuildContext? contextImg = _keyImg.currentContext;
      RenderBox? renderBoxImg = contextImg?.findRenderObject() as RenderBox?;
      Size? sizeImg = renderBoxImg?.paintBounds.size;
      Future.delayed(const Duration(milliseconds: 50)).then((e) {
        setState(() {
          sliderWidth = size!.width;
          _getSize();
        });
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('$width$height');
    // print(context.size);
    return Container(
      padding: const EdgeInsets.all(0),
      height: imgHeight + 50,
      // constraints: const BoxConstraints(maxHeight: 250),
      child:
          Column(children: [imageAssembly(context), sliderAssembly(context)]),
    );
  }

  @override
  void didUpdateWidget(covariant SlideVerify oldWidget) {
    imgMainPrice = const Base64Decoder().convert(widget.imgMain);
    imgBlockPrice = const Base64Decoder().convert(widget.imgBlock);
    print('  更新了');
    super.didUpdateWidget(oldWidget);
  }

  // 图片组件
  Widget imageAssembly(BuildContext context) {
    // var _image =
    //     new Image.asset('lib/assets/images/ceshi.png', fit: BoxFit.cover);
    // _image!.image
    //     .resolve(new ImageConfiguration())
    //     .addListener(ImageStreamListener((image, synchronousCall) {
    //   print('image   $image.image ');
    //   print('image $synchronousCall');
    // }));
    // print(context.size);

    return Stack(alignment: Alignment.center, children: [
      Container(
        key: _keyImg,
        decoration: BoxDecoration(
          color: Colors.red,
          border: Border.all(
            color: Colors.red,
            width: 0.0,
          ),
        ),
        child: Image.memory(
          imgMainPrice,
          fit: BoxFit.cover,
        ),
      ),
      Positioned(
          left: sliderStartX,
          top: imgTop * (imgHeight / height),
          child: SizedBox(
            width: 50 * (imgWidth / width),
            height: 50 * (imgHeight / height),
            child: Image.memory(
              imgBlockPrice,
            ),
          )),
    ]);
  }

  _getSize() {
    BuildContext? contextImg = _keyImg.currentContext;
    RenderBox? renderBoxImg = contextImg?.findRenderObject() as RenderBox?;
    Size? sizeImg = renderBoxImg!.paintBounds.size;
    print('object image $sizeImg');
    setState(() {
      // sliderHeight = sizeImg!.height;
      imgWidth = sizeImg.width;
      imgHeight = sizeImg.height;
    });
  }

  // 滑块
  Widget sliderAssembly(BuildContext context) {
    return Container(
        height: 40,
        margin: const EdgeInsets.only(top: 8),
        // width: 350,
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(132))),
        child: Stack(
            key: _keySlider,
            clipBehavior: Clip.none,
            alignment: AlignmentDirectional.centerStart,
            children: <Widget>[
              Container(
                decoration: const BoxDecoration(
                    color: Color.fromARGB(233, 199, 199, 199)),
              ),
              Container(
                alignment: Alignment.center,
                child: const Text(
                  '请向右拖动滑块完成拼图',
                  style: TextStyle(color: Colors.black54, fontSize: 14),
                ),
              ),
              Positioned(
                child: GestureDetector(
                    onPanStart: (startDetails) {
                      initial = startDetails.globalPosition.dx;
                      _getSize();
                    },
                    onPanUpdate: (updateDetails) {
                      sliderDistance =
                          updateDetails.globalPosition.dx - initial;
                      if (sliderDistance >= (context.size!.width - 40)) {
                        sliderStartX = (context.size!.width - 40);
                      } else if (sliderDistance < 0) {
                        sliderStartX = 0;
                      } else {
                        sliderStartX = sliderDistance;
                      }
                      print('sliderStartX==>  $sliderStartX');
                      setState(() {});
                    },
                    onPanEnd: (endDetails) {
                      //结束
                      verify();
                      print("endDetails  $sliderStartX");
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          height: 100,
                          width: sliderStartX,
                          decoration: BoxDecoration(
                            color: status == 'normal'
                                ? const Color.fromARGB(255, 26, 145, 249)
                                : status == 'success'
                                    ? const Color.fromARGB(255, 119, 250, 102)
                                    : const Color.fromARGB(255, 255, 94, 94),
                          ),
                        ),
                        Container(
                          height: 100,
                          width: 40,
                          decoration: BoxDecoration(
                            color: status == 'normal'
                                ? const Color.fromARGB(255, 26, 145, 249)
                                : status == 'success'
                                    ? const Color.fromARGB(255, 119, 250, 102)
                                    : const Color.fromARGB(255, 255, 94, 94),
                            border: Border.all(
                              color: const Color.fromARGB(255, 255, 255, 255),
                              width: 0.0,
                            ),
                          ),
                          child: const Icon(
                            IconData(0xe633, fontFamily: 'fcm'),
                            color: Color.fromARGB(255, 59, 59, 59),
                          ),
                        ),
                      ],
                    )),
              )
            ]));
  }

  verify() async {
    var moveX = sliderStartX / (imgWidth / width);
    var start = await widget.check(moveX.toInt());
    if (!start) {
      setState(() {
        status = 'fail';
      });
      Message.show('验证码错误！');
      var imgList = await widget.refresh();
      imgMainPrice = const Base64Decoder().convert(imgList['imgMain']);
      imgBlockPrice = const Base64Decoder().convert(imgList['imgBlock']);
      Future.delayed(const Duration(milliseconds: 1000)).then((e) {
        setState(() {
          imgTop = imgList['top'];
          imgMainPrice = const Base64Decoder().convert(imgList['imgMain']);
          imgBlockPrice = const Base64Decoder().convert(imgList['imgBlock']);
          sliderStartX = 0;
          status = 'normal';
        });
      });
    } else {
      setState(() {
        status = 'success';
      });
      Message.show('验证成功！');
      Future.delayed(const Duration(milliseconds: 1000)).then((e) {
        widget.success();
      });
    }
  }
}
