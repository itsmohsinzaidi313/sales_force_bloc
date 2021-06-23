part of 'invoice_bloc.dart';

@immutable
abstract class InvoiceEvent {}

class LoadInvoicesEvent extends InvoiceEvent {}

class PayInvoiceEvent extends InvoiceEvent {
  final Invoice invoice;
  PayInvoiceEvent({this.invoice});
}

class PaymentTypeChanged extends InvoiceEvent {
  final PAYMENTMODE paymentmode;
  PaymentTypeChanged({this.paymentmode});
}

class PaymentChangedEvent extends InvoiceEvent {
  final double payment;
  PaymentChangedEvent({this.payment});
}

class BankChangedEvent extends InvoiceEvent {
  final String bank;
  BankChangedEvent({this.bank});
}

class ChequeNoChanged extends InvoiceEvent {
  final String chequeNo;
  ChequeNoChanged({this.chequeNo});
}

class ClearingDateChanged extends InvoiceEvent {
  final String clearingDate;
  ClearingDateChanged({this.clearingDate});
}

class PayInvoicePressed extends InvoiceEvent {
  final String payment;
  PayInvoicePressed({this.payment});
}
