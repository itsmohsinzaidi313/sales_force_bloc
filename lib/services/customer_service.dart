import 'dart:convert';
import 'dart:developer';

import 'package:sales_force/bloc/verbose_bloc/verbose_bloc.dart';
import 'package:sales_force/database/tables/customer_table.dart';
import 'package:sales_force/services/service_common.dart';
import 'package:sales_force/shared/config.dart';
import 'package:sales_force/shared/library.dart';
import 'package:sqflite/sqflite.dart';

class SUploadCustomer extends ServiceCommon {
  Database db;
  SUploadCustomer(Database db, {VerboseBloc bloc}) {
    this.db = db;
    this.verboseBloc = bloc;
    initiate();
  }

  @override
  String get name => 'Customer Upload';

  @override
  Future<void> perform() async {
    cycleComplete = false;
    await uploadCustomer();
    cycleComplete = true;
  }

  Future<void> uploadCustomer() async {
    try {
      List<Map<String, dynamic>> list = await db.query(TableCustomer.tableName,
          columns: [
            '${TableCustomer.id} as android_customer_id',
            '${TableCustomer.userId}',
            '${TableCustomer.firstName}',
            '${TableCustomer.lastName}',
            '${TableCustomer.mobile}',
            '${TableCustomer.shopName}',
            '${TableCustomer.address}',
            '${TableCustomer.shopLat}',
            '${TableCustomer.shopLong}'
          ],
          where: '${TableCustomer.status} = ?',
          whereArgs: [0]);

        for (var e in list) {
        log(jsonEncode(e), name: this.name);
        log(Config.createCustomerAPILink, name: this.name);
        bool x = await Library.uploadToServer(Config.createCustomerAPILink,
            jsonString: jsonEncode(e));
        if (x) {
          await db.update('customer', {'status': '1'},
              where: '${TableCustomer.id} = ?',
              whereArgs: [e['android_customer_id']]);
        }
      }
    } catch (e) {
      log('>>>ERROR ON CUSTOMER UPLOAD SERVICE\n$e');
    }
  }
}
