import 'package:sales_force/bloc/verbose_bloc/verbose_bloc.dart';
import 'package:sales_force/database/sql_commons.dart';
import 'package:sqflite_common/sqlite_api.dart';

class TableCustomer extends SqlCommons {
  TableCustomer(Database database, VerboseBloc bloc)
      : super(tableName, columns, dataTypes, database, bloc);
  static const String tableName = 'customer';
  static const String id = 'id',
      customerId = 'customer_id',
      customerGroupId = 'customer_group_id',
      userId = 'user_id',
      countryId = 'country_id',
      cityId = 'city_id',
      stateId = 'state_id',
      areaId = 'area_id',
      firstName = 'customer_first_name',
      lastName = 'customer_last_name',
      email = 'customer_email',
      phone = 'customer_phone',
      mobile = 'customer_mobile',
      shopName = 'customer_shop_name',
      address = 'customer_address1',
      status = 'status',
      discountType = 'discount_type',
      discount = 'discount',
      shopLat = 'shop_board_lat',
      shopLong = 'shop_board_long',
      creditLimit = 'credit_limit';
      
  static const List<String> columns = [
    id,
    customerId,
    customerGroupId,
    userId,
    countryId,
    cityId,
    stateId,
    areaId,
    firstName,
    lastName,
    email,
    phone,
    mobile,
    shopName,
    address,
    status,
    discountType,
    discount,
    creditLimit,
    shopLat,
    shopLong,
  ];
  static const List<String> dataTypes = [
    SqlCommons.INT_PRIMARYKEY,
    SqlCommons.INTEGER,
    SqlCommons.INTEGER,
    SqlCommons.INTEGER,
    SqlCommons.INTEGER,
    SqlCommons.INTEGER,
    SqlCommons.INTEGER,
    SqlCommons.INTEGER,
    SqlCommons.TEXT,
    SqlCommons.TEXT,
    SqlCommons.TEXT,
    SqlCommons.TEXT,
    SqlCommons.TEXT,
    SqlCommons.TEXT,
    SqlCommons.TEXT,
    SqlCommons.INTEGER,
    SqlCommons.REAL,
    SqlCommons.REAL,
    SqlCommons.REAL,
    SqlCommons.REAL,
    SqlCommons.REAL,
  ];
}
