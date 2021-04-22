part of 'view_sale_bloc.dart';

@immutable
abstract class ViewSalesEvent {}

class LoadSalesSummary extends ViewSalesEvent {
  final String userId;
  final String customerId;
  LoadSalesSummary({this.userId, this.customerId});
}

class LoadSaleDetail extends ViewSalesEvent {
  final String masterId;
  LoadSaleDetail({this.masterId});
}
