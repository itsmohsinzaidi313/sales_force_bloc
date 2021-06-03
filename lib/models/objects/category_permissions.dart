import 'package:sales_force/database/tables/category_permissions.dart';

class CategoryPermissions {
  int categoryId;
  int userId;

  CategoryPermissions({this.categoryId, this.userId});
  
  CategoryPermissions.withMap(Map<String, dynamic> map)
      : this.categoryId = map[TableCategoryPermissions.categoryId],
        this.userId = map[TableCategoryPermissions.userId];

  List<CategoryPermissions> getList() {
    return <CategoryPermissions>[
      CategoryPermissions(categoryId: this.categoryId, userId: this.userId)
    ];
  }

  Map<String, dynamic> getMap() => {
        TableCategoryPermissions.categoryId: categoryId,
        TableCategoryPermissions.userId: userId
      };

  Map<String, dynamic> getCategoryIdMap() {
    return {'category_id': categoryId};
  }

  Map<String, dynamic> getUserIdMap() {
    return {'user_id': userId.toString()};
  }

  String getUserId() {
    return userId.toString();
  }

  String getCategoryId() {
    return this.categoryId.toString();
  }
}
