import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:sales_force/database/tables/users_table.dart';
import 'package:sales_force/models/objects/user.dart';
import 'package:sales_force/shared/config.dart';
import 'package:sqflite/sqflite.dart';

class LoginRepo {
  static LoginRepo repo = LoginRepo._internal(Config.database);
  final Future<Database> database;
  LoginRepo._internal(this.database);

  Future<User> login(String email, String password) async {
    String key = md5.convert(utf8.encode(password)).toString();
    List<Map<String, dynamic>> list = await (await database).query(
        TableUsers.tableName,
        where: '${TableUsers.email} = ? and ${TableUsers.password} = ?',
        whereArgs: [email, key],
        columns: [TableUsers.userId]);
    if (list.length == 0) {
      return null;
    } else {
      await (await database).update(
          TableUsers.tableName, {TableUsers.loginStatus: '1'},
          where: '${TableUsers.email} = ?', whereArgs: [email]);
      return list.map((e) => User.withMap([e])).first;
    }
  }

  Future<bool> logout() async => (await (await database)
              .update(TableUsers.tableName, {TableUsers.loginStatus: '0'})) >
          0
      ? true
      : false;

  Future<User> getLastLogin() async {
    List<Map<String, dynamic>> list = await (await database).query(
        TableUsers.tableName,
        where: '${TableUsers.loginStatus} = ?',
        whereArgs: [1]);
    if (list.isEmpty) {
      return User(userId: '0', email: '', password: '');
    } else {
      User user = User.withMap(list);
      return user;
    }
  }
}
