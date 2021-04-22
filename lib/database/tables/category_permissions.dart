import 'package:sales_force/bloc/verbose_bloc/verbose_bloc.dart';
import 'package:sales_force/database/sql_commons.dart';
import 'package:sqflite_common/sqlite_api.dart';

class TableCategoryPermissions extends SqlCommons {
  TableCategoryPermissions(Database database, VerboseBloc bloc)
      : super(tableName, columns, dataTypes, database, bloc);

  static const String tableName = 'category_permissions';
  static const String id = 'id', categoryId = 'category_id', userId = 'user_id';
  static const List<String> columns = [id, categoryId, userId];
  static const List<String> dataTypes = [
    SqlCommons.INT_PRIMARYKEY,
    SqlCommons.INTEGER,
    SqlCommons.INTEGER
  ];
}
