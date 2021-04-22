import 'package:sales_force/bloc/verbose_bloc/verbose_bloc.dart';
import 'package:sales_force/database/sql_commons.dart';
import 'package:sqflite_common/sqlite_api.dart';

class TableUsersType extends SqlCommons {
  TableUsersType(Database database, VerboseBloc bloc)
      : super(tableName, columns, dataTypes, database, bloc);

  static const tableName = 'users_types';
  static const String id = 'id',
      userTypeId = 'user_type_id',
      title = 'user_type_title',
      permissions = 'user_type_permissions';

  static const List<String> columns = [
    id,
    userTypeId,
    title,
    permissions,
  ];
  static const List<String> dataTypes = [
    SqlCommons.INT_PRIMARYKEY,
    SqlCommons.INTEGER,
    SqlCommons.TEXT,
    SqlCommons.INTEGER,
  ];

  @override
  Future<int> delete(List object) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future<bool> insert(List object) {
    // TODO: implement insert
    throw UnimplementedError();
  }

  @override
  Future<bool> select(List object) {
    // TODO: implement select
    throw UnimplementedError();
  }

  @override
  Future<bool> update(List object) {
    // TODO: implement update
    throw UnimplementedError();
  }
}
