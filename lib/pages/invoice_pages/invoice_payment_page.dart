import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sales_force/bloc/invoice_bloc/invoice_bloc.dart';
import 'package:sales_force/bloc/verbose_bloc/verbose_bloc.dart';
import 'package:sales_force/models/objects/invoice.dart';
import 'package:sales_force/shared/app_theme.dart';
import 'package:sales_force/shared/config.dart';
import 'package:sales_force/shared/constants.dart';

class InvoicePaymentPage extends StatelessWidget {
  final Invoice invoice;

  InvoicePaymentPage({this.invoice});
  final double formFieldWidth = 500;

  // static const String firstText = 'customer name:';
  // static const String secondText = 'invoice number:';
  // static const String thirdText = 'received amount:';
  // static const String forthText = 'discount:';
  // static const String fifthText = 'total amount:';
  // static const String sixthText = 'paid amount:';
  // static const String seventhText = 'invoice date:';

  static const double topPadding = 10.0;
  static const double bottomPadding = 20.0;
  static const double leftPadding = 10.0;
  static const double rightPadding = 10.0;

  double payment = 0;

  @override
  Widget build(BuildContext context) {
    return BlocListener<VerboseBloc, VerboseState>(
      listenWhen: (previous, current) => current is VerboseSnackBarState,
      listener: (context, state) {
        AppTheme.snackbar(context, state.message);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Invoice Payment'.toUpperCase()),
        ),
        body: BlocListener<InvoiceBloc, InvoiceState>(
          listener: (context, state) async {
            if (state is PaymentSuccessfulState) {
              AppTheme.snackbar(context, state.message);
              Navigator.pop(context);
              await Navigator.of(context)
                  .pushNamedAndRemoveUntil('/menu', (route) => false);
            } else if (state is PaymentUnsuccessfulState) {
              AppTheme.snackbar(context, state.message);
            } else if (state is InvalidPaymentState) {
              AppTheme.snackbar(context, state.message);
            } else if (state is InvalidBankState) {
              AppTheme.snackbar(context, state.message);
            } else if (state is InvalidChequeNoState) {
              AppTheme.snackbar(context, state.message);
            } else if (state is InvalidClearingDateEvent) {
              AppTheme.snackbar(context, state.message);
            }
          },
          child: ListView(
            children: invoiceFields(context),
          ),
        ),
      ),
    );
  }

  List<Widget> invoiceFields(BuildContext context) => <Widget>[
        ListTile(
          title: Text('Customer Name'),
          subtitle: Text(invoice.customerName),
        ),
        Divider(),
        ListTile(
          title: Text('Invoice Number'),
          subtitle: Text(invoice.invoiceNumber),
        ),
        Divider(),
        ListTile(
          title: Text('Received Amount'),
          subtitle: Text(invoice.balance),
        ),
        Divider(),
        ListTile(
          title: Text('Discount'),
          subtitle: Text(invoice.discount),
        ),
        Divider(),
        ListTile(
          title: Text('Total Amount'),
          subtitle: Text(invoice.totalAmount),
        ),
        Divider(),
        ListTile(
          title: Text('Paid Amount'),
          subtitle: Text(invoice.paidAmount),
        ),
        Divider(),
        ListTile(
          title: Text('Invoice Date'),
          subtitle: Text(invoice.date),
        ),
        Divider(),
        ButtonBar(
          alignment: MainAxisAlignment.center,
          children: <Widget>[
            AppTheme.rectangleElevatedButton(
              text: 'By Cash'.toUpperCase(),
              onPressed: () => cashPaymentDialog(
                context,
                invoice,
                routeSettings: RouteSettings(
                  arguments: [invoice, context.read<InvoiceBloc>()],
                ),
              ),
            ),
            // AppTheme.rectangleElevatedButton(
            //   text: 'By Cheque'.toUpperCase(),
            //   onPressed: () => chequePaymentDialog(context, invoice),
            // ),
          ],
        ),
      ];

  Future<dynamic> cashPaymentDialog(BuildContext context, Invoice invoice,
      {RouteSettings routeSettings}) async {
    passEvent(context, PaymentTypeChanged(paymentmode: PAYMENTMODE.CASH));
    return await showDialog(
      context: context,
      routeSettings: routeSettings,
      builder: (context) {
        final inv = ((routeSettings.arguments as List)[0] as Invoice);
        final bloc = ((routeSettings.arguments as List)[1] as InvoiceBloc);
        return Dialog(
          child: Wrap(
            alignment: WrapAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.blue,
                  border: BorderDirectional(
                    bottom: BorderSide(color: Colors.blueAccent, width: 3),
                  ),
                ),
                child: Center(
                  child: Text(
                    'PAYMENT',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                    ),
                  ),
                ),
              ),
              ListTile(
                title: Text('Invoice Amount'),
                subtitle: Text(inv.totalAmount),
              ),
              Divider(),
              ListTile(
                title: Text('Balance'),
                subtitle: Text(inv.balance),
              ),
              Divider(),
              ListTile(
                title: Text('Amount'),
                subtitle: TextField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: 'Amount'),
                  onChanged: (value) {
                    if (value != null) {
                      double.tryParse(value) != null
                          ? payment = double.tryParse(value)
                          : AppTheme.snackbar(context, 'Invalid amount');
                    }
                  },
                ),
              ),
              Divider(),
              AppTheme.recElevatedButton(
                  text: 'PAY',
                  onPressed: () {
                    if (payment != null && payment > 0) {
                      bloc.add(PayInvoicePressed(payment: payment.toString()));
                    }
                  }),
            ],
          ),
        );
      },
    );
  }

  Future<dynamic> chequePaymentDialog(BuildContext context, Invoice invoice,
      {RouteSettings routeSettings}) async {
    passEvent(context, PaymentTypeChanged(paymentmode: PAYMENTMODE.CHEQUE));
    return await showDialog(
      context: context,
      routeSettings: routeSettings,
      builder: (context) {
        final inv = ((routeSettings.arguments as List)[0] as Invoice);
        final bloc = ((routeSettings.arguments as List)[1] as InvoiceBloc);
        return Dialog(
          child: Wrap(
            alignment: WrapAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.blue,
                  border: BorderDirectional(
                    bottom: BorderSide(color: Colors.blueAccent, width: 3),
                  ),
                ),
                child: Center(
                  child: Text(
                    'CHEQUE PAYMENT',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                    ),
                  ),
                ),
              ),
              ListTile(
                title: Text('Invoice Amount'),
                subtitle: Text(inv.amount),
              ),
              Divider(),
              ListTile(
                title: Text('Balance'),
                subtitle: Text(inv.balance),
              ),
              Divider(),
              TextField(
                decoration: InputDecoration(
                    labelText: 'Bank', icon: Icon(Icons.arrow_forward)),
                onChanged: (value) => bloc.add(
                  BankChangedEvent(
                    bank: value,
                  ),
                ),
              ),
              TextField(
                  decoration: InputDecoration(
                    labelText: 'Cheque No',
                    icon: Icon(Icons.arrow_forward),
                  ),
                  onChanged: (value) => bloc.add(
                        ChequeNoChanged(
                          chequeNo: value,
                        ),
                      )),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      width: Config.deviceDisplayWidth(context) * 0.2,
                      child: TextField(
                        decoration: InputDecoration(
                          labelText: 'Clearing Date',
                          icon: Icon(Icons.arrow_forward),
                        ),
                        onChanged: (value) => bloc.add(
                          ClearingDateChanged(
                            clearingDate: value,
                          ),
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.calendar_today),
                    onPressed: () => showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime(
                        DateTime.now().year,
                        (DateTime.now().month + 6),
                      ),
                    ),
                  ),
                ],
              ),
              TextField(
                decoration: InputDecoration(
                    labelText: 'Amount', icon: Icon(Icons.arrow_forward)),
                onChanged: (value) => bloc.add(
                  PaymentChangedEvent(
                    payment: double.tryParse(value),
                  ),
                ),
              ),
              Divider(),
              AppTheme.recElevatedButton(
                text: 'PAY',
                onPressed: () => bloc.add(PayInvoicePressed()),
              ),
            ],
          ),
        );
      },
    );
  }

  void passEvent(BuildContext context, InvoiceEvent event) =>
      context.read<InvoiceBloc>().add(event);
}
