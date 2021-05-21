import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sales_force/bloc/invoice_bloc/invoice_bloc.dart';
import 'package:sales_force/models/objects/invoice.dart';
import 'package:sales_force/shared/app_theme.dart';

class InvoicePage extends StatelessWidget {
  List<Invoice> invoices = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        ));
  }

  List<Widget> invoiceView(BuildContext context, List<Invoice> invoices) =>
      invoices.map((e) {
        Widget widget;
        if (double.parse(e.totalAmount) == double.parse(e.paidAmount)) {
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
              contentPadding:
                  EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              isThreeLine: true,
              title: AppTheme.text(text: '${e.customerName}', fontSize: 20),
              subtitle: AppTheme.text(
                  text: '${e.invoiceNumber}\n${e.amount}', fontSize: 20),
              trailing: widget),
        );
      }).toList();

  void passEvent(BuildContext context, InvoiceEvent event) =>
      context.read<InvoiceBloc>().add(event);

  // {
  //   try {
  //     List<Widget> widgets = [];
  //     for (Invoice value in invoices) {
  //       double invoiceAmount = double.parse(value.totalAmount);
  //       double paidAmount = double.parse(value.paidAmount);
  //       Widget widget;
  //       if (invoiceAmount == paidAmount)
  //         widget = ElevatedButton(
  //           child: AppTheme.text(text: 'PAID', color: Colors.blue),
  //           style: ButtonStyle(
  //               backgroundColor: MaterialStateProperty.all(Colors.white)),
  //           onPressed: () => false,
  //         );
  //       else
  //         widget = AppTheme.rectangleRaisedButton(
  //             text: 'PAY', onPressed: () async => onTap(value));
  //       widgets.add(Card(
  //           color: Colors.white,
  //           child: ListTile(
  //               contentPadding:
  //                   EdgeInsets.symmetric(vertical: 20, horizontal: 20),
  //               isThreeLine: true,
  //               title:
  //                   AppTheme.text(text: '${value.customerName}', fontSize: 20),
  //               subtitle: AppTheme.text(
  //                   text: '${value.invoiceNumber}\n${value.amount}',
  //                   fontSize: 20),
  //               trailing: widget)));
  //     }
  //     if (widgets.length == 0)
  //       widgets.add(Card(
  //         color: Colors.white,
  //         child: ListTile(
  //             contentPadding:
  //                 EdgeInsets.symmetric(vertical: 20, horizontal: 20),
  //             isThreeLine: true,
  //             title: AppTheme.text(text: 'No Invoies', fontSize: 20),
  //             subtitle: AppTheme.text(
  //                 text: 'There are no invoices to display.', fontSize: 20),
  //             trailing: Icon(
  //               Icons.info_outline,
  //               color: Colors.blue,
  //             )),
  //       ));
  //     return widgets;
  //   } catch (e) {
  //     List<Widget> widgets = [];

  //     widgets.add(Card(
  //       child: Text(e.toString()),
  //     ));
  //     return widgets;
  //   }
  // }

  // onTap(Invoice invoice, BuildContext context) {
  //   Navigator.push(
  //       context,
  //       new MaterialPageRoute(
  //           builder: (context) => InvoicePayment(
  //               invoice: JSONInvoice(
  //                   androidPaymentId: invoice.invoiceId,
  //                   paymentUserId: invoice.userId,
  //                   paymentOrderId: invoice.orderId,
  //                   paymentInvoiceId: invoice.invoiceId,
  //                   paymentCustomerId: invoice.customerId,
  //                   paymentAmount: invoice.amount,
  //                   customerName: invoice.customerName,
  //                   invoiceNumber: invoice.invoiceNumber,
  //                   date: invoice.date,
  //                   amountReceived: '',
  //                   discount: invoice.discount,
  //                   totalAmount: invoice.totalAmount,
  //                   paidAmount: invoice.paidAmount))));
  // }
}
