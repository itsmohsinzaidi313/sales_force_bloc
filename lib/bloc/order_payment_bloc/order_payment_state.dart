part of 'order_payment_bloc.dart';

@immutable
abstract class OrderPaymentState {}

class OrderPaymentInitial extends OrderPaymentState {}

class LoadOrderPaymentState extends OrderPaymentState {
  final Order customerOrder;
  LoadOrderPaymentState({this.customerOrder});
}

class InvalidDiscount extends OrderPaymentState {
  final String message;
  InvalidDiscount({this.message});
}

class ValidDiscount extends OrderPaymentState {}

class OrderSavedState extends OrderPaymentState {
  final bool orderSaved;
  final String message;
  OrderSavedState({this.orderSaved, this.message});
}

class OrderPaymentErrorState extends OrderPaymentState {
  final String message;
  OrderPaymentErrorState({this.message});
}
