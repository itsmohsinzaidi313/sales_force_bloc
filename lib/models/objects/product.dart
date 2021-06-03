import 'package:sales_force/database/tables/products_table.dart';
import 'package:sales_force/models/objects/product_foc.dart';
import 'package:sales_force/models/objects/product_prices.dart';

class Product {
  String productId;
  String categoryId;
  String typeId;
  String userId;
  String title;
  String packPrice;
  String creditPrice;
  String packPerCarton;
  String cartonPrice;
  String pricePerLiter;
  String discountType;
  String discount;
  String isActive;
  String createdon;
  String modifiedon;
  String customerGroupId;
  String purchasedQuantity;
  String image;
  int quantity = 1;
  int focQuantity = 0;
  bool focOverride = false;
  String price;
  List<dynamic> _customerGroupPrices;
  ProductFoc foc;

  Product(
      {this.productId,
      this.categoryId,
      this.typeId,
      this.userId,
      this.title,
      this.packPrice,
      this.creditPrice,
      this.packPerCarton,
      this.cartonPrice,
      this.pricePerLiter,
      this.discount,
      this.discountType,
      this.isActive,
      this.createdon,
      this.modifiedon,
      this.purchasedQuantity,
      this.image,
      this.focQuantity}) {
    this.quantity = 1;
  }

  Product.withProduct({Product product}) {
    this.productId = product.productId;
    this.categoryId = product.categoryId;
    this.typeId = product.typeId;
    this.userId = product.userId;
    this.title = product.title;
    this.packPrice = product.packPrice;
    this.creditPrice = product.creditPrice;
    this.packPerCarton = product.packPerCarton;
    this.cartonPrice = product.cartonPrice;
    this.pricePerLiter = product.pricePerLiter;
    this.discount = product.discount;
    this.discountType = product.discountType;
    this.isActive = product.isActive;
    this.createdon = product.createdon;
    this.modifiedon = product.modifiedon;
    this.purchasedQuantity = product.purchasedQuantity;
    this.quantity = product.quantity;
    this.focQuantity = product.focQuantity;
    this.price = product.price;
    this.foc = product.foc;
  }

  Product.withMap(List<dynamic> i) {
    this.productId = i[0]['product_id'].toString();
    this.categoryId = i[0]['product_category_id'].toString();
    this.typeId = i[0]['product_type_id'].toString();
    this.userId = i[0]['user_id'].toString();
    this.title = i[0]['product_title'];
    this.packPrice = i[0]['product_pack_price'].toString();
    this.creditPrice = i[0]['product_credit_price'].toString();
    this.packPerCarton = i[0]['product_packs_per_carton'].toString();
    this.cartonPrice = i[0]['product_carton_price'].toString();
    this.pricePerLiter = i[0]['product_price_per_liter'].toString();
    this.image = i[0]['product_image'];
    this.discount = i[0]['discount'].toString();
    this.discountType = i[0]['discount_type'].toString();
    this.isActive = i[0]['isActive'].toString();
    this.createdon = i[0]['createdon'];
    this.modifiedon = i[0]['modifiedon'];
    this._customerGroupPrices = i[0]['customer_group_prices'];
  }

  getCustomerGroupPrices() {
    List<ProductPrices> list = [];
    if (_customerGroupPrices != null)
      _customerGroupPrices.forEach((e) {
        list.add(new ProductPrices(
            productId: e['product_id'].toString(),
            customerGroupId: e['customer_group_id'].toString(),
            cashPrice: e['cash_price'].toString(),
            creditPrice: e['credit_price'].toString()));
      });
    return list;
  }

  List getList() {
    return [
      this.productId,
      this.categoryId,
      this.typeId,
      this.userId,
      this.title,
      this.packPrice,
      this.packPerCarton,
      this.cartonPrice,
      this.pricePerLiter,
      this.discountType,
      this.discount,
      this.isActive,
      this.createdon,
      this.modifiedon,
      this.image
    ];
  }

  add() {
    this.quantity++;
  }

  less() {
    int difference = this.quantity - 1;
    if (difference >= 0) {
      quantity--;
    }
  }

  addFoc() {
    this.focQuantity++;
  }

  lessFoc() {
    int difference = this.focQuantity - 1;
    if (difference >= 0) {
      focQuantity--;
    }
  }

  setQuantity(int quantity) {
    this.quantity = quantity;
  }

  setFocQuantity(int focQuantity) {
    this.focQuantity = focQuantity;
  }

  getPrice() {
    return double.parse(packPrice) * quantity;
  }

  getNetworkImage() {
    if (this.image == null || this.image == '')
      return 'https://www.freeiconspng.com/uploads/no-image-icon-23.jpg';
    else
      return this.image;
  }

  Map<String, dynamic> getMapForUpdate() => {
        TableProducts.categoryId: categoryId,
        TableProducts.typeId: typeId,
        TableProducts.userId: userId,
        TableProducts.title: title,
        TableProducts.packPrice: packPrice,
        TableProducts.packsPerCarton: packPerCarton,
        TableProducts.cartonPrice: cartonPrice,
        TableProducts.literPrice: pricePerLiter,
        TableProducts.discountType: discountType,
        TableProducts.discount: discount,
        TableProducts.isActive: isActive,
        TableProducts.createdOn: createdon,
        TableProducts.modifiedon: modifiedon,
        TableProducts.image: image,
      };

  Map<String, dynamic> getMapForInsert() => {
        TableProducts.productId: productId,
        TableProducts.categoryId: categoryId,
        TableProducts.typeId: typeId,
        TableProducts.userId: userId,
        TableProducts.title: title,
        TableProducts.packPrice: packPrice,
        TableProducts.packsPerCarton: packPerCarton,
        TableProducts.cartonPrice: cartonPrice,
        TableProducts.literPrice: pricePerLiter,
        TableProducts.discountType: discountType,
        TableProducts.discount: discount,
        TableProducts.isActive: isActive,
        TableProducts.createdOn: createdon,
        TableProducts.modifiedon: modifiedon,
        TableProducts.image: image
      };
}
