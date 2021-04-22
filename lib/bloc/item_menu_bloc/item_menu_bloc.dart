import 'dart:async';
import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:sales_force/models/objects/category.dart';
import 'package:sales_force/models/objects/customer_order.dart';
import 'package:sales_force/models/objects/product.dart';
import 'package:sales_force/models/objects/product_prices.dart';
import 'package:sales_force/repositories/items_repository.dart';
import 'package:sales_force/shared/config.dart';

part 'item_menu_event.dart';
part 'item_menu_state.dart';

class ItemMenuBloc extends Bloc<ItemMenuEvent, ItemMenuState> {
  ItemMenuBloc() : super(ItemMenuInitial());
  final Order customerOrder = Order();
  List<Product> products = [];
  List<Category> categories = [];
  List<ProductPrices> productPrices = [];

  @override
  Stream<ItemMenuState> mapEventToState(
    ItemMenuEvent event,
  ) async* {
    try {
      if (event is LoadItemsEvent) {
        customerOrder.reset();
        categories =
            await ItemsMenuRepo.repo.getAllCategories(Config.user.userId);
        products = await ItemsMenuRepo.repo.getAllProducts(Config.user.userId);
        productPrices = await ItemsMenuRepo.repo.getProductPrices();
        products.forEach((p) {
          p.price = productPrices
              .where((pp) => pp.productId == p.productId)
              .first
              .cashPrice;
        });
        yield LoadItemMenuState(
            categories: categories, products: products, totalAmount: '0');
      }
      if (event is SearchPressed) {
        yield SearchItemState(products: []);
      } else if(event is PanelCollasped) {
        yield CartItemsState(
            products: customerOrder.cartItems,
            totalAmount: customerOrder.totalAmount);
      } else if (event is CancelSearchPressed) {
        yield LoadItemMenuState(
            categories: categories,
            products: products,
            totalAmount: customerOrder.totalAmount);
      } else if (event is ItemNameChanged) {
        // final products = await ItemsMenuRepo.repo
        //     .searchProducts(Config.user.userId, event.name);
        yield SearchItemState(
            products: products.where((e) => e.title.contains(event.name)));
      } else if (event is ItemAddEvent) {
        customerOrder.addCartItem(products
            .where((element) => element.productId == event.productId)
            .first);
        yield CartItemsState(
            products: customerOrder.cartItems,
            totalAmount: customerOrder.totalAmount);
      } else if (event is ItemReduceEvent) {
        customerOrder.reduceCartItem(int.parse(event.productId));
        yield CartItemsState(
            products: customerOrder.cartItems,
            totalAmount: customerOrder.totalAmount);
      } else if (event is ItemRemoveEvent) {
        customerOrder.removeCartItem(int.parse(event.productId));
        yield CartItemsState(
            products: customerOrder.cartItems,
            totalAmount: customerOrder.totalAmount);
      } else if (event is QuantityChanged) {
        customerOrder.setQuantity(event.productId, event.quantity);
        yield CartItemsState(
            products: customerOrder.cartItems,
            totalAmount: customerOrder.totalAmount);
      } else if (event is FOCQuantityChanged) {
        customerOrder.setFOCQuantity(event.productId, event.quantity);
        yield CartItemsState(
            products: customerOrder.cartItems,
            totalAmount: customerOrder.totalAmount);
      } else if (event is SubmitOrder) {
        if (customerOrder.cartItems.length > 0) {
          yield ValidSubmission(customerOrder: customerOrder);
        } else {
          yield InvalidSubmission(message: 'Your cart is empty.');
        }
      }
    } catch (e) {
      log('ERROR', error: e, name: 'ItemMenuBloc');
      yield ItemMenuErrorState(message: e.toString());
    }
  }
}
