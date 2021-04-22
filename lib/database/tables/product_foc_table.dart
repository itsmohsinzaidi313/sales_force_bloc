import 'package:sales_force/bloc/verbose_bloc/verbose_bloc.dart';
import 'package:sales_force/database/sql_commons.dart';
import 'package:sqflite_common/sqlite_api.dart';

class TableProductFOC extends SqlCommons {
  TableProductFOC(Database database, VerboseBloc bloc)
      : super(tableName, columns, dataTypes, database, bloc);
  static const String tableName = 'product_foc';
  static const String id = 'id',
      productId = 'product_id',
      start = 'start',
      end = 'end',
      quantity = 'quantity';
  static const List<String> columns = [id, productId, start, end, quantity];
  static const List<String> dataTypes = [
    SqlCommons.INT_PRIMARYKEY,
    SqlCommons.INTEGER,
    SqlCommons.INTEGER,
    SqlCommons.INTEGER,
    SqlCommons.INTEGER,
  ];
}
