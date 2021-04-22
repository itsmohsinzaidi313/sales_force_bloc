import 'package:sales_force/database/tables/categories_table.dart';
import 'package:sales_force/database/tables/product_prices_table.dart';
import 'package:sales_force/database/tables/products_table.dart';
import 'package:sales_force/models/objects/category.dart';
import 'package:sales_force/models/objects/product.dart';
import 'package:sales_force/models/objects/product_prices.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sales_force/shared/config.dart';

class ItemsMenuRepo {
  static ItemsMenuRepo repo =
      ItemsMenuRepo._internal(database: Config.database);
  final Future<Database> database;
  ItemsMenuRepo._internal({this.database});

  Future<List<Product>> getAllProducts(String userId) async =>
      (await (await database).query(TableProducts.tableName,
              where: '${TableProducts.userId} = ?', whereArgs: [userId]))
          .map((e) => Product.withMap([e]))
          .toList();
  Future<Product> getProduct(String productId) async =>
      (await (await database).query(TableProducts.tableName,
              where: '${TableProducts.productId} = ?', whereArgs: [productId]))
          .map((e) => Product.withMap([e]))
          .first;

  Future<List<Product>> searchProducts(String userId, String phrase) async =>
      (await (await database).query(TableProducts.tableName,
              where:
                  '${TableProducts.userId} = ? and ${TableProducts.title} like ?',
              whereArgs: [userId, '%$phrase%']))
          .map((e) => Product.withMap([e]))
          .toList();

  Future<List<Category>> getAllCategories(String userId) async =>
      (await (await database).query(TableCategories.tableName,
              where: '${TableCategories.userId} = ?',
              whereArgs: [int.parse(userId)]))
          .map((e) => Category.withMap([e]))
          .toList();

          Future<List<ProductPrices>> getProductPrices() async => (await (await database).query(TableProductPrices.tableName))
          .map((e) => ProductPrices.withMap([e]))
          .toList();
}
