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
import 'package:sales_force/database/tables/customer_table.dart';
import 'package:sales_force/database/tables/users_table.dart';
import 'package:sales_force/shared/import_data.dart';
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

  static Future<ImportData> fetchInstallationData({VerboseBloc bloc}) async {
    try {
      Response response = await get(Uri.parse(Config.installApi)).timeout(
          Duration(seconds: Config.ConnectionTimeout),
          onTimeout: () => null);
      log(Config.installApi, name: 'fetchData');
      log('SERVER RESPONSE: ${response.statusCode}', name: 'Library.fetchData');
      if (response != null && response.statusCode == 200) {
        final data = jsonDecode(response.body);
        log('STATUS:${data['status']} MESSAGE:${data['message']}',
            name: 'Library.fetchData');
        return ImportData(
            status: data['status'].toString(),
            message: data['message'].toString(),
            data: data['data'],
            bloc: bloc);
      }
      return ImportData(
          status: 'failure',
          message: 'Server Error\nStatusCode: ${response.statusCode}',
          data: {});
    } catch (e) {
      log('ERROR ON fetchData', error: e);
      return null;
    }
  }

  static Future<ImportData> fetchSyncData({VerboseBloc bloc}) async {
    try {
      DateTime dateTime = DateTime.now();
      String url =
          '${Config.syncAPILink}${DateFormat('yyyy-MM-dd,HH:mm:ss').format(dateTime)}';
      Response response = await get(Uri.parse(url))
          .timeout(Duration(seconds: Config.ConnectionTimeout),
              onTimeout: () => null)
          .onError((error, stackTrace) {
        log('fetchSyncData', error: error);
        return null;
      });
      // log(url, name: 'fetchSyncData');
      log('SERVER RESPONSE: ${response.statusCode}',
          name: 'Library.fetchSyncData');
      if (response != null && response.statusCode == 200) {
        final data = jsonDecode(response.body);
        log('STATUS:${data['status']} MESSAGE:${data['message']}',
            name: 'Library.fetchSyncData');
        return ImportData(
            status: data['status'].toString(),
            message: data['message'].toString(),
            data: data['data'],
            bloc: bloc);
      }
      return ImportData(
          status: 'failure',
          message: 'Server Error\nStatusCode: ${response.statusCode}',
          data: {});
    } catch (e) {
      log('ERROR ON fetchSyncData', error: e);
      return null;
    }
  }

  /// Creates database on the device
  /// When [reinstall] parameter is true, all tables will be dropped and recreated
  /// When [forceUpdate] is true all tables will be deleted (except the tables defined as skip) and all record is imported from web server
  static Future<bool> install(BuildContext context,
      {bool reinstall = false, bool forceUpdate = false}) async {
    if (reinstall) {
      await deleteDatabase(await Config.dbFullPath);
    }
    final sql = Sql(bloc: context.read<VerboseBloc>());
    bool status = await databaseExists(await Config.dbFullPath);
    if (!status || forceUpdate) {
      if (forceUpdate) {
        await sql.deleteAllTables(await Config.database);
      }
      await sql.initDatabase(); // CREATES/UPGRADES DATABASE
      final import = await Library.fetchInstallationData(
          bloc: context
              .read<VerboseBloc>()); // FETCHES DATA AND INSTANCIATES ImportData
      if (import.status == 'success') {
        bool x = await import
            .init(await Config.database); // WRITES FETCHED DATA TO DATABASE
        if (x) {
          await Future.delayed(Duration(seconds: 2));
          context.read<VerboseBloc>().add(
              VerboseNewEvent(title: '', message: 'Installation successful.'));
          log('Installation completed', name: 'Library.install');
          // try {
          //   final syncImport =
          //       await fetchSyncData(bloc: context.read<VerboseBloc>());
          //   if (syncImport.status == 'success') {
          //     x = await import.importSync(await Config.database);
          //     if (x) {
          //       await Future.delayed(Duration(seconds: 2));
          //       context.read<VerboseBloc>().add(
          //           VerboseNewEvent(title: '', message: 'Sync successful.'));
          //     } else {
          //       await Future.delayed(Duration(seconds: 2));
          //       context
          //           .read<VerboseBloc>()
          //           .add(VerboseNewEvent(title: '', message: 'Sync failed.'));
          //     }
          //   }
          // } catch (e) {
          //   await Future.delayed(Duration(seconds: 2));
          //   VerboseNewEvent(title: '', message: e.toString());
          // }
          return true;
        } else {
          await Future.delayed(Duration(seconds: 2));
          context
              .read<VerboseBloc>()
              .add(VerboseNewEvent(title: '', message: 'Installation failed.'));
          log('Installation failed', name: 'Library.install');
        }
      } else {
        context
            .read<VerboseBloc>()
            .add(VerboseNewEvent(title: '', message: import.message));
        log(import.message, name: 'Library.install');
      }
    } else {
      context
          .read<VerboseBloc>()
          .add(VerboseNewEvent(title: 'SQL', message: 'Database installed'));
      await Future.delayed(Duration(seconds: 2));
      context
          .read<VerboseBloc>()
          .add(VerboseNewEvent(title: '', message: 'Please Wait...'));
      return true;
    }
    return false;
  }

  static Future<bool> logout(String userId) async {
    try {
      Database db = await Config.database;
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
      Database db = await Config.database;
      await db.update(TableUsers.tableName, {TableUsers.loginStatus: 1},
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
            .timeout(Duration(seconds: Config.ConnectionTimeout),
                onTimeout: () => null)
            .catchError((onError) {
          log('ERROR ON uploadToServer', error: onError);
          return null;
        });

        // if (url == Config.putTrackingAPILink) log('LOCATION SENT');
        // if (url == Config.putInvoiceAPILink) log('INVOICE SENT');
        // if (url == Config.putOrderVisitAPILink) log('ORDER SENT');
        // if (url == Config.putOrderVisitAPILink) log('VISIT SENT');
        if (onPost != null) {
          Map response = jsonDecode(onPost.body);
          //_log.i('ENTRY SERVER UPLOAD');
          //print('STATUS CODE: ${onValue.statusCode}');
          log('SERVER REPLY\nSTATUS: ${response['status'].toString().toUpperCase()}\nMESSAGE: ${response['message'].toString().toUpperCase()}\nDATA: ${response['data']}',
              name: 'uploadToServer');
          if (response['status'].toString().contains('success')) status = true;
          //print('MESSAGE: ${response['message'].toString().toUpperCase()}');
          //log.i('DATA: ${response['data']}');
          //_log.i('EXIT SERVER UPLOAD');
          if (status && url == Config.createCustomerAPILink) {
            Map<String, dynamic> map = jsonDecode(jsonString);
            (await Config.database).update(TableCustomer.tableName,
                {TableCustomer.customerId: response['data']['customer_id']},
                where: '${TableCustomer.id} = ?',
                whereArgs: [map['android_customer_id']]);
          }
        }
      }
      return status;
    } catch (e) {
      log('ERROR ON uploadToServer', error: e);
      return false;
    }
  }
}
