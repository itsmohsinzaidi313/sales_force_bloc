import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sales_force/bloc/verbose_bloc/verbose_bloc.dart';
import 'package:sales_force/models/objects/invoice.dart';
import 'package:sales_force/shared/app_theme.dart';

class ChequePayment extends StatefulWidget {
  final Invoice invoice;

  ChequePayment({this.invoice});

  @override
  _ChequePaymentState createState() => _ChequePaymentState(invoice: invoice);
}

class _ChequePaymentState extends State<ChequePayment> {
  Invoice invoice;

  _ChequePaymentState({this.invoice});

  final chequeFormKey = GlobalKey<FormState>();

  String bank;
  String chequeNo;
  String chequeDate = "Select Date";
  String amountReceived;

  @override
  Widget build(BuildContext context) {
    return BlocListener<VerboseBloc, VerboseState>(
      listenWhen: (previous, current) => current is VerboseSnackBarState,
      listener: (context, state) {
        AppTheme.snackbar(context, state.message);
      },
      child: Scaffold(
        appBar: AppTheme.appBar(title: 'Invoice Cheque Payment'),
        body: SingleChildScrollView(
          child: Center(
            heightFactor: 1.5,
            child: SizedBox(
              height: 400,
              width: 400,
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
                      child: showChequePayment(),
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

  Widget showChequePayment() {
    return Column(
      verticalDirection: VerticalDirection.down,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
          child: Form(
            key: chequeFormKey,
            child: Column(
              children: <Widget>[
                Container(
                  child: TextField(
                    decoration: InputDecoration(hintText: 'Cheque Number'),
                  ),
                ),
                Container(
                  child: TextField(
                    decoration: InputDecoration(hintText: 'Bank Name'),
                  ),
                ),
                Container(
                    child: Row(
                  children: <Widget>[
                    Expanded(child: AppTheme.text(text: chequeDate)),
                    AppTheme.imageButton('images/calendar.png', 10,
                        onPressed: () => AppTheme.datePicker(context)
                            .then((value) => setState(() {
                                  chequeDate =
                                      DateFormat('yyyy-MM-dd').format(value);
                                }))),
                  ],
                )),
                Container(
                  child: TextField(
                    decoration: InputDecoration(hintText: 'Amount'),
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                  child: AppTheme.roundElevatedButton(
                    text: 'Submit',
                    onPressed: () {},
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
