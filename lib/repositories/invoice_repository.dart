import 'dart:developer';

import 'package:sales_force/database/tables/invoices_table.dart';
import 'package:sales_force/database/tables/paid_invoices_table.dart';
import 'package:sales_force/models/objects/customer.dart';
import 'package:sales_force/models/objects/invoice.dart';
import 'package:sales_force/repositories/customer_repository.dart';
import 'package:sales_force/shared/config.dart';
import 'package:sales_force/shared/constants.dart';
import 'package:sales_force/shared/library.dart';
import 'package:sqflite_common/sqlite_api.dart';
import 'package:meta/meta.dart';

class InvoiceRepo {
  static InvoiceRepo repo = InvoiceRepo._internal(database: Config.database);
  final Future<Database> database;
  InvoiceRepo._internal({this.database});

  Future<List<Invoice>> getInvoices(String userId) async {
    Database db = await database;
    List<Invoice> invoices = [];
    List<Map<String, dynamic>> list = await db.query(TableInvoices.tableName,
        where: '${TableInvoices.userId} = ?',
        whereArgs: [userId],
        orderBy: '${TableInvoices.id} desc');

    // List<Map<String, dynamic>> listTwo =
    //     await db.query(TablePaidInvoices.tableName, where: '${TablePaidInvoices.userId} = ?', whereArgs: [userId]);

    for (Map<String, dynamic> item in list) {
      Invoice inv = Invoice.withMap([item]);
      Customer customer = await CustomerRepo.repo.getCustomer(inv.customerId);
      inv.customerName = '${customer.firstName} ${customer.lastName}';
      invoices.add(inv);
    }
    return invoices;
  }

  Future<bool> payInvoice(
      {@required Invoice invoice,
      String bank = '',
      String chequeNo = '',
      @required String amount,
      String clearingDate = '',
      @required PAYMENTMODE paymentmode}) async {
    Database db = await Config.database;
    int rowsId = await db.insert(TablePaidInvoices.tableName, {
      TablePaidInvoices.userId: invoice.userId,
      TablePaidInvoices.orderId: invoice.orderId,
      TablePaidInvoices.invoiceId: invoice.invoiceId,
      TablePaidInvoices.customerId: invoice.customerId,
      TablePaidInvoices.amount: amount,
      TablePaidInvoices.paymentMode:
          paymentmode == PAYMENTMODE.CASH ? 'Cash' : 'Cheque',
      TablePaidInvoices.chequeNo: chequeNo,
      TablePaidInvoices.clearingDate: clearingDate,
      TablePaidInvoices.bank: bank,
      TablePaidInvoices.dateAdded: Library.getDateTime(),
      TablePaidInvoices.isUpload: 0,
    });
    await db.update(
        TableInvoices.tableName,
        {
          TableInvoices.paidAmount:
              '${double.parse(invoice.paidAmount) + double.parse(amount)}',
          TableInvoices.balance:
              '${double.parse(invoice.balance) - double.parse(amount)}'
        },
        where: '${TableInvoices.invoiceId} = ?',
        whereArgs: [invoice.invoiceId]);

    // log((await db.query(TableInvoices.tableName,
    //         where: '${TableInvoices.invoiceId} = ?',
    //         whereArgs: [invoice.invoiceId]))
    //     .toString());
    return rowsId > 0 ? true : false;
  }
}
