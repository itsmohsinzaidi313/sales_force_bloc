import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sales_force/bloc/order_payment_bloc/order_payment_bloc.dart';
import 'package:sales_force/models/objects/customer_order.dart';
import 'package:sales_force/models/objects/product.dart';
import 'package:sales_force/shared/app_theme.dart';

class OrderPaymenPage extends StatelessWidget {
  final double titleFontSize = 18;
  final double rowSpacing = 8.0;
  final Order customerOrder;
  OrderPaymenPage({this.customerOrder});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OrderPaymentBloc, OrderPaymentState>(
      listener: (context, state) {
        if (state is InvalidDiscount) {
          AppTheme.snackbar(context, state.message);
        } else if (state is ValidDiscount) {
          Navigator.of(context).pop();
        } else if (state is OrderSavedState) {
          AppTheme.snackbar(context, state.message);
          if (state.orderSaved) {
            Navigator.of(context)
                .pushNamedAndRemoveUntil('/menu', (route) => false);
          }
        } else if (state is OrderPaymentErrorState) {
          AppTheme.snackbar(context, state.message);
        }
      },
      buildWhen: (previous, current) => current is LoadOrderPaymentState,
      builder: (context, state) {
        if (state is LoadOrderPaymentState) {
          return Scaffold(
            appBar: AppBar(title: Text('Confirm Order')),
            body: Column(
              children: <Widget>[
                Expanded(
                    child: Column(children: [
                  AppTheme.card(
                    child: Column(
                      children: <Widget>[
                        Row(children: <Widget>[
                          Expanded(
                              child: AppTheme.text(
                                  text: 'Customer:', fontSize: titleFontSize)),
                          AppTheme.text(
                              text:
                                  '${state.customerOrder.customer.firstName} ${state.customerOrder.customer.lastName}',
                              fontSize: titleFontSize,
                              textOverflow: TextOverflow.fade)
                        ]),
                        SizedBox(height: rowSpacing),
                        Row(children: <Widget>[
                          Expanded(
                              child: AppTheme.text(
                                  text: 'Shop:', fontSize: titleFontSize)),
                          AppTheme.text(
                              text: '${state.customerOrder.customer.shopName}',
                              fontSize: titleFontSize,
                              textOverflow: TextOverflow.fade)
                        ]),
                        SizedBox(height: rowSpacing),
                        Row(children: <Widget>[
                          Expanded(
                              child: AppTheme.text(
                                  text: 'Order Amount:',
                                  fontSize: titleFontSize)),
                          AppTheme.text(
                              text: 'Rs: ${state.customerOrder.totalAmount}',
                              fontSize: titleFontSize)
                        ]),
                        SizedBox(height: rowSpacing),
                        Row(children: <Widget>[
                          Expanded(
                              child: AppTheme.text(
                                  text: 'Customer Discount:',
                                  fontSize: titleFontSize)),
                          AppTheme.text(
                              text: '%${state.customerOrder.discountPercent}',
                              fontSize: titleFontSize)
                        ]),
                        SizedBox(height: rowSpacing),
                        Row(children: <Widget>[
                          Expanded(
                              child: AppTheme.text(
                                  text: 'Discounted Amount:',
                                  fontSize: titleFontSize)),
                          AppTheme.text(
                              text: 'Rs: ${state.customerOrder.discountAmount}',
                              fontSize: titleFontSize)
                        ]),
                        SizedBox(height: rowSpacing),
                        Row(children: <Widget>[
                          Expanded(
                              child: AppTheme.text(
                                  text: 'Receivable:',
                                  fontSize: titleFontSize,
                                  fontWeight: FontWeight.bold)),
                          AppTheme.text(
                              text: 'Rs: ${state.customerOrder.receivable}',
                              fontSize: titleFontSize,
                              fontWeight: FontWeight.bold)
                        ]),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: state.customerOrder.cartItems.length,
                        itemBuilder: (BuildContext context, int index) =>
                            getWidget(
                                context, state.customerOrder.cartItems[index])),
                  ),
                ])),
                ButtonBar(
                  alignment: MainAxisAlignment.center,
                  // mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: AppTheme.roundElevatedButton(
                          text: 'Add Discount',
                          onPressed: () =>
                              showUserDiscountDialog(context, state)),
                    ),
                    Center(
                      child: AppTheme.roundElevatedButton(
                        text: 'Take Order',
                        onPressed: () => AppTheme.showAlertDialogYN(context,
                                title: 'Attention', message: 'Are you sure?')
                            .then(
                          (value) => value
                              ? passEvent(context, SubmitOrder())
                              : Navigator.of(context).pop(),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }

  Widget getWidget(BuildContext context, Product product) {
    return Column(
      children: [
        ListTile(
          title: AppTheme.text(text: '${product.title}'),
          subtitle: AppTheme.text(
              text:
                  'Quantity: ${product.quantity}\nFOC Quantity: ${product.focQuantity}'),
          isThreeLine: true,
        ),
        Divider(),
      ],
    );
  }

  void showUserDiscountDialog(
      BuildContext context, LoadOrderPaymentState state) {
    AppTheme.showAlertDialog(context,
        title: 'Add Dicount',
        content: Wrap(
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Text(
                        'Discount Limit: ${state.customerOrder.customer.discountType == 'p' ? '%' : 'Rs'} ${state.customerOrder.customer.discount}')
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: SizedBox(
                        width: 100,
                        child: TextField(
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(labelText: 'Discount %:'),
                          onChanged: (value) => passEvent(
                              context, DiscountChanged(discount: value)),
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ],
        ),
        buttons: [
          TextButton(
            child: Text('Add'),
            onPressed: () => passEvent(context, AddDiscount()),
          ),
          TextButton(
            child: Text('Cancel'),
            onPressed: () => Navigator.of(context).pop(),
          )
        ]);
  }

  void passEvent(BuildContext context, OrderPaymentEvent event) =>
      context.read<OrderPaymentBloc>().add(event);
}
