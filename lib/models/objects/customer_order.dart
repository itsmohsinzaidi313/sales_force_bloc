import 'package:sales_force/database/tables/order_detail_table.dart';
import 'package:sales_force/database/tables/order_master_table.dart';
import 'package:sales_force/models/objects/customer.dart';
import 'package:sales_force/models/objects/product.dart';
import 'package:sales_force/models/objects/user.dart';
import 'package:sales_force/shared/config.dart';
import 'package:sales_force/shared/constants.dart';
import 'package:sales_force/shared/library.dart';

class Order {
  List<Product> items = [];
  Customer customer;
  String discountPercent;
  String discountAmount;
  String receivable;
  User user;
  PAYMENTMODE paymentmode;
  List<Product> get cartItems => items ?? [];

  void setQuantity(String productId, int quantity) =>
      items.where((p) => p.productId == productId).first.quantity = quantity;

  void setFOCQuantity(String productId, int focQuantity) =>
      items.where((p) => p.productId == productId).first.focQuantity =
          focQuantity;

  void addCartItem(Product item) {
    if (items == null) items = [];
    bool itemExists = false;
    for (var i = 0; i < items.length; i++) {
      if (items[i].productId == item.productId) {
        items[i].quantity++;
        itemExists = true;
        break;
      }
    }
    if (!itemExists) {
      items.add(Product.withProduct(product: item));
    }
  }

  void reduceCartItem(int itemId, {bool removeZeroQuantity = true}) {
    if (items == null) items = [];
    for (var i = 0; i < items.length; i++) {
      if (items[i].productId == '$itemId') {
        if (items[i].quantity > 0) {
          items[i].quantity--;
        }
        if (items[i].quantity < 1 && removeZeroQuantity) {
          removeCartItem(itemId);
        }
        break;
      }
    }
  }

  void removeCartItem(int itemId) => items
      .removeAt(items.indexWhere((element) => element.productId == '$itemId'));

  String get totalAmount {
    double total = 0;
    items.forEach((e) {
      total += double.parse(e.price) * e.quantity;
    });
    return total.toStringAsFixed(2);
  }

  void reset() {
    user = Config.user;
    items = [];
  }

  void copyOrder(Order order) {
    items = order.items;
  }

  void setDiscount(double discount) {
    if (customer.discountType == 'p') {
      discountPercent = discount.toString();
      discountAmount =
          (double.parse(totalAmount) * (discount / 100.0)).toString();
    } else {
      discountPercent =
          (discount / (double.parse(totalAmount) * 100)).toString();
      discountAmount = discount.toString();
    }
    receivable =
        (double.parse(totalAmount) - double.parse(discountAmount)).toString();
  }

  Map<String, dynamic> get orderMaster => {
        TableOrderMaster.userId: user.userId,
        TableOrderMaster.customerId: customer.customerId,
        TableOrderMaster.amount: receivable,
        TableOrderMaster.discount: discountAmount,
        TableOrderMaster.total: totalAmount,
        TableOrderMaster.status: 0,
        TableOrderMaster.deliveryDate: Library.getDate(),
        TableOrderMaster.spoDiscount: discountPercent,
        TableOrderMaster.createdOn: Library.getDateTime()
      };

  List<Map<String, dynamic>> get orderDetail => items
      .map((e) => {
            TableOrderDetail.masterId: 0,
            TableOrderDetail.categoryId: e.categoryId,
            TableOrderDetail.productId: e.productId,
            TableOrderDetail.totalPacks: e.quantity,
            TableOrderDetail.sampleQty: e.focQuantity,
            TableOrderDetail.pricePerPack: e.price,
            TableOrderDetail.discountPerPack: '0',
            TableOrderDetail.discount: e.discount,
            TableOrderDetail.totalPrice: e.quantity * double.parse(e.price),
          })
      .toList();
}
