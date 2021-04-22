import 'package:sales_force/bloc/verbose_bloc/verbose_bloc.dart';
import 'package:sales_force/database/sql_commons.dart';
import 'package:sqflite_common/sqlite_api.dart';

class TableProducts extends SqlCommons {
  TableProducts(Database database, VerboseBloc bloc)
      : super(tableName, columns, dataTypes, database, bloc);

  static const String tableName = 'products';
  static const String id = 'id',
      productId = 'product_id',
      categoryId = 'product_category_id',
      typeId = 'product_type_id',
      userId = 'user_id',
      title = 'product_title',
      packPrice = 'product_pack_price',
      packsPerCarton = 'product_packs_per_carton',
      cartonPrice = 'product_carton_price',
      literPrice = 'product_price_per_liter',
      discountType = 'discount_type',
      discount = 'discount',
      isActive = 'isActive',
      createdOn = 'createdon',
      modifiedon = 'modifiedon',
      image = 'product_image';
  static const List<String> columns = [
    id,
    productId,
    categoryId,
    typeId,
    userId,
    title,
    packPrice,
    packsPerCarton,
    cartonPrice,
    literPrice,
    discountType,
    discount,
    isActive,
    createdOn,
    modifiedon,
    image
  ];
  static const List<String> dataTypes = [
    SqlCommons.INT_PRIMARYKEY,
    SqlCommons.INTEGER,
    SqlCommons.INTEGER,
    SqlCommons.INTEGER,
    SqlCommons.INTEGER,
    SqlCommons.TEXT,
    SqlCommons.REAL,
    SqlCommons.INTEGER,
    SqlCommons.REAL,
    SqlCommons.REAL,
    SqlCommons.TEXT,
    SqlCommons.REAL,
    SqlCommons.INTEGER,
    SqlCommons.TEXT,
    SqlCommons.TEXT,
    SqlCommons.TEXT,
  ];
}
