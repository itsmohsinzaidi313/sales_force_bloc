import 'dart:convert';
import 'dart:developer';

import 'package:sales_force/database/tables/paid_invoices_table.dart';
import 'package:sales_force/shared/library.dart';
import 'package:sales_force/services/service_common.dart';
import 'package:sqflite/sqflite.dart';

import '../shared/config.dart';

class SPostInvoice extends ServiceCommon {
  @override
  String get name => 'Invoice Service';

  @override
  Future<void> perform() async {
    cycleComplete = false;
    _uploadInvoices();
  }

  Database db;

  SPostInvoice(Database db) {
    this.db = db;
    initiate();
  }

  void _uploadInvoices() async {
    try {
      List<Map<String, dynamic>> invoices = await db.query(
          TablePaidInvoices.tableName,
          columns: [
            '${TablePaidInvoices.id} as android_payment_id',
            TablePaidInvoices.userId,
            TablePaidInvoices.orderId,
            TablePaidInvoices.invoiceId,
            TablePaidInvoices.customerId,
            TablePaidInvoices.amount,
            TablePaidInvoices.paymentMode,
            TablePaidInvoices.chequeNo,
            TablePaidInvoices.clearingDate,
            TablePaidInvoices.bank,
            TablePaidInvoices.dateAdded
          ],
          where:
              '${TablePaidInvoices.userId} = ? and ${TablePaidInvoices.isUpload} = ?',
          whereArgs: [Config.user.userId, '0']);

      if (invoices != null) {
        invoices.forEach((inv) async {
          Map<String, String> packet = {
            '${jsonEncode('invoice_payment')}': '[${jsonEncode(inv)}]'
          };
          bool status = false;
          if (packet != null) {
            status = await Library.uploadToServer(Config.putInvoiceAPILink,
                jsonString: packet.toString());
            await db.update(TablePaidInvoices.tableName,
                {TablePaidInvoices.isUpload: status ? 1 : 0},
                where: '${TablePaidInvoices.id} = ?',
                whereArgs: [inv['android_payment_id']]);
          }
        });
      }
    } catch (e) {
      log('>>>ERROR ON INVOICE UPLOAD SERVICE\n$e');
    } finally {
      cycleComplete = true;
    }
  }
}
