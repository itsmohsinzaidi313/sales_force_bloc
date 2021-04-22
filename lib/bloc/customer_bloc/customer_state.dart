part of 'customer_bloc.dart';

@immutable
abstract class CustomerState {}

class CustomerInitial extends CustomerState {}

class SearchCustomerState extends CustomerState {}

class NormalCustomerState extends CustomerState {}

class CustomerListState extends CustomerState {
  final List<Customer> list;
  CustomerListState({@required this.list});
}

class CustomerErrorState extends CustomerState {
  final String message;
  CustomerErrorState({this.message});
}

class TakeCustomerOrder extends CustomerState {
  final Customer customer;
  final PAYMENTMODE paymentmode;
  TakeCustomerOrder({this.customer, this.paymentmode});
}

class ShowViewSales extends CustomerState {
  final String userId;
  final String customerId;
  ShowViewSales({this.userId, this.customerId});
}
