import 'package:sales_force/database/tables/categories_table.dart';
import 'package:sales_force/models/objects/category_permissions.dart';

class Category {
  String categoryId;
  String userId;
  String title;
  String image;
  String createdon;
  String modifiedon;
  List<dynamic> _salesman;

  Category(
      {this.categoryId,
      this.userId,
      this.title,
      this.image,
      this.createdon,
      this.modifiedon});

  Category.withMap(List<dynamic> i) {
    this.categoryId = i[0]['product_category_id'].toString();
    this.userId = i[0]['user_id'].toString();
    this.title = i[0]['product_category_title'];
    this.image = i[0]['product_category_image'];
    this.createdon = i[0]['createdon'];
    this.modifiedon = i[0]['modifiedon'];
    _salesman = i[0]['salesman'];
  }

  List<CategoryPermissions> getCategoryPermissions() {
    List<CategoryPermissions> list = [];
    _salesman.forEach((e) {
      list.add(new CategoryPermissions(
          categoryId: e['product_category_id'].toString(),
          userId: e['user_id'].toString()));
    });
    return list;
  }

  getList() {
    return [
      this.categoryId,
      this.userId,
      this.title,
      this.image,
      this.createdon,
      this.modifiedon
    ];
  }

  Map<String, dynamic> getMap() => {
        TableCategories.categoryId: categoryId,
        TableCategories.userId: userId,
        TableCategories.title: title,
        TableCategories.image: image,
        TableCategories.createdOn: createdon,
        TableCategories.modifiedOn: modifiedon
      };
}
