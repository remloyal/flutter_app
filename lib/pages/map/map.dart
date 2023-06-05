import 'package:fire_control_app/models/home.dart';
import 'package:fire_control_app/pages/map/cache/CacheTileProvider.dart';
import 'package:fire_control_app/pages/map/map_method.dart';
import 'package:fire_control_app/pages/map/map_plan.dart';
import 'package:fire_control_app/widgets/button_group.dart';
import 'package:fire_control_app/widgets/fc_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapCase<T> extends StatelessWidget {
  const MapCase({super.key, this.info});

  final MapInfo? info;

  static const routeName = '/MapCase';

  @override
  Widget build(BuildContext context) {
    return FireMap(
      info: info!,
    );
  }
}

class FireMap<T> extends StatefulWidget {
  const FireMap({super.key, required this.info});

  final MapInfo info;

  @override
  State<FireMap> createState() => _FireMapState();
}

class _FireMapState extends State<FireMap> {
  final mapController = MapController();
  late double mapzoom = 15.0;
  late LatLng _latLng = LatLng(
    28.196346,
    112.977216,
  );
  late int _index = 0;
  late StateSetter _mapPlanSetter;

  late bool roadState = false;

  late List<Marker> markers = [];

  late List<CircleMarker> circleMarkers = [];

  Widget? trendsPoint;

  @override
  void initState() {
    super.initState();
    if (widget.info.typeIndex == 4) {
      if (widget.info.lbsList.isNotEmpty) {
        markers.addAll(widget.info.lbsList);
      }
      _latLng = LatLng(widget.info.point![1], widget.info.point![0]);
      circleMarkers.addAll(widget.info.circle);
      Future.delayed(const Duration(milliseconds: 50)).then((e) {
        mapController.move(_latLng, 16);
      });
    } else {
      initMap();
    }
  }

  initMap() async {
    if (widget.info.type == MapType.planView) {
      _index = 1;
    }
    if (widget.info.point != null) {
      _latLng = LatLng(widget.info.point![1], widget.info.point![0]);
    } else {
      _latLng = LatLng(widget.info.unit!.pointY, widget.info.unit!.pointX);
    }

    markers.add(MapPoint.unit(widget.info.unit!));
    if ([0, 1, 2].contains(widget.info.typeIndex)) {
      int index = widget.info.typeIndex;
      MarkerParam fireMaker = index == 0
          ? MarkerTypes.fire()
          : index == 1
              ? MarkerTypes.trouble()
              : MarkerTypes.danger();
      trendsPoint = await MapPoint.file(fireMaker, maker: false);
    }

    if (widget.info.type == MapType.map || widget.info.type == MapType.mapPlan) {
      Future.delayed(const Duration(milliseconds: 50)).then((e) {
        mapController.move(_latLng, 15);
      });
    }

    if (widget.info.lbsList.isNotEmpty) {
      markers.addAll(widget.info.lbsList);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return FcDetailPage(
      title: '地图',
      body: [
        SizedBox(
            height: MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top - 56,
            width: MediaQuery.of(context).size.width,
            child: Stack(
              children: [
                if (widget.info.type == MapType.map || widget.info.type == MapType.mapPlan)
                  Container(
                    constraints: BoxConstraints(
                        maxHeight: MediaQuery.of(context).size.height, maxWidth: MediaQuery.of(context).size.width),
                    child: FlutterMap(
                      mapController: mapController,
                      options: MapOptions(
                        center: LatLng(
                          28.19485,
                          112.972898,
                        ),
                        zoom: mapzoom,
                        enableScrollWheel: true,
                        debugMultiFingerGestureWinner: true,
                        minZoom: 5,
                        maxZoom: 18.4,
                        keepAlive: true,
                        onTap: (tapPosition, LatLng point) {
                          if (widget.info.typeIndex != 4) {
                            widget.info.setPoint([
                              double.parse(point.longitude.toStringAsFixed(6)),
                              double.parse(point.latitude.toStringAsFixed(6))
                            ]);
                            _latLng = point;
                            setState(() {});
                          }
                        },
                        onPositionChanged: (position, hasGesture) {
                          setState(() {
                            mapzoom = double.parse(position.zoom!.toStringAsFixed(2));
                          });
                        },
                      ),
                      // nonRotatedChildren: [
                      //   RichAttributionWidget(
                      //     attributions: [
                      //       TextSourceAttribution(
                      //         'OpenStreetMap contributors',
                      //         onTap: () {
                      //           print('OpenStreetMap');
                      //         },
                      //       ),
                      //     ],
                      //   ),
                      // ],
                      children: [
                        TileLayer(
                          tileProvider: CacheTileProvider('osm'),
                          urlTemplate:
                              'https://webrd0{s}.is.autonavi.com/appmaptile?lang=zh_cn&size=1&scale=2&style=8&x={x}&y={y}&z={z}',
                          subdomains: const ["1", "2", "3", "4"],
                          userAgentPackageName: 'dev.fire_control_app',
                        ),
                        // roadTileLayer,
                        CircleLayer(
                          circles: [...circleMarkers],
                        ),
                        MarkerLayer(
                          rotate: true,
                          markers: [
                            ...markers,
                            if (widget.info.typeIndex != 4)
                              Marker(
                                  width: 150,
                                  height: 120,
                                  point: _latLng,
                                  rotateOrigin: const Offset(-10, -10),
                                  builder: (ctx) => trendsPoint ?? Container() //
                                  ),
                          ],
                        ),
                      ],
                    ),
                  ),
                Positioned(bottom: 20, left: 18, child: Text('$mapzoom')),
                Positioned(
                    child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  color: const Color(0xD7FFFFFF),
                  child: Center(child: Text(widget.info.point != null ? widget.info.point!.join(',') : '')),
                )),
                if (widget.info.type == MapType.planView || widget.info.type == MapType.mapPlan)
                  Positioned(
                    child: StatefulBuilder(
                      builder: (context, setState) {
                        _mapPlanSetter = setState;
                        if (_index == 1) {
                          return MapPlan(
                            info: widget.info,
                          );
                        } else {
                          return Container();
                        }
                      },
                    ),
                  ),
                if (widget.info.type == MapType.mapPlan)
                  Positioned(
                      bottom: 10,
                      right: 18,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          color: Colors.white,
                        ),
                        child: ButtonGroup(
                          names: const ['地图', '平面'],
                          height: 36,
                          width: 50,
                          onTap: (index) {
                            _mapPlanSetter(() {
                              _index = index;
                            });
                          },
                        ),
                      )),
                if (widget.info.type == MapType.map || widget.info.type == MapType.mapPlan)
                  Positioned(
                      bottom: 60,
                      right: 18,
                      child: InkWell(
                        onTap: () {
                          mapController.move(_latLng, 16);
                        },
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: Colors.white,
                          ),
                          child: const Center(
                            child: Icon(Icons.gps_fixed),
                          ),
                        ),
                      )),
              ],
            ))
      ],
    );
  }

  @override
  void dispose() {
    mapController.dispose();
    super.dispose();
  }
}
