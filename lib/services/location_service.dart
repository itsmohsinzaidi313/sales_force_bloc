import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:geolocator/geolocator.dart';
import 'package:sales_force/database/tables/location_table.dart';
import 'package:sales_force/services/common.dart';
import 'package:sales_force/shared/config.dart';
import 'package:sales_force/shared/library.dart';
import 'package:sqflite/sqflite.dart';

class SPostLocation extends ServiceCommon {
  Database db;
  SPostLocation(Database db) {
    this.db = db;
    initiate();
  }
  @override
  String get name => 'Location Service';

  @override
  Future<void> perform() async {
    cycleComplete = false;
    log('LOCATION SERVICE RESPONDING');
    recordLocation();
    uploadLocation();
  }

  Future<void> recordLocation() async {
    Position position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high)
        .timeout(
            Duration(
              seconds: 15,
            ),
            onTimeout: () => null);
    if (position != null) {
      await db.insert(TableLocation.tableName, {
        TableLocation.userId: Config.user.userId,
        TableLocation.time: Library.getDateTime(),
        TableLocation.lat: position.latitude,
        TableLocation.long: position.longitude,
      });
      log('LOCATION RECORDED');
    } else {
      log('FAULT ON uploadLocation CANNOT GET DEVICE LOCATION');
    }
  }

  Future<void> uploadLocation() async {
    List<Map<String, dynamic>> list = await db.query(TableLocation.tableName);
    list.forEach((element) async {
      Map<String, String> coordinates = new Map();
      coordinates['long'] = '${element[TableLocation.long]}';
      coordinates['time'] = '${TableLocation.time}';
      coordinates['lat'] = '${TableLocation.lat}';
      Map<String, String> finalJson = new Map();
      finalJson[jsonEncode('user_id')] =
          '${jsonEncode(element[TableLocation.userId])}';
      finalJson[jsonEncode('GpsCoordinate')] = '${[jsonEncode(coordinates)]}';
      bool status = await Library.uploadToServer(Config.putTrackingAPILink,
          jsonString: finalJson.toString());
      if (status) {
        await db.delete(TableLocation.tableName,
            where: '${TableLocation.id} = ?',
            whereArgs: [element[TableLocation.id]]);
        log('LOCATION UPLOADED');
      }
    });
    cycleComplete = true;
  }
}
