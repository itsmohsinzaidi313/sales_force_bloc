import 'package:sales_force/bloc/verbose_bloc/verbose_bloc.dart';
import 'package:sales_force/database/sql_commons.dart';
import 'package:sqflite_common/sqlite_api.dart';

class TableProductPrices extends SqlCommons {
  
  TableProductPrices(Database database, VerboseBloc bloc) : super(tableName, columns, dataTypes, database, bloc);

  static const tableName = 'product_prices';
  static const String id = 'id',
      productToCustomerGroupId = 'product_to_customer_group_id',
      productId = 'product_id',
      customerGroupId = 'customer_group_id',
      cashPrice = 'cash_price',
      creditPrice = 'credit_price'
      ;

  static const List<String> columns = [
    id,
    productToCustomerGroupId,
    productId,
    customerGroupId,
    cashPrice,
    creditPrice,
  ];
  static const List<String> dataTypes = [
    SqlCommons.INT_PRIMARYKEY,
    SqlCommons.INTEGER,
    SqlCommons.INTEGER,
    SqlCommons.INTEGER,
    SqlCommons.REAL,
    SqlCommons.REAL,
  ];

}
