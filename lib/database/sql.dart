import 'dart:async';
import 'dart:developer';

import 'package:permission_handler/permission_handler.dart';
import 'package:sales_force/bloc/verbose_bloc/verbose_bloc.dart';
import 'package:sales_force/database/sql_commons.dart';
import 'package:sales_force/database/tables/app_settings_table.dart';
import 'package:sales_force/database/tables/categories_table.dart';
import 'package:sales_force/database/tables/category_permissions.dart';
import 'package:sales_force/database/tables/customer_groups_table.dart';
import 'package:sales_force/database/tables/customer_table.dart';
import 'package:sales_force/database/tables/invoices_table.dart';
import 'package:sales_force/database/tables/location_table.dart';
import 'package:sales_force/database/tables/order_detail_table.dart';
import 'package:sales_force/database/tables/order_master_table.dart';
import 'package:sales_force/database/tables/paid_invoices_table.dart';
import 'package:sales_force/database/tables/product_foc_table.dart';
import 'package:sales_force/database/tables/product_prices_table.dart';
import 'package:sales_force/database/tables/products_table.dart';
import 'package:sales_force/database/tables/salesman_table.dart';
import 'package:sales_force/database/tables/sync_apis_table.dart';
import 'package:sales_force/database/tables/users_table.dart';
import 'package:sales_force/database/tables/users_type_table.dart';
import 'package:sales_force/database/tables/visits_table.dart';
import 'package:sales_force/shared/config.dart';
import 'package:sales_force/shared/library.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class Sql {
  VerboseBloc _bloc;
  Database _database;
  Sql({VerboseBloc bloc}) {
    _bloc = bloc;
  }

  List<SqlCommons> tables(Database db, VerboseBloc bloc) => [
        TableAppSettings(db, bloc),
        TableCategories(db, bloc),
        TableCategoryPermissions(db, bloc),
        TableCustomerGroups(db, bloc),
        TableCustomer(db, bloc),
        TableInvoices(db, bloc),
        TableOrderDetail(db, bloc),
        TableOrderMaster(db, bloc),
        TablePaidInvoices(db, bloc),
        TableProductFOC(db, bloc),
        TableProductPrices(db, bloc),
        TableProducts(db, bloc),
        TableSalesman(db, bloc),
        TableSyncApis(db, bloc),
        TableUsers(db, bloc),
        TableUsersType(db, bloc),
        TableVisits(db, bloc),
        TableLocation(db, bloc),
      ];

  Future<void> initDatabase(Database database) async {
    try {
      _database = database;
      PermissionStatus status = await Permission.storage.request();

      if (status.isGranted) {
        if (Config.DATABASE_NAME != '') {
          String databasePath = await getDatabasesPath();
          databasePath = join(databasePath, Config.DATABASE_NAME);
          _database = await openDatabase(databasePath,
              singleInstance: true,
              version: Config.DATABASE_VERSION,
              onCreate: onCreate,
              onUpgrade: onUpgrade,
              onDowngrade: onDownGrade);
          Config.database = Future.value(_database);
          int version = await _database.getVersion();
          _bloc.add(VerboseNewEvent(
              title: 'SQL',
              message: 'Database Version: ${version.toString()}'));
        } else {
          throw Exception(
            'DATABASE NAME CANNOT BE EMPTY',
          );
        }
      }
    } catch (e) {
      _bloc.add(VerboseNewEvent(title: 'SQL', message: e.toString()));
      log('SQL', error: e);
    }
  }

  Future<FutureOr<void>> onCreate(Database db, int version) async {
    if (version == 1) {
      log('DATABASE CREATED. VERSION: $version', name: 'onCreate');
      for (SqlCommons table in tables(db, _bloc)) {
        if (table.verify()) {
          await table.create();
        }
      }
    }
  }

  FutureOr<void> onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (newVersion > oldVersion) {
      log('DATABASE UPGRADED. VERSION: $oldVersion => $newVersion',
          name: 'onUpgrade');
      for (SqlCommons table in tables(db, _bloc)) {
        if (table.verify()) {
          await table.drop();
          await table.create();
        }
      }
    }
  }

  FutureOr<void> onDownGrade(
      Database db, int oldVersion, int newVersion) async {
    if (newVersion < oldVersion) {
      log('DATABASE DOWNGRADED. VERSION: $oldVersion => $newVersion',
          name: 'onDownGrade');
      for (SqlCommons table in tables(db, _bloc)) {
        if (table.verify()) {
          await table.drop();
          await table.create();
        }
      }
    }
  }

  Future<void> deleteAllTables(Database database) async {
    _database = database;
    for (SqlCommons table in tables(_database, _bloc)) {
      await table.deleteTable();
    }
  }
}
