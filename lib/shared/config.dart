import 'package:flutter/cupertino.dart';
import 'package:sales_force/models/objects/user.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class Config {
  // ignore: non_constant_identifier_names
  static const int DATABASE_VERSION = 1;
  static const String DATABASE_NAME = 'SaleForce.db';
  static User user;
  static const String serverAddress = '72.52.142.19';
  static const String apiPrefix =
      'http://$serverAddress/ddf-pvt-ltd/webservice/';
  static const String installApi = apiPrefix + 'api.php?action=install';
  static String putInvoiceAPILink = apiPrefix +
      'api.php?action=put&module=invoice_payment&user=${user.userId}';
  static String putOrderVisitAPILink =
      apiPrefix + 'api.php?action=put&module=visit_order&user=${user.userId}';
  static String putTrackingAPILink =
      apiPrefix + 'api.php?action=put&module=tracking&user=${user.userId}';
  static String syncAPILink = apiPrefix + 'api.php?action=sync&createdon=';

  static const int ServiceCycleDelay = 10; // seconds
  static const int SplashTimeOut = 5; // seconds
  static const int ConnectionTimeout = 30; // seconds

  static double deviceDisplayWidth(BuildContext context) =>
      MediaQuery.of(context).size.width;

  static double deviceDisplayHeight(BuildContext context) =>
      MediaQuery.of(context).size.height;
  static Future<Database> get database async {
    if (_database == null) {
      return await openDatabase(await dbFullPath, singleInstance: true);
    } else {
      return _database;
    }
  }

  static set database(Future<Database> database) => _database = _database;
  static Database _database;
  static Future<String> get dbFullPath async =>
      join(await getDatabasesPath(), Config.DATABASE_NAME);
}
