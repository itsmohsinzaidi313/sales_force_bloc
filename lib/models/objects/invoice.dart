import 'package:sales_force/database/tables/invoices_table.dart';

class Invoice {
  String customerName;
  String invoiceId;
  String orderId;
  String customerId;
  String userId;
  String invoiceNumber;
  String date;
  String amount;
  String discount;
  String totalAmount;
  String paidAmount;
  String balance;
  String status;
  String createdon;
  String modifiedon;

  Invoice(
      {this.customerName,
      this.invoiceId,
      this.orderId,
      this.customerId,
      this.userId,
      this.invoiceNumber,
      this.date,
      this.amount,
      this.discount,
      this.totalAmount,
      this.paidAmount,
      this.balance,
      this.status,
      this.createdon,
      this.modifiedon});

  Invoice.withMap(List<dynamic> map) {
    if (map.isNotEmpty) {
      this.invoiceId = map[0]['invoice_id'];
      this.orderId = map[0]['order_id'];
      this.customerId = map[0]['customer_id'];
      this.userId = map[0]['user_id'];
      this.invoiceNumber = map[0]['invoice_number'];
      this.date = map[0]['invoice_date'];
      this.amount = map[0]['invoice_amount'];
      this.discount = map[0]['invoice_discount'];
      this.totalAmount = map[0]['invoice_total_amount'];
      this.paidAmount = map[0]['invoice_paid_amount'];
      this.balance = map[0]['invoice_balance'];
      this.status = map[0]['invoiice_status'];
      this.createdon = map[0]['createdon'];
      this.modifiedon = map[0]['modifiedon'];
    } else {
      throw ArgumentError.value(map, '', 'Null Map Value');
    }
  }

  getList() {
    return [
      this.invoiceId,
      this.orderId,
      this.customerId,
      this.userId,
      this.invoiceNumber,
      this.date,
      this.amount,
      this.discount,
      this.totalAmount,
      this.paidAmount,
      this.balance,
      this.status,
      this.createdon,
      this.modifiedon
    ];
  }

  Map<String, dynamic> getMapForInsert() {
    return {
      TableInvoices.invoiceId: this.invoiceId,
      TableInvoices.orderId: this.orderId,
      TableInvoices.customerId: this.customerId,
      TableInvoices.userId: this.userId,
      TableInvoices.number: this.invoiceNumber,
      TableInvoices.date: this.date,
      TableInvoices.amount: this.amount,
      TableInvoices.discount: this.discount,
      TableInvoices.totalAmount: this.totalAmount,
      TableInvoices.paidAmount: this.paidAmount,
      TableInvoices.balance: this.balance,
      TableInvoices.status: this.status,
      TableInvoices.createdOn: this.createdon,
      TableInvoices.modifiedOn: this.modifiedon
    };
  }
}
