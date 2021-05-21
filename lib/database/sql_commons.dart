import 'dart:developer';

import 'package:sales_force/bloc/verbose_bloc/verbose_bloc.dart';
import 'package:sqflite/sqflite.dart';

abstract class SqlCommons {
  static const String TEXT = 'TEXT';
  static const String INTEGER = 'INTEGER';
  static const String BLOB = 'BLOB';
  static const String REAL = 'REAL';
  static const String NUMERIC = 'NUMERIC';
  static const String PRIMARYKEY = ' PRIMARY KEY';
  static const INT_PRIMARYKEY = INTEGER + PRIMARYKEY;

  Database database;
  final String dbTableName;
  final VerboseBloc bloc;
  SqlCommons(this.dbTableName, this.dbColumns, this.dbColumnsDataTypes,
      this.database, this.bloc);
  List<String> dbColumns;
  List<String> dbColumnsDataTypes;
  bool skipDelete = false;
  bool skipDrop = false;

  Future<void> create() async {
    try {
      log('TABLE $dbTableName CREATED', name: 'SqlCommons');
      String query = 'CREATE TABLE IF NOT EXISTS $dbTableName (';
      for (int i = 0; i < dbColumns.length; i++) {
        query += '${dbColumns[i]} ${dbColumnsDataTypes[i]},';
      }
      query = query.substring(0, query.length - 1);
      query += ');';
      await database.execute(query);
      bloc.add(VerboseNewEvent(
          title: 'SqlCommons', message: 'Table created $dbTableName'));
    } catch (e) {
      log('SqlCommons', error: e);
    }
  }

  Future<void> drop() async {
    if (!skipDrop) {
      log('TABLE $dbTableName DROPPED', name: 'SqlCommons');
      await database.execute('DROP TABLE IF EXISTS $dbTableName');
      bloc.add(VerboseNewEvent(
          title: 'SqlCommons', message: 'Table dropped $dbTableName'));
    } else {
      log('TABLE $dbTableName DROP SKIPPED', name: 'SqlCommons');
    }
  }

  Future<void> deleteTable() async {
    if (!skipDelete) {
      log('TABLE $dbTableName DELETED', name: 'SqlCommons');
      int rowsAffected = await database.delete(dbTableName);
      bloc.add(VerboseNewEvent(
          title: 'SqlCommons', message: 'Table deleted $dbTableName'));
      // return rowsAffected;
    } else {
      log('TABLE $dbTableName DELETE SKIPPED', name: 'SqlCommons');
    }
  }

  bool verify() {
    if (this.dbColumns.length == this.dbColumnsDataTypes.length) {
      bloc.add(
          VerboseNewEvent(title: 'SqlCommons', message: '$dbTableName OK'));
      log('TABLE OK', name: 'SqlCommons');
      return true;
    } else {
      bloc.add(VerboseError(message: '$dbTableName has invalid Column/Type'));
      throw Exception(
          'TABLE $dbTableName IS INVALID.\ndbColumns.length == dbColumnsDataTypes.length SHOULD BE TRUE\nCOLUMNS/TYPES => ${dbColumns.length}/${dbColumnsDataTypes.length}');
    }
  }

  void dispose() => database.close();
}
