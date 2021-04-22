import 'dart:convert';
import 'dart:developer';

import 'package:sales_force/database/tables/visits_table.dart';
import 'package:sales_force/services/common.dart';
import 'package:sqflite/sqflite.dart';

import '../shared/config.dart';
import '../shared/library.dart';

class SPostVisit extends ServiceCommon {
  Database db;

  SPostVisit(Database database) {
    initiate();
    db = database;
  }

  @override
  String get name => 'Visit Service';

  @override
  Future<void> perform() async {
    cycleComplete = false;
    log('VISIT SERVICE RESPONDING');
    await uploadVisit();
  }

  Future<void> uploadVisit() async {
    List<Map<String, dynamic>> data = await db.query(TableVisits.tableName,
        where: '${TableVisits.isOrder} = 0');
    data.forEach((e) async {
      Map<String, String> fJson = new Map();
      fJson['${jsonEncode('visit_data')}'] = jsonEncode(e);
      bool status = await Library.uploadToServer(Config.putOrderVisitAPILink,
          jsonString: fJson.toString());
      await db.update(
          TableVisits.tableName, {TableVisits.isUpload: status ? 1 : 0},
          where: '${TableVisits.id} = ?',
          whereArgs: [e['order_taken_android_id']]);
    });
    cycleComplete = true;
  }
}
