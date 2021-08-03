import 'dart:convert';
import 'dart:developer';
import 'package:sales_force/bloc/verbose_bloc/verbose_bloc.dart';
import 'package:sales_force/database/tables/order_detail_table.dart';
import 'package:sales_force/database/tables/order_master_table.dart';
import 'package:sales_force/database/tables/visits_table.dart';
import 'package:sales_force/services/service_common.dart';
import 'package:sales_force/shared/config.dart';
import 'package:sales_force/shared/library.dart';
import 'package:sqflite/sqflite.dart';

class SPostOrder extends ServiceCommon {
  Database db;
  SPostOrder(Database db, {VerboseBloc bloc}) {
    this.db = db;
    this.verboseBloc = bloc;
    initiate();
  }

  @override
  String get name => 'Orders Service';

  @override
  perform() async {
    cycleComplete = false;
    await uploadOrders();
  }

  Future<void> uploadOrders() async {
    List<Map<String, dynamic>> master = await db.query(
        TableOrderMaster.tableName,
        columns: [
          '${TableOrderMaster.id} as order_android_id',
          TableOrderMaster.userId,
          TableOrderMaster.customerId,
          TableOrderMaster.amount,
          TableOrderMaster.discount,
          TableOrderMaster.orderType,
          TableOrderMaster.total,
          TableOrderMaster.status,
          TableOrderMaster.deliveryDate,
          TableOrderMaster.createdOn,
          TableOrderMaster.spoDiscount
        ],
        where:
            '${TableOrderMaster.userId} = ? and ${TableOrderMaster.status} = ?',
        whereArgs: [Config.user.userId, 0]);

    if (master != null)
      master.forEach((e) async {
        Map<String, dynamic> map = Map();
        List<Map<String, dynamic>> detail =
            await db.query(TableOrderDetail.tableName,
                columns: [
                  '${TableOrderDetail.masterId} as order_id',
                  TableOrderDetail.categoryId,
                  TableOrderDetail.productId,
                  TableOrderDetail.totalPacks,
                  TableOrderDetail.sampleQty,
                  TableOrderDetail.pricePerPack,
                  TableOrderDetail.discountPerPack,
                  TableOrderDetail.packDiscount,
                  TableOrderDetail.discount,
                  TableOrderDetail.totalPrice
                ],
                where: '${TableOrderDetail.masterId} = ?',
                whereArgs: [e['order_android_id']]);
        e.forEach((k, v) {
          map[jsonEncode(k)] = jsonEncode(v);
        });
        map[jsonEncode('order_product')] = jsonEncode(detail);
        List<Map<String, dynamic>> locationMap = await db.query(
            TableVisits.tableName,
            columns: [
              '${TableVisits.id} as order_taken_android_id',
              '${TableVisits.customerId} as order_taken_customer_id',
              '${TableVisits.userId} as order_taken_visit_admin_users_id_parcosf',
              '${TableVisits.latitude} as order_taken_visit_lat',
              '${TableVisits.longitude} as order_taken_visit_long',
              '${TableVisits.isOrder} as order_taken_visit_isorder',
              '${TableVisits.createdOn} as order_taken_visit_createdon',
              TableVisits.orderId,
            ],
            where: '${TableVisits.isOrder} = ? and ${TableVisits.orderId} = ?',
            whereArgs: [1, e['order_android_id']]);
        map = {
          '${jsonEncode('visit_data')}': jsonEncode(locationMap),
          jsonEncode('order'): [map]
        };
        log(map.toString(), name: this.name);
        bool status = await Library.uploadToServer(Config.putOrderVisitAPILink,
            jsonString: map.toString());
        if (status) {
          await db.update(TableOrderMaster.tableName,
              {TableOrderMaster.status: status ? 1 : 0},
              where: '${TableOrderMaster.id} = ?',
              whereArgs: [e['order_android_id']]);
          await db.update(
              TableVisits.tableName, {TableVisits.isUpload: status ? 1 : 0},
              where:
                  '${TableVisits.isOrder} = ? and ${TableVisits.orderId} = ?',
              whereArgs: [1, e['order_android_id']]);
          this.verboseBloc.add(VerboseNotify(message: 'Order Uploaded'));
        } else {
          await db.delete(TableOrderMaster.tableName,
              where: '${TableOrderMaster.id} = ?',
              whereArgs: [e['order_android_id']]);
          await db.delete(TableOrderDetail.tableName,
              where: '${TableOrderDetail.masterId} = ?',
              whereArgs: [e['order_android_id']]);
          await db.delete(TableVisits.tableName,
              where: '${TableVisits.orderId} = ?',
              whereArgs: [e['order_android_id']]);
        }
      });
    cycleComplete = true;
  }
}
