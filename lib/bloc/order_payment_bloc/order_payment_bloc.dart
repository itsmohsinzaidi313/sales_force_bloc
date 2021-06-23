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
        if (customerOrder.items.isNotEmpty) {
          final status = await OrdersRepo.repo.saveOrder(customerOrder);
          String message;
          if (status) {
            message = 'Order Saved';
          } else {
            message = 'Order cannot be saved';
          }
          yield OrderSavedState(orderSaved: status, message: message);
        } else {
          yield OrderPaymentErrorState(message: 'Not items in cart');
        }
      }
    } catch (e) {
      yield OrderPaymentErrorState(message: e.toString());
    }
  }
}
