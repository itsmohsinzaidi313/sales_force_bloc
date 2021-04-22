import 'package:sales_force/bloc/verbose_bloc/verbose_bloc.dart';
import 'package:sales_force/database/sql_commons.dart';
import 'package:sqflite_common/sqlite_api.dart';

class TableCategories extends SqlCommons {
  TableCategories(Database database, VerboseBloc bloc)
      : super(tableName, columns, columnTypes, database, bloc);

  static const String tableName = 'categories';
  static const String id = 'id',
      categoryId = 'product_category_id',
      userId = 'user_id',
      title = 'product_category_title',
      image = 'product_category_image',
      createdOn = 'createdon',
      modifiedOn = 'modifiedon';
  static const List<String> columns = [
    id,
    categoryId,
    userId,
    title,
    image,
    createdOn,
    modifiedOn,
  ];
  static const List<String> columnTypes = [
    SqlCommons.INT_PRIMARYKEY,
    SqlCommons.INTEGER,
    SqlCommons.INTEGER,
    SqlCommons.TEXT,
    SqlCommons.TEXT,
    SqlCommons.TEXT,
    SqlCommons.TEXT,
  ];
}
