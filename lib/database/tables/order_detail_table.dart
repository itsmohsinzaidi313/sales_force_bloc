import 'package:sales_force/bloc/verbose_bloc/verbose_bloc.dart';
import 'package:sales_force/database/sql_commons.dart';
import 'package:sqflite_common/sqlite_api.dart';

class TableOrderDetail extends SqlCommons {
  TableOrderDetail(Database database, VerboseBloc bloc)
      : super(tableName, columns, dataTypes, database, bloc) {
        skipDelete = true;
      }

  static const String tableName = 'order_detail';
  static const String id = 'id',
      masterId = 'master_id',
      categoryId = 'product_category_id',
      productId = 'product_id',
      totalPacks = 'order_product_total_packs',
      sampleQty = 'order_product_free_qty',
      pricePerPack = 'order_product_price_per_pack',
      discountPerPack = 'order_product_discount_per_pack',
      packDiscount = 'order_product_discounted_pack_price',
      discount = 'order_product_total_discount',
      totalPrice = 'order_product_total_price',
      image = 'product_image';
  static const List<String> columns = [
    id,
    masterId,
    categoryId,
    productId,
    totalPacks,
    sampleQty,
    pricePerPack,
    discountPerPack,
    packDiscount,
    discount,
    totalPrice,
    image
  ];
  static const List<String> dataTypes = [
    SqlCommons.INT_PRIMARYKEY,
    SqlCommons.INTEGER,
    SqlCommons.INTEGER,
    SqlCommons.INTEGER,
    SqlCommons.INTEGER,
    SqlCommons.INTEGER,
    SqlCommons.REAL,
    SqlCommons.REAL,
    SqlCommons.REAL,
    SqlCommons.REAL,
    SqlCommons.REAL,
    SqlCommons.TEXT,
  ];
}
