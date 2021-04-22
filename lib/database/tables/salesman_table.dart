import 'package:sales_force/bloc/verbose_bloc/verbose_bloc.dart';
import 'package:sales_force/database/sql_commons.dart';
import 'package:sqflite_common/sqlite_api.dart';

class TableSalesman extends SqlCommons {
  TableSalesman(Database database, VerboseBloc bloc)
      : super(tableName, columns, dataTypes, database, bloc);
  static const tableName = 'salesmen';
  static const String id = 'id',
      salesmanId = 'category_to_salesman_id',
      categoryId = 'product_category_id',
      userId = 'user_id';
  static const List<String> columns = [id, salesmanId, categoryId, userId];
  static const List<String> dataTypes = [
    SqlCommons.INT_PRIMARYKEY,
    SqlCommons.INTEGER,
    SqlCommons.INTEGER,
    SqlCommons.INTEGER,
  ];
}
