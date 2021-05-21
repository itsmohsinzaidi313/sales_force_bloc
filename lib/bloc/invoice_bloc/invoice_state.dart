part of 'invoice_bloc.dart';

@immutable
abstract class InvoiceState {}

class InvoiceBlocInitial extends InvoiceState {}

class LoadInvoiceState extends InvoiceState {
  final List<Invoice> list;
  LoadInvoiceState({this.list});
}

class PayInvoiceState extends InvoiceState {
  final Invoice invoice;
  PayInvoiceState({this.invoice});
}

class ValidPaymentState extends InvoiceState {
  final String value;
  ValidPaymentState({this.value});
}

class InvalidPaymentState extends InvoiceState {
  final String message;
  InvalidPaymentState({this.message});
}

class ValidBankState extends InvoiceState {
  final String value;
  ValidBankState({this.value});
}

class InvalidBankState extends InvoiceState {
  final String message;
  InvalidBankState({this.message});
}

class ValidChequeNoState extends InvoiceState {
  final String value;
  ValidChequeNoState({this.value});
}

class InvalidChequeNoState extends InvoiceState {
  final String message;
  InvalidChequeNoState({this.message});
}

class ValidClearingDateEvent extends InvoiceState {
  final String value;
  ValidClearingDateEvent({this.value});
}

class InvalidClearingDateEvent extends InvoiceState {
  final String message;
  InvalidClearingDateEvent({this.message});
}

class PaymentSuccessfulState extends InvoiceState {
  final String message;
  PaymentSuccessfulState({this.message});
}

class PaymentUnsuccessfulState extends InvoiceState {
  final String message;
  PaymentUnsuccessfulState({this.message});
}

class InvoiceErrorState extends InvoiceState {
  final String message;
  InvoiceErrorState({this.message});
}