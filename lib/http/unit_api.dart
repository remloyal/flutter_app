import 'package:fire_control_app/http/http.dart';
import 'package:fire_control_app/models/unit.dart';
import 'dart:convert';

class UnitApi {
  // 单位列表
  static Future<List<Unit>> getUnitList() async {
    var response = await Http.dio.get('/mobile/unit/select');
    List<dynamic> data = response.data['data'];
    List<Unit> list = data.map((e) => Unit.fromJson(e)).toList();
    return list;
  }

  // 建筑列表
  static Future<List<Building>> getBuilding(int? unitId) async {
    var response = await Http.dio.get('/mobile/building/list',
        queryParameters: {'unitId': unitId ?? ''});
    List<dynamic> data = response.data['data'];
    List<Building> list = data.map((e) => Building.fromJson(e)).toList();
    return list;
  }

  // 建筑列表
  static Future<List<Floors>> getBuildingFloors(int buildingId) async {
    var response = await Http.dio.get('/mobile/building/floors',
        queryParameters: {'buildingId': buildingId});
    List<dynamic> data = response.data['data'];
    List<Floors> list = data.map((e) => Floors.fromJson(e)).toList();
    return list;
  }

  // 房间列表
  static Future<List<Rooms>> getBuildingRooms(
      int buildingId, int floorId) async {
    var response = await Http.dio.get('/mobile/building/rooms',
        queryParameters: {'buildingId': buildingId, 'floorId': floorId});
    List<dynamic> data = response.data['data'];
    List<Rooms> list = data.map((e) => Rooms.fromJson(e)).toList();
    return list;
  }
}
