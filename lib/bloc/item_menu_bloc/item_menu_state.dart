part of 'item_menu_bloc.dart';

@immutable
abstract class ItemMenuState {
  final String totalAmount;
  ItemMenuState({@required this.totalAmount});
}

class ItemMenuInitial extends ItemMenuState {
  final List<Product> products;
  final List<Category> categories;
  ItemMenuInitial({this.products, this.categories, String totalAmount})
      : super(totalAmount: totalAmount);
}

class AllMenuState extends ItemMenuState {
  final List<Product> products;
  final List<Category> categories;
  AllMenuState({this.products, this.categories, String totalAmount})
      : super(totalAmount: totalAmount);
}

class SearchItemState extends ItemMenuState {
  final List<Product> products;
  SearchItemState({this.products, String totalAmount})
      : super(totalAmount: totalAmount);
}

class CartItemsState extends ItemMenuState {
  final List<Product> products;
  CartItemsState({this.products, String totalAmount})
      : super(totalAmount: totalAmount);
}

class ItemMenuErrorState extends ItemMenuState {
  final String message;
  ItemMenuErrorState({this.message, String totalAmount})
      : super(totalAmount: totalAmount);
}

class LoadItemMenuState extends ItemMenuState {
  final List<Product> products;
  final List<Category> categories;
  LoadItemMenuState({this.products, this.categories, String totalAmount})
      : super(totalAmount: totalAmount);
}

class ValidSubmission extends ItemMenuState {
  final Order customerOrder;
  ValidSubmission({this.customerOrder});
}

class InvalidSubmission extends ItemMenuState {
  final String message;
  InvalidSubmission({this.message});
}
