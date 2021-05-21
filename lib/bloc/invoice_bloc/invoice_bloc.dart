import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:sales_force/models/objects/invoice.dart';
import 'package:sales_force/repositories/invoice_repository.dart';
import 'package:sales_force/shared/config.dart';
import 'package:sales_force/shared/constants.dart';

part 'invoice_event.dart';
part 'invoice_state.dart';

class InvoiceBloc extends Bloc<InvoiceEvent, InvoiceState> {
  InvoiceBloc() : super(InvoiceBlocInitial());
  List<Invoice> invoices = [];
  Invoice invoice;
  String payment = '';
  String bank = '';
  String chequeNo = '';
  String clearingDate = '';
  PAYMENTMODE paymentmode;
  @override
  Stream<InvoiceState> mapEventToState(
    InvoiceEvent event,
  ) async* {
    try {
      if (event is LoadInvoicesEvent) {
        invoices = await InvoiceRepo.repo.getInvoices(Config.user.userId);
        yield LoadInvoiceState(list: invoices);
      }
      if (event is PayInvoiceEvent) {
        invoice = event.invoice;
        yield PayInvoiceState(invoice: event.invoice);
      } else if (event is PaymentChangedEvent) {
        if (event.payment > double.parse(invoice.balance)) {
          yield InvalidPaymentState(message: 'Invalid amount');
        } else {
          payment = event.payment.toString();
          yield ValidPaymentState(value: event.payment.toString());
        }
      } else if (event is ChequeNoChanged) {
        if (event.chequeNo == '') {
          yield InvalidChequeNoState(message: 'Please enter cheque no');
        } else {
          chequeNo = event.chequeNo;
          yield ValidChequeNoState();
        }
      } else if (event is BankChangedEvent) {
        if (event.bank == '') {
          yield InvalidBankState(message: 'Please enter bank name');
        } else {
          bank = event.bank;
          yield ValidBankState();
        }
      } else if (event is PaymentTypeChanged) {
        paymentmode = event.paymentmode;
      } else if (event is ClearingDateChanged) {
        if (clearingDate == '') {
          yield InvalidClearingDateEvent(message: 'Please enter clearing date');
        } else {
          clearingDate = event.clearingDate;
          yield ValidClearingDateEvent();
        }
      } else if (event is PayInvoicePressed) {
        if (paymentmode == PAYMENTMODE.CASH) {
          if (payment == '' || double.tryParse(payment) == null) {
            yield InvalidPaymentState(message: 'Invalid amount');
          } else {
            InvoiceRepo.repo.payInvoice(
                invoice, bank, chequeNo, payment, clearingDate, paymentmode);
          }
        } else if (paymentmode == PAYMENTMODE.CHEQUE) {
          if (payment == '' || double.tryParse(payment) == null) {
            yield InvalidPaymentState(message: 'Invalid amount');
          } else if (clearingDate == '' ||
              DateTime.tryParse(clearingDate) == null) {
            yield InvalidClearingDateEvent(
                message: 'Please enter clearing date');
          } else if (bank == '') {
            yield InvalidBankState(message: 'Please enter bank name');
          } else if (chequeNo == '') {
            yield InvalidChequeNoState(message: 'Please enter cheque no');
          } else {
            bool status = await InvoiceRepo.repo.payInvoice(
                invoice, bank, chequeNo, payment, clearingDate, paymentmode);
            if (status) {
              yield PaymentSuccessfulState(message: 'Payment saved');
            } else {
              yield PaymentSuccessfulState(message: 'Payment cannot be saved');
            }
          }
        }
      }
    } catch (e) {
      log('Error', error: e, name: 'InvoiceBloc');
      yield InvoiceErrorState(message: e.toString());
    }
  }
}
