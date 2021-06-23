import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sales_force/bloc/invoice_bloc/invoice_bloc.dart';
import 'package:sales_force/bloc/verbose_bloc/verbose_bloc.dart';
import 'package:sales_force/models/objects/invoice.dart';
import 'package:sales_force/shared/app_theme.dart';

class InvoicePage extends StatelessWidget {
  List<Invoice> invoices = [];
  @override
  Widget build(BuildContext context) {
    return BlocListener<VerboseBloc, VerboseState>(
      listenWhen: (previous, current) => current is VerboseSnackBarState,
      listener: (context, state) {
        AppTheme.snackbar(context, state.message);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("Invoices"),
        ),
        body: Container(
          // decoration: BoxDecoration(
          //     image: DecorationImage(
          //         image: AssetImage(AppTheme.backgroundImage),
          //         repeat: ImageRepeat.repeat)),
          color: AppTheme.backgroundColor,
          child: BlocConsumer<InvoiceBloc, InvoiceState>(
            listener: (context, state) {
              if (state is PayInvoiceState)
                Navigator.of(context)
                    .pushNamed('/invoicePayment', arguments: state.invoice);
            },
            builder: (context, state) {
              if (state is LoadInvoiceState) {
                if (state.list.length > 0) {
                  invoices = state.list;
                  return ListView(
                      children: ListTile.divideTiles(
                              tiles: invoiceView(context, invoices),
                              context: context,
                              color: Colors.grey)
                          .toList());
                } else {
                  return Card(
                    color: Colors.white,
                    child: ListTile(
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                      isThreeLine: true,
                      title: AppTheme.text(text: 'No Invoies', fontSize: 20),
                      subtitle: AppTheme.text(
                          text: 'There are no invoices to display.',
                          fontSize: 20),
                      trailing: Icon(
                        Icons.info_outline,
                        color: Colors.blue,
                      ),
                    ),
                  );
                }
              }
              if (invoices.isNotEmpty) {
                return ListView(
                    children: ListTile.divideTiles(
                            tiles: invoiceView(context, invoices),
                            context: context,
                            color: Colors.grey)
                        .toList());
              } else {
                return AppTheme.progIndicator;
              }
            },
          ),
        ),
      ),
    );
  }

  List<Widget> invoiceView(BuildContext context, List<Invoice> invoices) =>
      invoices.map((e) {
        Widget widget;
        if (double.parse(e.paidAmount) >= double.parse(e.totalAmount)) {
          widget = ElevatedButton(
            child: AppTheme.text(text: 'PAID', color: Colors.blue),
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.white),
            ),
            onPressed: () => null,
          );
        } else {
          widget = AppTheme.rectangleElevatedButton(
            text: 'PAY',
            onPressed: () => passEvent(context, PayInvoiceEvent(invoice: e)),
          );
        }
        return Card(
          color: Colors.white,
          child: ListTile(
              isThreeLine: true,
              contentPadding:
                  EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              title: AppTheme.text(
                text: '${e.customerName}',
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              subtitle: AppTheme.text(
                  text:
                      'INVOICE#: ${e.invoiceNumber}\nDATE: ${e.createdon.substring(0, 10)}\nAMOUNT: ${e.balance}',
                  fontSize: 14),
              trailing: widget),
        );
      }).toList();

  void passEvent(BuildContext context, InvoiceEvent event) =>
      context.read<InvoiceBloc>().add(event);
}
