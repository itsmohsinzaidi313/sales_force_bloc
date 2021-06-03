import 'dart:developer';

import 'package:sales_force/database/tables/categories_table.dart';
import 'package:sales_force/database/tables/category_permissions.dart';
import 'package:sales_force/database/tables/customer_table.dart';
import 'package:sales_force/database/tables/product_foc_table.dart';
import 'package:sales_force/database/tables/product_prices_table.dart';
import 'package:sales_force/database/tables/products_table.dart';
import 'package:sales_force/models/objects/category.dart';
import 'package:sales_force/models/objects/category_permissions.dart';
import 'package:sales_force/models/objects/product.dart';
import 'package:sales_force/models/objects/product_foc.dart';
import 'package:sales_force/models/objects/product_prices.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sales_force/shared/config.dart';

class ItemsMenuRepo {
  static ItemsMenuRepo repo =
      ItemsMenuRepo._internal(database: Config.database);
  final Future<Database> database;
  ItemsMenuRepo._internal({this.database});

  Future<List<Product>> getAllProducts(List<Category> categories) async {
    String categoryIds = '';
    categories.forEach((element) => categoryIds += '${element.categoryId},');
    categoryIds = categoryIds.substring(0, categoryIds.length - 1);

    return (await (await database).rawQuery(
            'select * from ${TableProducts.tableName} where ${TableProducts.categoryId} in ($categoryIds)'))
        .map((e) => Product.withMap([e]))
        .toList();
  }

  Future<Product> getProduct({String productId, String categoryId}) async {
    if (productId != null ||
        categoryId != null ||
        productId != '' ||
        categoryId != '') {
      if (productId != '') {
        return (await (await database).query(TableProducts.tableName,
                where: '${TableProducts.productId} = ?',
                whereArgs: [productId]))
            .map((e) => Product.withMap([e]))
            .first;
      } else if (categoryId != '') {
        return (await (await database).query(TableProducts.tableName,
                where: '${TableProducts.categoryId} = ?',
                whereArgs: [categoryId]))
            .map((e) => Product.withMap([e]))
            .first;
      } else {
        throw Exception('Either provide product id or category id');
      }
    } else {
      throw Exception('Either provide product id or category id');
    }
  }

  Future<List<Product>> searchProducts(String userId, String phrase) async =>
      (await (await database).query(TableProducts.tableName,
              where:
                  '${TableProducts.userId} = ? and ${TableProducts.title} like ?',
              whereArgs: [userId, '%$phrase%']))
          .map((e) => Product.withMap([e]))
          .toList();

  Future<List<Category>> getAllCategories(String userId) async => (await (await database).rawQuery(
            "select a.* from ${TableCategories.tableName} a join ${TableCategoryPermissions.tableName} b on b.${TableCategoryPermissions.categoryId} = a.${TableCategories.categoryId} where b.${TableCategoryPermissions.userId} = ?",
            [userId]))
        .map((e) => Category.withMap([e]))
        .toList();

  Future<List<ProductPrices>> getProductPrices() async =>
      (await (await database).query(TableProductPrices.tableName))
          .map((e) => ProductPrices.withMap([e]))
          .toList();
  

  Future<List<ProductFoc>> getProductFoc() async =>
      (await (await database).query(TableProductFOC.tableName))
          .map((e) => ProductFoc(
              productId: e[TableProductFOC.productId],
              quantity: e[TableProductFOC.quantity],
              start: e[TableProductFOC.start],
              end: e[TableProductFOC.end]))
          .toList();

  Future<String> getCustomerGroupId(String customerId) async =>
      (await (await database).query(TableCustomer.tableName,
              where: '${TableCustomer.customerId} = ?',
              whereArgs: [customerId]))
          .first[TableCustomer.customerGroupId];
}
