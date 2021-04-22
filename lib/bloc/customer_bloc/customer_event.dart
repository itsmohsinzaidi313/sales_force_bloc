part of 'customer_bloc.dart';

@immutable
abstract class CustomerEvent {}

class CustomerNameChanged extends CustomerEvent {
  final String name;
  CustomerNameChanged({this.name});
}

class CancelSearchPressed extends CustomerEvent {}

class SearchCustomerPressed extends CustomerEvent {}

class LoadCustomerEvent extends CustomerEvent {}

class CustomerSelected extends CustomerEvent {
  final Customer customer;
  final PAYMENTMODE paymentmode;
  CustomerSelected({this.customer, this.paymentmode});
}

class LoadViewSales extends CustomerEvent {
  final String customerId;
  final String userId;
  LoadViewSales({this.customerId, this.userId});
}
