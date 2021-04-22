import 'package:sales_force/bloc/verbose_bloc/verbose_bloc.dart';
import 'package:sales_force/database/sql_commons.dart';
import 'package:sqflite_common/sqlite_api.dart';

class TableSyncApis extends SqlCommons {
  TableSyncApis(Database database, VerboseBloc bloc)
      : super(tableName, columns, dataTypes, database, bloc);
  static const String tableName = 'sync_apis';
  static const String id = 'id',
      serverId = 'server_id',
      module = 'module',
      operation = 'operation',
      url = 'url',
      createdOn = 'createdon',
      isUsed = 'is_used';
  static const List<String> columns = [
    id,
    serverId,
    module,
    operation,
    url,
    createdOn,
    isUsed
  ];
  static const List<String> dataTypes = [
    SqlCommons.INT_PRIMARYKEY,
    SqlCommons.INTEGER,
    SqlCommons.TEXT,
    SqlCommons.TEXT,
    SqlCommons.TEXT,
    SqlCommons.TEXT,
    SqlCommons.INTEGER,
  ];
}
