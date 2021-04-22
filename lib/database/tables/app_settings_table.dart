import 'package:sales_force/bloc/verbose_bloc/verbose_bloc.dart';
import 'package:sales_force/database/sql_commons.dart';
import 'package:sqflite_common/sqlite_api.dart';

class TableAppSettings extends SqlCommons {
  TableAppSettings(Database database, VerboseBloc bloc)
      : super(tableName, columns, dataTypes, database, bloc);
  static const String tableName = 'app_settings';
  static const String id = 'id', syncDate = 'sync_date';
  static const List<String> columns = [id, syncDate];
  static const List<String> dataTypes = [
    SqlCommons.INT_PRIMARYKEY,
    SqlCommons.TEXT
  ];
}
