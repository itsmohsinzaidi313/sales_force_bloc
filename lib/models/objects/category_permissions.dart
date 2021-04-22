import 'package:sales_force/database/tables/category_permissions.dart';

class CategoryPermissions {
  String categoryId;
  String userId;

  CategoryPermissions({this.categoryId, this.userId});

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
    return userId;
  }

  String getCategoryId() {
    return this.categoryId;
  }
}
