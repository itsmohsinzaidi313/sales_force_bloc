import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sales_force/bloc/verbose_bloc/verbose_bloc.dart';
import 'package:sales_force/models/objects/invoice.dart';
import 'package:sales_force/shared/app_theme.dart';

class CashPayment extends StatefulWidget {
  final Invoice invoice;

  CashPayment({this.invoice});

  @override
  _CashPaymentState createState() => _CashPaymentState(invoice: invoice);
}

class _CashPaymentState extends State<CashPayment> {
  final cashFormKey = GlobalKey<FormState>();
  String amountReceived;
  Invoice invoice;

  _CashPaymentState({this.invoice});

  @override
  Widget build(BuildContext context) {
    return BlocListener<VerboseBloc, VerboseState>(
      listenWhen: (previous, current) => current is VerboseSnackBarState,
      listener: (context, state) {
        AppTheme.snackbar(context, state.message);
      },
      child: Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppTheme.appBar(title: 'Invoice Cash Payment'),
        body: SingleChildScrollView(
          child: Center(
            heightFactor: 2,
            child: SizedBox(
              height: 255,
              width: 255,
              child: Card(
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Expanded(
                            child: Container(
                          color: Colors.blue[300],
                          padding: EdgeInsets.fromLTRB(0, 15, 0, 15),
                          child: Center(
                              child: AppTheme.text(
                                  text: 'Enter Amount',
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold)),
                        )),
                      ],
                    ),
                    Expanded(
                      child: SizedBox(),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(0, 0, 0, 35),
                      padding: EdgeInsets.all(8.0),
                      child: showCashPayment(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget showCashPayment() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Form(
        key: cashFormKey,
        child: Column(
          verticalDirection: VerticalDirection.down,
          children: <Widget>[
            Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Amount: ${this.invoice.totalAmount}'),
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'Amount',
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(0, 20, 0, 0),
              child: AppTheme.roundElevatedButton(
                text: 'Submit',
                onPressed: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}
