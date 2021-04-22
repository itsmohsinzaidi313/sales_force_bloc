import 'package:sales_force/bloc/verbose_bloc/verbose_bloc.dart';
import 'package:sales_force/database/sql_commons.dart';
import 'package:sqflite_common/sqlite_api.dart';

class TableVisits extends SqlCommons {
  TableVisits(Database database, VerboseBloc bloc)
      : super(tableName, columns, dataTypes, database, bloc);

  static const String tableName = 'visits';
  static const String id = 'id',
      customerId = 'customer_id',
      userId = 'user_id',
      latitude = 'lat',
      longitude = 'long',
      isOrder = 'isOrder',
      createdOn = 'createdon',
      isUpload = 'is_upload',
      orderId = 'order_id';
  static const List<String> columns = [id, customerId, userId, latitude, longitude, isOrder, createdOn, isUpload, orderId];
  static const List<String> dataTypes = [
    SqlCommons.INT_PRIMARYKEY,
    SqlCommons.INTEGER,
    SqlCommons.INTEGER,
    SqlCommons.REAL,
    SqlCommons.REAL,
    SqlCommons.INTEGER,
    SqlCommons.TEXT,
    SqlCommons.INTEGER,
    SqlCommons.INTEGER,
  ];
}
