import 'package:sales_force/bloc/verbose_bloc/verbose_bloc.dart';
import 'package:sales_force/database/sql_commons.dart';
import 'package:sqflite_common/sqlite_api.dart';

class TableOrderMaster extends SqlCommons {
  TableOrderMaster(Database database, VerboseBloc bloc)
      : super(tableName, columns, dataTypes, database, bloc) {
        skipDelete = true;
      }
  static const String tableName = 'order_master';
  static const String id = 'id',
      userId = 'user_id',
      customerId = 'customer_id',
      amount = 'order_amount',
      discount = 'order_discount',
      total = 'order_total',
      orderType = 'order_type_id',
      status = 'order_status',
      deliveryDate = 'order_delivery_date',
      spoDiscount = 'spo_discount',
      createdOn = 'createdon';
  static const List<String> columns = [
    id,
    userId,
    customerId,
    amount,
    discount,
    total,
    orderType,
    status,
    deliveryDate,
    spoDiscount,
    createdOn
  ];
  static const List<String> dataTypes = [
    SqlCommons.INT_PRIMARYKEY,
    SqlCommons.INTEGER,
    SqlCommons.INTEGER,
    SqlCommons.REAL,
    SqlCommons.REAL,
    SqlCommons.REAL,
    SqlCommons.INTEGER,
    SqlCommons.INTEGER,
    SqlCommons.TEXT,
    SqlCommons.REAL,
    SqlCommons.TEXT,
  ];
}
