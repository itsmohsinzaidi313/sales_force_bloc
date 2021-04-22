part of 'view_sale_bloc.dart';

@immutable
abstract class ViewSalesState {}

class ViewSaleInitial extends ViewSalesState {}

class ViewSaleStartupState extends ViewSalesState {
  final List<Map<String, dynamic>> masterList;
  ViewSaleStartupState({this.masterList});
}

class ViewSaleDetailState extends ViewSalesState {
  final List<Product> detailsList;
  ViewSaleDetailState({this.detailsList});
}