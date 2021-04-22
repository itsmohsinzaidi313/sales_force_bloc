import 'package:sales_force/database/tables/product_prices_table.dart';

class ProductPrices {
  String productId;
  String customerGroupId;
  String cashPrice;
  String creditPrice;

  ProductPrices(
      {this.productId, this.customerGroupId, this.cashPrice, this.creditPrice});

  ProductPrices.withMap(List<dynamic> e) {
    productId = e[0]['product_id'].toString();
    customerGroupId = e[0]['customer_group_id'].toString();
    cashPrice = e[0]['cash_price'].toString();
    creditPrice = e[0]['credit_price'].toString();
  }

  List<String> getList() {
    return [
      this.productId,
      this.customerGroupId,
      this.cashPrice,
      this.creditPrice
    ];
  }

  Map<String, dynamic> getMapForInsert() => {
        TableProductPrices.productId: productId,
        TableProductPrices.customerGroupId: customerGroupId,
        TableProductPrices.cashPrice: cashPrice,
        TableProductPrices.creditPrice: creditPrice
      };
}
