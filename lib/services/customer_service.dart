import 'dart:developer';

import 'package:sales_force/database/tables/customer_table.dart';
import 'package:sales_force/services/service_common.dart';
import 'package:sales_force/shared/config.dart';
import 'package:sales_force/shared/library.dart';
import 'package:sqflite/sqflite.dart';

class SUploadCustomer extends ServiceCommon {
  Database db;
  SUploadCustomer(Database db) {
    this.db = db;
    initiate();
  }

  @override
  String get name => 'Customer Upload';

  @override
  Future<void> perform() async {
    cycleComplete = false;
    log('CUSTOMER UPLOAD SERVICE RESPONDING');
    await uploadCustomer();
    cycleComplete = true;
  }

  Future<void> uploadCustomer() async {
    try {
      (await db.rawQuery('select * from customer')).forEach((element) {
        print(element);
      });
      List<Map<String, dynamic>> list = await db.query(TableCustomer.tableName,
          where: '${TableCustomer.status} = ?', whereArgs: ['0']);

      list.forEach((e) async {
        log(e.toString());
        bool x = await Library.uploadToServer(Config.createCustomerAPILink,
            jsonString: e.toString());
        if (x) {
          db.update('customer', {'status': '1'},
              where: 'id = ?', whereArgs: [e['id']]);
        }
      });
    } catch (e) {
      log('>>>ERROR ON CUSTOMER UPLOAD SERVICE\n$e');
    }
  }
}
