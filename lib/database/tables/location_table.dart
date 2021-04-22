import 'package:sales_force/bloc/verbose_bloc/verbose_bloc.dart';
import 'package:sales_force/database/sql_commons.dart';
import 'package:sqflite_common/sqlite_api.dart';

class TableLocation extends SqlCommons {
  TableLocation(Database database, VerboseBloc bloc)
      : super(tableName, columns, dataTypes, database, bloc);
  static const String tableName = 'location';
  static const String id = 'id',
      userId = 'user_id',
      time = 'time',
      lat = 'lat',
      long = 'long';
  static const List<String> columns = [id, userId, time, lat, long];
  static const List<String> dataTypes = [
    SqlCommons.INT_PRIMARYKEY,
    SqlCommons.INTEGER,
    SqlCommons.TEXT,
    SqlCommons.REAL,
    SqlCommons.REAL
  ];
}
