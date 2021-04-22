import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:sales_force/bloc/verbose_bloc/verbose_bloc.dart';
import 'package:sales_force/database/sql.dart';
import 'package:sales_force/database/tables/users_table.dart';
import 'package:sales_force/json_decode/import_data.dart';
import 'package:sales_force/shared/config.dart';
import 'package:sqflite/sqflite.dart';

class Library {
  static Future<bool> hasServerAccess() async {
    try {
      final result = await InternetAddress.lookup(Config.serverAddress)
          .timeout(Duration(seconds: 5), onTimeout: () => null)
          .catchError((onError) => null);
      if (result != null) {
        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
          //log.v('GAINED SERVER ACCESS');
          return true;
        } else {
          //log.v('LOST SERVER ACCESS');
          return false;
        }
      } else {
        log('SERVER OFFLINE');
        return false;
      }
    } catch (e) {
      log('ERROR ON LIBRARY hasServerAccess', error: e);
      return false;
    }
  }

  static String getDateTime() {
    DateFormat formatter = new DateFormat('yyyy-MM-dd HH:mm:ss');
    return formatter.format(DateTime.now());
  }

  static String getDate() {
    DateFormat formatter = new DateFormat('yyyy-MM-dd');
    return formatter.format(DateTime.now());
  }

  static Future<ImportData> fetchData({VerboseBloc bloc}) async {
    try {
      Response response = await get(Uri.parse(Config.installApi));
      log('SERVER RESPONSE: ${response.statusCode}');
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        log('STATUS:\n${data['status']}');
        log('MESSAGE:\n${data['message']}');
        return ImportData(
            status: data['status'].toString(),
            message: data['message'].toString(),
            data: data['data'],
            bloc: bloc);
      }
      return null;
    } catch (e) {
      log('ERROR ON fetchData', error: e);
      return null;
    }
  }

  static Future<void> install(BuildContext context,
      {bool reinstall = false, bool forceUpdate = false}) async {
    if (reinstall) {
      await deleteDatabase(await Config.dbFullPath);
    }
    final sql = Sql(bloc: context.read<VerboseBloc>());
    bool status = await databaseExists(await Config.dbFullPath);
    if (!status || forceUpdate) {
      if (forceUpdate) {
        sql.deleteAllTables(await Config.database);
      }
      await sql.initDatabase(await Config.database); // CREATES/UPGRADES DATABASE
      final import = await Library.fetchData(
          bloc: context
              .read<VerboseBloc>()); // FETCHES DATA AND INSTANCIATES ImportData
      bool x = await import
          .init(await Config.database); // WRITES FETCHED DATA TO DATABASE
      if (x) {
        await Future.delayed(Duration(seconds: 2));
        context.read<VerboseBloc>().add(VerboseNewEvent(
            title: '', message: 'Installation completed successfully.'));
      } else {
        await Future.delayed(Duration(seconds: 2));
        context
            .read<VerboseBloc>()
            .add(VerboseNewEvent(title: '', message: 'Installation failed.'));
      }
    } else {
      context
          .read<VerboseBloc>()
          .add(VerboseNewEvent(title: 'SQL', message: 'Database installed'));
      await Future.delayed(Duration(seconds: 2));
      context
          .read<VerboseBloc>()
          .add(VerboseNewEvent(title: '', message: 'Please Wait...'));
    }
  }

  static Future<Database> getDatabase() async {
    String dbStorage = await getDatabasesPath();
    String path = join(dbStorage, Config.DATABASE_NAME);
    Future<Database> fDB = openDatabase(path, singleInstance: false);
    return fDB;
  }

  static Future<bool> validateUser(String email, String password) async {
    try {
      List<int> xx = utf8.encode(password);
      Digest digest = md5.convert(xx);
      password = digest.toString();
      Database db = await getDatabase();
      String table = 'users';
      List<String> columns = ['id'];
      String where = 'user_email_address = ? and user_password = ?';
      List<String> whereArgs = [email, password];
      List<Map> x = await db.query(table,
          columns: columns, where: where, whereArgs: whereArgs);
      if (x.isNotEmpty) {
        login(email);
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }

  static Future<bool> logout(String userId) async {
    try {
      Database db = await Library.getDatabase();
      db.update(TableUsers.tableName, {TableUsers.loginStatus: 0},
          where: '${TableUsers.userId} = ?', whereArgs: [int.parse(userId)]);
      return true;
    } catch (e) {
      log('ERROR ON LIBRARY.logout', error: e);
      return false;
    }
  }

  static Future<bool> login(String email) async {
    try {
      Database db = await Library.getDatabase();
      await db.update(TableUsers.tableName, {TableUsers.loginStatus:1},
          where: '${TableUsers.email} = ?', whereArgs: [email]);
      return true;
    } catch (e) {
      log('ERROR ON LIBRARY.login Login', error: e);
      return false;
    }
  }

  static Future<bool> uploadToServer(String url, {String jsonString}) async {
    try {
      bool status = false;
      Response onPost;
      Map<String, String> header = {
        'content-type': 'application/x-www-form-urlencoded'
      };
      bool hasServerAccess = await Library.hasServerAccess();
      if (jsonString != null && hasServerAccess) {
        onPost = await post(Uri.parse(url),
                headers: header, body: {'json': jsonString})
            .timeout(Duration(seconds: 5), onTimeout: () => null)
            .catchError(
                (onError) => log('ERROR ON uploadToServer', error: onError));

        // if (url == Config.putTrackingAPILink) log('LOCATION SENT');
        // if (url == Config.putInvoiceAPILink) log('INVOICE SENT');
        // if (url == Config.putOrderVisitAPILink) log('ORDER SENT');
        // if (url == Config.putOrderVisitAPILink) log('VISIT SENT');
        if (onPost != null) {
          Map response = jsonDecode(onPost.body);
          //_log.i('ENTRY SERVER UPLOAD');
          //print('STATUS CODE: ${onValue.statusCode}');
          log('SERVER REPLY\nSTATUS: ${response['status'].toString().toUpperCase()}\nDATA: ${response['data']}');
          if (response['status'].toString().contains('success')) status = true;
          //print('MESSAGE: ${response['message'].toString().toUpperCase()}');
          //log.i('DATA: ${response['data']}');
          //_log.i('EXIT SERVER UPLOAD');
        }
      }
      return status;
    } catch (e) {
      log('ERROR ON uploadToServer', error: e);
      return false;
    }
  }
}
