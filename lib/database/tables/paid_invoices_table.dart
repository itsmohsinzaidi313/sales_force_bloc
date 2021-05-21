import 'package:sales_force/bloc/verbose_bloc/verbose_bloc.dart';
import 'package:sales_force/database/sql_commons.dart';
import 'package:sqflite_common/sqlite_api.dart';

class TablePaidInvoices extends SqlCommons {
  TablePaidInvoices(Database database, VerboseBloc bloc)
      : super(tableName, columns, dataTypes, database, bloc){
        skipDelete = true;
      }
  static const tableName = 'paid_invoices';
  static const String id = 'id',
      userId = 'payment_user_id',
      orderId = 'payment_order_id',
      invoiceId = 'payment_invoice_id',
      customerId = 'payment_customer_id',
      amount = 'payment_amount',
      paymentMode = 'payment_mode',
      chequeNo = 'payment_cheque_no',
      clearingDate = 'payment_clearing_date',
      bank = 'payment_bank_name',
      dateAdded = 'date_added',
      isUpload = 'is_upload';
  static const List<String> columns = [
    id,
    userId,
    orderId,
    invoiceId,
    customerId,
    amount,
    paymentMode,
    chequeNo,
    clearingDate,
    bank,
    dateAdded,
    isUpload
  ];
  static const List<String> dataTypes = [
    SqlCommons.INT_PRIMARYKEY,
    SqlCommons.INTEGER,
    SqlCommons.INTEGER,
    SqlCommons.INTEGER,
    SqlCommons.INTEGER,
    SqlCommons.REAL,
    SqlCommons.TEXT,
    SqlCommons.TEXT,
    SqlCommons.TEXT,
    SqlCommons.TEXT,
    SqlCommons.TEXT,
    SqlCommons.INTEGER,
  ];
}
