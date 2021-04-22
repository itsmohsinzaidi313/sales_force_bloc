import 'package:sales_force/models/objects/product.dart';
import 'package:sales_force/models/objects/product_foc.dart';
import 'package:sales_force/models/objects/product_prices.dart';
import 'package:sales_force/models/objects/sync_packet.dart';
import 'package:sales_force/models/objects/user.dart';
import 'package:sales_force/models/objects/user_type.dart';
import 'category.dart';
import 'category_permissions.dart';
import 'customer.dart';
import 'customer_group.dart';
import 'invoice.dart';

class DataLists {
  static List<UserType> listUserTypes;
  static List<User> listUsers;
  static List<Category> listCategories;
  static List<Product> listProduct;
  static List<Invoice> listInvoice;
  static List<CustomerGroup> listCustomerGroups;
  static List<ProductPrices> listProductPrices;
  static List<Customer> listCustomer;
  static List<CategoryPermissions> listCategoryPermissions;
  static List<SyncPacket> listSyncPackets;
  static List<ProductFoc> listProductFoc;

  DataLists(
      {listUserTypes,
      listCategories,
      listInvoice,
      listProduct,
      listUsers,
      listCustomerGroups,
      listPCGPrices,
      listCustomer,
      listCategoryPermissions,
      listSyncPackets,
      listProductFoc});

  static void clear() {
    listUserTypes.clear();
    listUsers.clear();
    listCategories.clear();
    listProduct.clear();
    listInvoice.clear();
    listCustomerGroups.clear();
    listProductPrices.clear();
    listCustomer.clear();
    listCategoryPermissions.clear();
    listSyncPackets.clear();
    listProductFoc.clear();
  }
}
