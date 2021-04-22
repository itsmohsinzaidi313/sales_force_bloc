import 'package:sales_force/bloc/verbose_bloc/verbose_bloc.dart';
import 'package:sales_force/database/sql_commons.dart';
import 'package:sqflite_common/sqlite_api.dart';

class TableInvoices extends SqlCommons {
  TableInvoices(Database database, VerboseBloc bloc)
      : super(tableName, columns, dataTypes, database, bloc);

  static const String tableName = 'invoices';
  static const String id = 'id',
      invoiceId = 'invoice_id',
      orderId = 'order_id',
      customerId = 'customer_id',
      userId = 'user_id',
      number = 'invoice_number',
      date = 'invoice_date',
      amount = 'invoice_amount',
      discount = 'invoice_discount',
      totalAmount = 'invoice_total_amount',
      paidAmount = 'invoice_paid_amount',
      balance = 'invoice_balance',
      status = 'invoice_status',
      createdOn = 'createdon',
      modifiedOn = 'modifiedon';
  static const List<String> columns = [
    id,
    invoiceId,
    orderId,
    customerId,
    userId,
    number,
    date,
    amount,
    discount,
    totalAmount,
    paidAmount,
    balance,
    status,
    createdOn,
    modifiedOn
  ];
  static const List<String> dataTypes = [
    SqlCommons.INT_PRIMARYKEY,
    SqlCommons.INTEGER,
    SqlCommons.INTEGER,
    SqlCommons.INTEGER,
    SqlCommons.INTEGER,
    SqlCommons.TEXT,
    SqlCommons.TEXT,
    SqlCommons.REAL,
    SqlCommons.REAL,
    SqlCommons.REAL,
    SqlCommons.REAL,
    SqlCommons.REAL,
    SqlCommons.INTEGER,
    SqlCommons.TEXT,
    SqlCommons.TEXT,
  ];
}
