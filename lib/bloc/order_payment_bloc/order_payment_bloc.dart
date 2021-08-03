import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:sales_force/models/objects/customer_order.dart';
import 'package:sales_force/repositories/orders_repository.dart';

part 'order_payment_event.dart';
part 'order_payment_state.dart';

class OrderPaymentBloc extends Bloc<OrderPaymentEvent, OrderPaymentState> {
  OrderPaymentBloc() : super(OrderPaymentInitial());
  Order customerOrder = Order();
  String tempDiscount = '0';
  bool requestSubmitted = false;
  final List<String> orderTypes = ['IMT', 'LMT', 'GT'];
  @override
  Stream<OrderPaymentState> mapEventToState(
    OrderPaymentEvent event,
  ) async* {
    try {
      if (event is LoadOrderPayment) {
        customerOrder.discountPercent = '0';
        customerOrder.receivable = '0';
        customerOrder.discountAmount = '0';
        yield LoadOrderPaymentState(customerOrder: customerOrder);
      } else if (event is DiscountChanged) {
        double discount =
            double.tryParse(event.discount == '' ? '0' : event.discount) ?? 0;
        if (discount > double.tryParse(customerOrder.customer.discount) ?? 0) {
          tempDiscount = event.discount;
          yield InvalidDiscount(message: 'Discount not allowed');
        } else {
          tempDiscount = event.discount;
        }
      } else if (event is AddDiscount) {
        double discount =
            double.tryParse(tempDiscount == '' ? '0' : tempDiscount) ?? 0;
        if (discount > double.tryParse(customerOrder.customer.discount) ?? 0) {
          yield InvalidDiscount(message: 'Discount not allowed');
        } else {
          customerOrder.setDiscount(double.tryParse(tempDiscount) ?? 0);
          yield ValidDiscount();
        }
      } else if (event is SubmitOrder) {
        if (!requestSubmitted) {
          if (customerOrder.items.isNotEmpty &&
              customerOrder.orderType != null &&
              customerOrder.orderType != 0) {
            requestSubmitted = true;
            final status = await OrdersRepo.repo.saveOrder(customerOrder);
            String message;
            if (status) {
              message = 'Order Saved';
            } else {
              message = 'Order cannot be saved';
            }
            requestSubmitted = false;
            yield OrderSavedState(orderSaved: status, message: message);
          } else {
            requestSubmitted = false;
            yield OrderPaymentErrorState(
                message: 'No items in cart or order type is not selected.');
          }
        } else {
          yield OrderPaymentErrorState(message: 'Please wait...');
        }
      } else if (event is OrderTypeChanged) {
        customerOrder.orderType = orderTypes.indexOf(event.orderType) + 1;
      }
    } catch (e) {
      yield OrderPaymentErrorState(message: e.toString());
    }
  }
}
