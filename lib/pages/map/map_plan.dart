// import 'dart:ffi';

import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import 'package:fire_control_app/common/global.dart';
import 'package:fire_control_app/models/home.dart';
import 'package:fire_control_app/pages/map/map_method.dart';

class MapPlan extends StatefulWidget {
  const MapPlan({super.key, required this.info});
  final MapInfo info;

  @override
  State<MapPlan> createState() => _MapPlanState();
}

class _MapPlanState extends State<MapPlan> {
  GlobalKey keyInteractive = GlobalKey();
  Offset _offset = const Offset(0, 0);
  late Size layerSize = Size.zero;
  // late Offset layerOffset = Offset.zero;

  late List<double> planPoint = [0, 0];

  // 缩放比例
  final TransformationController _transformationController = TransformationController();

  late String imgUrl = '';
  Widget? trendsPoint;

  @override
  void initState() {
    super.initState();
    if (widget.info.floor!['svgUrl'] == null) {
      imgUrl = '';
    } else {
      imgUrl = Global.profile.apiInfo.imgUrl + widget.info.floor!['svgUrl'];
    }
  }

  init() {
    if (widget.info.point != null) {
      planPoint = widget.info.point!;
      _offset = Offset(planPoint[0] * layerSize.width, planPoint[1] * layerSize.height);
    }
    if ([0, 1, 2].contains(widget.info.typeIndex)) {
      int index = widget.info.typeIndex;
      MarkerParam fireMaker = index == 0
          ? MarkerTypes.fire
          : index == 1
              ? MarkerTypes.trouble
              : MarkerTypes.danger;
      trendsPoint = MapPoint.file(fireMaker, maker: false, titleColor: Colors.white);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top - 56,
      width: MediaQuery.of(context).size.width,
      decoration: const BoxDecoration(color: Color(0xff000000)),
      child: Stack(children: [
        Center(
            child: Container(
                color: const Color.fromARGB(255, 43, 43, 43),
                // padding: EdgeInsets.all(10),
                child: GestureDetector(
                  onTapUp: (details) {
                    _offset = _transformationController.toScene(details.localPosition);
                    if (imgUrl != '') {
                      getOffsetFloat(_offset);
                    }
                    setState(() {});
                  },
                  child: InteractiveViewer(
                      key: keyInteractive,
                      transformationController: _transformationController,
                      panAxis: PanAxis.aligned,
                      // boundaryMargin: EdgeInsets.all(10),
                      minScale: 0.1,
                      maxScale: 5.0,
                      //对子Widget 进行缩放平移
                      onInteractionStart: (details) {
                        print('onInteractionStart  ---------- ${details.localFocalPoint}');
                      },
                      onInteractionUpdate: (details) {
                        // print('focalPoint ------------ ${details}');
                        // print(keyInteractive);
                        // RenderBox renderBox = keyInteractive.currentContext?.findRenderObject() as RenderBox;
                        // final positionsAmber = renderBox.localToGlobal(Offset(0, 0));
                        // 更新层
                        // var scalesss = _transformationController.value.getMaxScaleOnAxis();
                        // print(scalesss);
                        // _scale = scalesss;
                        // var office = _transformationController.value.getTranslation();
                        // layerOffset = Offset(office.y, office.x);
                        // setState(() {});
                      },
                      child: Stack(
                        children: [
                          Container(
                            width: layerSize.width,
                            height: layerSize.height,
                            decoration: const BoxDecoration(
                                // shape: BoxShape.circle,
                                // color: Colors.red,
                                ),
                            child: Stack(children: [
                              Positioned(
                                left: _offset.dx - 60,
                                top: _offset.dy - 60,
                                width: 120,
                                height: 120,
                                child: Container(
                                  child: trendsPoint ?? Container(),
                                ),
                              ),
                            ]),
                          ),
                          // if (imgUrl != '')
                          PlanImage(
                            type: 'network',
                            imageUrl: imgUrl,
                            change: (Size size) {
                              layerSize = size;
                              print(layerSize);

                              setState(() {
                                init();
                              });
                            },
                          ),
                        ],
                      )),
                ))),
        Positioned(
            child: Container(
          width: MediaQuery.of(context).size.width,
          height: 50,
          color: const Color(0xD7FFFFFF),
          child: Center(child: Text(planPoint.join(','))),
        )),
      ]),
    );
  }

  getOffsetFloat(Offset offset) {
    planPoint[0] = offset.dx / layerSize.width;
    planPoint[1] = offset.dy / layerSize.height;
    // widget.info.point = planPoint.join(',');

    widget.info.setPoint(planPoint);
  }

  @override
  void dispose() {
    _transformationController.dispose();
    super.dispose();
  }
}

class PlanImage extends StatefulWidget {
  const PlanImage({Key? key, required this.imageUrl, required this.change, this.type = 'asset'}) : super(key: key);
  final String imageUrl;
  final String? type;
  final Function(Size) change;
  @override
  _MyImageState createState() => _MyImageState();
}

class _MyImageState extends State<PlanImage> {
  final GlobalKey _imageKey = GlobalKey();
  Size? _imageSize;
  late int imageWidth;
  late int imageHeight;
  late Image? imageNetwork;
  late ImageProvider<Object>? _imageProvider;

  final AssetImage _defaultImage = const AssetImage('assets/images/default_floor.png');
  @override
  void initState() {
    super.initState();
    // _imageProvider = const AssetImage('assets/images/default_floor.png');
    // _afterLayout();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (widget.imageUrl == '') {
      _imageProvider = null;
      return;
    }
    if (widget.type == 'asset') {
      _imageProvider = AssetImage(widget.imageUrl);
    }
    if (widget.type == 'network') {
      _imageProvider = NetworkImage(widget.imageUrl);
    }

    _imageProvider!.resolve(const ImageConfiguration()).addListener(
      ImageStreamListener(
        (ImageInfo info, bool _) {
          imageWidth = info.image.width;
          imageHeight = info.image.height;
          print('imageWidth $imageWidth --------imageHeight $imageHeight');

          Future.delayed(const Duration(milliseconds: 200)).then((e) {
            try {
              BuildContext? contextImg = _imageKey.currentContext;
              RenderBox? renderBoxImg = contextImg?.findRenderObject() as RenderBox?;
              _imageSize = renderBoxImg?.paintBounds.size;
              print('width -- ${_imageSize!.width}  height -- ${_imageSize!.height}');
              widget.change(_imageSize!);
            } catch (e) {
              print('======================  e');
            }
          });
          setState(() {});
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      key: _imageKey,
      width: MediaQuery.of(context).size.width,
      child: Image(
        image: _imageProvider ?? _defaultImage,
        width: MediaQuery.of(context).size.width,
        // height: imageSize.height,
        // fit: BoxFit.cover,
      ),
    );
  }
}
