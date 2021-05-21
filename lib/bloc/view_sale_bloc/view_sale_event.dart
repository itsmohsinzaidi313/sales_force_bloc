part of 'view_sale_bloc.dart';

@immutable
abstract class ViewSalesEvent {}



class SetSalesValues extends ViewSalesEvent {
  final String userId;
  final String customerId;
  SetSalesValues({this.userId, this.customerId});
}

class LoadSaleDetail extends ViewSalesEvent {
  final String masterId;
  LoadSaleDetail({this.masterId});
}

class SearchSalesRecord extends ViewSalesEvent {
  final String fromDate;
  final String toDate;
  SearchSalesRecord({this.fromDate, this.toDate});
}
