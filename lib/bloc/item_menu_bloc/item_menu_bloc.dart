import 'dart:async';
import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:sales_force/models/objects/category.dart';
import 'package:sales_force/models/objects/customer.dart';
import 'package:sales_force/models/objects/customer_order.dart';
import 'package:sales_force/models/objects/product.dart';
import 'package:sales_force/models/objects/product_foc.dart';
import 'package:sales_force/models/objects/product_prices.dart';
import 'package:sales_force/repositories/items_repository.dart';
import 'package:sales_force/shared/config.dart';
import 'package:sales_force/shared/constants.dart';

part 'item_menu_event.dart';
part 'item_menu_state.dart';

class ItemMenuBloc extends Bloc<ItemMenuEvent, ItemMenuState> {
  ItemMenuBloc() : super(ItemMenuInitial());
  final Order customerOrder = Order();
  List<Product> products = [];
  List<Category> categories = [];
  List<ProductPrices> productPrices = [];
  List<ProductFoc> productFOC = [];

  @override
  Stream<ItemMenuState> mapEventToState(
    ItemMenuEvent event,
  ) async* {
    try {
      if (event is InitItemMenuEvent) {
        customerOrder.customer = event.customer;
        customerOrder.paymentmode = event.paymentmode;
      } else if (event is LoadItemsEvent) {
        await loadItems();
        yield LoadItemMenuState(
            categories: categories, products: products, totalAmount: '0');
      }
      if (event is SearchPressed) {
        yield SearchItemState(products: []);
      } else if (event is PanelCollasped) {
        yield CartItemsState(
            products: customerOrder.items,
            totalAmount: customerOrder.totalAmount);
      } else if (event is CancelSearchPressed) {
        yield LoadItemMenuState(
            categories: categories,
            products: products,
            totalAmount: customerOrder.totalAmount);
      } else if (event is ItemNameChanged) {
        yield SearchItemState(
            products:
                products.where((e) => e.title.contains(event.name)).toList());
      } else if (event is ItemAddEvent) {
        customerOrder.addCartItem(products
            .where((element) => element.productId == event.productId)
            .first);
        yield CartItemsState(
            products: customerOrder.items,
            totalAmount: customerOrder.totalAmount);
      } else if (event is ItemReduceEvent) {
        customerOrder.reduceCartItem(int.parse(event.productId));
        yield CartItemsState(
            products: customerOrder.items,
            totalAmount: customerOrder.totalAmount);
      } else if (event is ItemRemoveEvent) {
        customerOrder.removeCartItem(int.parse(event.productId));
        yield CartItemsState(
            products: customerOrder.items,
            totalAmount: customerOrder.totalAmount);
      } else if (event is QuantityChanged) {
        customerOrder.setQuantity(event.productId, event.quantity);

        yield CartItemsState(
            products: customerOrder.items,
            totalAmount: customerOrder.totalAmount);
      } else if (event is FOCQuantityChanged) {
        customerOrder.setFOCQuantity(event.productId, event.quantity);

        yield CartItemsState(
            products: customerOrder.items,
            totalAmount: customerOrder.totalAmount);
      } else if (event is SubmitOrder) {
        if (customerOrder.items.length > 0) {
          if (validateItemsQuantity(customerOrder.items)) {
            yield ValidSubmission(customerOrder: customerOrder);
          } else {
            yield InvalidSubmission(
                message: 'One or more items have invalid quantities.');
          }
        } else {
          yield InvalidSubmission(message: 'Your cart is empty.');
        }
      }
    } catch (e) {
      log('ERROR', error: e, name: 'ItemMenuBloc');
      yield ItemMenuErrorState(message: e.toString());
    }
  }

  Future<void> loadItems() async {
    customerOrder.reset();
    categories = await ItemsMenuRepo.repo.getAllCategories(Config.user.userId);
    products = await ItemsMenuRepo.repo.getAllProducts(categories);

    productPrices = await ItemsMenuRepo.repo.getProductPrices();
    productFOC = await ItemsMenuRepo.repo.getProductFoc();

    for (var p in products) {
      // ProductPrices pp;
      // for (var item in productPrices) {
      //   if (item.productId == p.productId &&
      //       item.customerGroupId == customerOrder.customer.customerGroupId) {
      //     pp = item;
      //   }
      // }

      // if (pp == null) {
      //   pp = ProductPrices(
      //     customerGroupId: p.customerGroupId,
      //     productId: p.productId,
      //     cashPrice: p.packPrice,
      //     creditPrice: p.creditPrice,
      //   );
      // }
      if (customerOrder.paymentmode == PAYMENTMODE.CASH) {
        p.price = p.packPrice;
      } else if (customerOrder.paymentmode == PAYMENTMODE.CREDIT) {
        p.price = p.creditPrice;
      }
      for (var item in productFOC) {
        if (item.productId == int.parse(p.productId)) {
          p.foc = item;
        }
      }

      if (p.foc == null) {
        p.foc = ProductFoc(
            start: 0, end: 0, quantity: 0, productId: int.parse(p.productId));
      }
    }
  }

  bool validateItemsQuantity(List<Product> items) {
    bool valid = true;
    items.forEach((p) {
      if (p.quantity <= 0) {
        valid = false;
      }
    });
    return valid;
  }
}
