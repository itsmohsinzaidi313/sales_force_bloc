part of 'order_payment_bloc.dart';

@immutable
abstract class OrderPaymentEvent {}

class LoadOrderPayment extends OrderPaymentEvent {}

class DiscountChanged extends OrderPaymentEvent {
  final String discount;
  DiscountChanged({this.discount});
}

class AddDiscount extends OrderPaymentEvent {}

class SubmitOrder extends OrderPaymentEvent {}
