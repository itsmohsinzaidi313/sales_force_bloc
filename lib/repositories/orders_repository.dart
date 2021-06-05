import 'dart:developer';

import 'package:geolocator/geolocator.dart';
import 'package:sales_force/database/tables/order_detail_table.dart';
import 'package:sales_force/database/tables/order_master_table.dart';
import 'package:sales_force/database/tables/products_table.dart';
import 'package:sales_force/database/tables/visits_table.dart';
import 'package:sales_force/models/objects/customer_order.dart';
import 'package:sales_force/models/objects/product.dart';
import 'package:sales_force/shared/config.dart';
import 'package:sales_force/shared/library.dart';
import 'package:sqflite/sqflite.dart';

class OrdersRepo {
  static OrdersRepo repo = OrdersRepo._internal(database: Config.database);
  final Future<Database> database;
  OrdersRepo._internal({this.database});

  Future<List<Map<String, dynamic>>> getOrders(
          {String userId, String customerId, String from, String to}) async =>
      (await (await database).query(TableOrderMaster.tableName,
          where:
              '${TableOrderMaster.userId} = ? and ${TableOrderMaster.customerId} = ? and ${TableOrderMaster.createdOn} between ? and ?',
          whereArgs: [userId, customerId, '$from 00:00:00', '$to 23:59:59'],
          orderBy: '${TableOrderMaster.id} desc'));

  Future<List<Product>> getOrdersDetail({String masterId}) async {
    final list = (await (await database).query(TableOrderDetail.tableName,
            where: '${TableOrderDetail.masterId} = ?', whereArgs: [masterId]))
        .toList();
    List<Product> products = [];
    for (Map<String, dynamic> item in list) {
      products.add((await (await database).query(TableProducts.tableName,
              where: '${TableProducts.productId} = ?',
              whereArgs: [item[TableOrderDetail.productId]]))
          .map((e) {
        Product p = Product.withMap([e]);
        p.purchasedQuantity = item[TableOrderDetail.totalPacks].toString();
        p.focQuantity = item[TableOrderDetail.sampleQty];
        p.packPrice = item[TableOrderDetail.pricePerPack].toString();

        return p;
      }).first);
    }
    return products;
  }

  Future<bool> saveOrder(Order order) async {
    Database db = await database;
    int masterId =
        await db.insert(TableOrderMaster.tableName, order.orderMaster);
    Position position = await Geolocator.getCurrentPosition();
    await db.insert(TableVisits.tableName, {
      TableVisits.customerId: order.customer.customerId,
      TableVisits.userId: order.user.userId,
      TableVisits.latitude: position.latitude,
      TableVisits.longitude: position.longitude,
      TableVisits.isOrder: 1,
      TableVisits.createdOn: Library.getDateTime(),
      TableVisits.isUpload: 0,
      TableVisits.orderId: masterId
    });
    if (masterId > 0) {
      List<Map<String, dynamic>> detail = order.orderDetail;
      Batch batch = db.batch();
      detail.forEach((detail) async {
        detail[TableOrderDetail.masterId] = masterId;
        batch.insert(TableOrderDetail.tableName, detail);
      });
      List<dynamic> detailId = await batch.commit();
      if (detailId.length == detail.length) {
        return true;
      }
    }
    return false;
  }
}
