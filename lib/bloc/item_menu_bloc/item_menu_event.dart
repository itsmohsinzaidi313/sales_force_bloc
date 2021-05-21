part of 'item_menu_bloc.dart';

@immutable
abstract class ItemMenuEvent {}

class CancelSearchPressed extends ItemMenuEvent {}

class SearchPressed extends ItemMenuEvent {}

class CategoryChanged extends ItemMenuEvent {
  final String name;
  CategoryChanged({this.name});
}

class ItemNameChanged extends ItemMenuEvent {
  final String name;
  ItemNameChanged({this.name});
}

class ItemAddEvent extends ItemMenuEvent {
  final String productId;
  ItemAddEvent({this.productId});
}

class ItemReduceEvent extends ItemMenuEvent {
  final String productId;
  ItemReduceEvent({this.productId});
}

class ItemRemoveEvent extends ItemMenuEvent {
  final String productId;
  ItemRemoveEvent({this.productId});
}

class LoadAllItemsEvent extends ItemMenuEvent {}

class LoadItemsEvent extends ItemMenuEvent {}

class QuantityChanged extends ItemMenuEvent {
  final String productId;
  final int quantity;
  QuantityChanged({this.productId, this.quantity});
}

class FOCQuantityChanged extends ItemMenuEvent {
  final String productId;
  final int quantity;
  FOCQuantityChanged({this.productId, this.quantity});
}

class SubmitOrder extends ItemMenuEvent {}

class PanelCollasped extends ItemMenuEvent {}

class InitItemMenuEvent extends ItemMenuEvent {
  final Customer customer;
  final PAYMENTMODE paymentmode;
  InitItemMenuEvent({this.customer, this.paymentmode});
}
