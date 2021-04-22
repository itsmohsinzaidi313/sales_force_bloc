import 'package:sales_force/bloc/verbose_bloc/verbose_bloc.dart';
import 'package:sales_force/database/sql_commons.dart';
import 'package:sqflite_common/sqlite_api.dart';

class TableCustomerGroups extends SqlCommons {
  TableCustomerGroups(Database database, VerboseBloc bloc)
      : super(tableName, columns, dataTypes, database, bloc);

  static const String tableName = 'customer_groups';
  static const String id = 'id',
      customerGroupId = 'customer_group_id',
      name = 'name';
  static const List<String> columns = [
    id,
    customerGroupId,
    name,
  ];
  static const List<String> dataTypes = [
    SqlCommons.INT_PRIMARYKEY,
    SqlCommons.INTEGER,
    SqlCommons.TEXT,
  ];
}
