import 'package:sales_force/bloc/verbose_bloc/verbose_bloc.dart';
import 'package:sales_force/database/sql_commons.dart';
import 'package:sqflite/sqflite.dart';

class TableUsers extends SqlCommons {
  TableUsers(Database database, VerboseBloc bloc)
      : super(tableName, columns, dataTypes, database, bloc);
  static const String tableName = 'users';
  static const String id = 'id',
      userId = 'user_id',
      userTypeid = 'user_type_id',
      distributorId = 'distributor_id',
      firstName = 'user_first_name',
      lastName = 'user_last_name',
      email = 'user_email_address',
      password = 'user_password',
      phone = 'user_phone_number',
      mobile = 'user_mobile_number',
      status = 'user_status',
      loginStatus = 'login_status',
      discountP = 'discount_percent',
      createdOn = 'createdon',
      modifiedOn = 'modifiedOn';

  static const List<String> columns = [
    id,
    userId,
    userTypeid,
    distributorId,
    firstName,
    lastName,
    email,
    password,
    phone,
    mobile,
    status,
    loginStatus,
    discountP,
    createdOn,
    modifiedOn
  ];
  static const List<String> dataTypes = [
    SqlCommons.INT_PRIMARYKEY,
    SqlCommons.INTEGER,
    SqlCommons.INTEGER,
    SqlCommons.INTEGER,
    SqlCommons.TEXT,
    SqlCommons.TEXT,
    SqlCommons.TEXT,
    SqlCommons.TEXT,
    SqlCommons.TEXT,
    SqlCommons.TEXT,
    SqlCommons.INTEGER,
    SqlCommons.INTEGER,
    SqlCommons.INTEGER,
    SqlCommons.TEXT,
    SqlCommons.TEXT,
  ];
}
