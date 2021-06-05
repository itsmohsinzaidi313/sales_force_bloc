import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:sales_force/bloc/verbose_bloc/verbose_bloc.dart';
import 'package:sales_force/database/tables/categories_table.dart';
import 'package:sales_force/database/tables/category_permissions.dart';
import 'package:sales_force/database/tables/customer_table.dart';
import 'package:sales_force/database/tables/invoices_table.dart';
import 'package:sales_force/database/tables/product_prices_table.dart';
import 'package:sales_force/database/tables/products_table.dart';
import 'package:sales_force/database/tables/sync_apis_table.dart';
import 'package:sales_force/database/tables/users_table.dart';
import 'package:sales_force/shared/library.dart';
import 'package:sales_force/models/objects/category.dart';
import 'package:sales_force/models/objects/category_permissions.dart';
import 'package:sales_force/models/objects/customer.dart';
import 'package:sales_force/models/objects/invoice.dart';
import 'package:sales_force/models/objects/product.dart';
import 'package:sales_force/models/objects/product_prices.dart';
import 'package:sales_force/models/objects/sync_packet.dart';
import 'package:sales_force/models/objects/user.dart';
import 'package:sales_force/services/service_common.dart';
import 'package:sqflite/sqflite.dart';

import '../shared/config.dart';

class SSyncService extends ServiceCommon {
  Database db;
  List<SyncPacket> listSyncPackets = [];
  SSyncService(Database database, {VerboseBloc bloc}) {
    initiate();
    this.db = database;
    this.verboseBloc = bloc;
  }

  @override
  String get name => 'Sync Service';

  @override
  Future<void> perform() async {
    cycleComplete = false;
    if (await Library.hasServerAccess()) {
      await syncData();
    }
    cycleComplete = true;
  }

  Future<bool> getSyncApis() async {
    DateTime dateTime = DateTime.now();
    dateTime = new DateTime(dateTime.year, dateTime.month, dateTime.day - 1);
    String url =
        '${Config.syncAPILink}${DateFormat('yyyy-MM-dd,HH:mm:ss').format(dateTime)}';
    Response response = await get(Uri.parse(url)).timeout(
        Duration(seconds: Config.ConnectionTimeout),
        onTimeout: () => null);
    if (response != null && response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);
      if (data['data'] != null) {
        (data['data'] as List<dynamic>).forEach((element) async {
          List<Map<String, dynamic>> list = await db.query(
              TableSyncApis.tableName,
              columns: [TableSyncApis.id],
              where: '${TableSyncApis.serverId} = ?',
              whereArgs: [element['sync_id']]);
          if (list == null || list.isEmpty) {
            SyncPacket packet = SyncPacket.fromMap(element);
            // server_id, module, operation, url, createdon, is_used
            await db.insert(TableSyncApis.tableName, {
              TableSyncApis.serverId: packet.serverId,
              TableSyncApis.module: packet.module,
              TableSyncApis.operation: packet.operation,
              TableSyncApis.url: packet.url,
              TableSyncApis.createdOn: packet.createdOn,
              TableSyncApis.isUsed: 0
            });
          }
        });
        return true;
      }
    }
    return false;
  }

  Future<void> syncData() async {
    try {
      await getSyncApis();
      List<SyncPacket> list = await getApis();
      list.forEach((e) async {
        Response response = await get(Uri.parse(e.url)).timeout(
            Duration(seconds: Config.ConnectionTimeout), onTimeout: () {
          log('CONNECTION TIMEOUT\nSYNC FAILED');
          return null;
        });
        if (response != null && response.statusCode == 200) {
          Map<String, dynamic> data = jsonDecode(response.body);
          bool status = data['status'].toString().toUpperCase() == 'FAILED'
              ? false
              : true;
          if (status) {
            data = data['data'];
            // INVOICES
            if (e.module == 'invoice') {
              Invoice invoice = new Invoice.withMap(data['invoices']);
              if (e.operation == 'insert') {
                insertInvoice(db, invoice, e.serverId);
              }
            }
            // CUSTOMERS
            else if (e.module == 'customer') {
              Customer customer = new Customer.withMap(data['customers']);
              if (e.operation == 'create') {
                insertCustomer(db, customer, e.serverId);
              }
              if (e.operation == 'update')
                updateCustomer(db, customer, e.serverId);
            }
            // USERS
            else if (e.module == 'user') {
              User user = new User.withMap(data['users']);
              if (e.operation == 'insert') insertUser(db, user, e.serverId);
              if (e.operation == 'update') updateUser(db, user, e.serverId);
            }
            // CATEGORIES
            else if (e.module == 'category') {
              Category category = new Category.withMap(data['categories']);
              if (e.operation == 'insert') {
                insertCategory(db, category, category.getCategoryPermissions(),
                    e.serverId);
              } else if (e.operation == 'update') {
                updateCategory(db, category, category.getCategoryPermissions(),
                    e.serverId);
              }
            }
            // PRODUCTS
            else if (e.module == 'product') {
              Product product = new Product.withMap(data['products']);
              if (e.operation == 'insert') {
                insertProduct(
                    db, product, product.getCustomerGroupPrices(), e.serverId);
              } else if (e.operation == 'update')
                updateProduct(
                    db, product, product.getCustomerGroupPrices(), e.serverId);
            }
          }
        } else {
          log('NO RESPONSE RECEIVED. STATUS CODE: ${response.statusCode}. SYNC FAILED');
        }
      });
    } catch (e) {
      log('ERROR ON SYNC SERVICE syncData', error: e);
    }
  }

  Future<List<SyncPacket>> getApis() async =>
      (await db.query(TableSyncApis.tableName,
              where: '${TableSyncApis.isUsed} = ?', whereArgs: [0]))
          .map((e) => SyncPacket.fromDb(e))
          .toList();

  Future<void> insertInvoice(
      Database db, Invoice invoice, String serverId) async {
    try {
      List<Map<String, dynamic>> list = await db.query(TableInvoices.tableName,
          columns: [TableInvoices.id],
          where: '${TableInvoices.number} = ?',
          whereArgs: [invoice.invoiceNumber]);
      if (list == null || list.isEmpty) {
        await db.insert(TableInvoices.tableName, invoice.getMapForInsert());
        this.verboseBloc.add(VerboseNotify(message: 'Invoice Added'));
      }
      updateSyncApiStatus(serverId);
      log('INVOICE ADDED');
    } catch (e) {
      log('NEW INVOICE INSERT FAILED', error: e);
    }
  }

  Future<void> insertCustomer(
      Database db, Customer customer, String serverId) async {
    try {
      List<Map<String, dynamic>> list = await db.query(TableCustomer.tableName,
          columns: [TableCustomer.id],
          where: '${TableCustomer.customerId} = ?',
          whereArgs: [customer.customerId]);
      if (list == null || list.isEmpty) {
        await db.insert(TableCustomer.tableName, customer.getMap());
        this.verboseBloc.add(VerboseNotify(message: 'Customer Added'));
      }
      updateSyncApiStatus(serverId);
      log('CUSTOMER ADDED');
    } catch (e) {
      log('NEW CUSTOMER INSERT FAILED', error: e);
    }
  }

  Future<void> insertUser(Database db, User user, String serverId) async {
    try {
      List<Map<String, dynamic>> list = await db.query(TableUsers.tableName,
          columns: [TableUsers.id],
          where: '${TableUsers.userId} = ?',
          whereArgs: [user.userId]);
      if (list == null || list.isEmpty) {
        await db.insert(TableUsers.tableName, user.getMap());
        this.verboseBloc.add(VerboseNotify(message: 'User Added'));
      }
      updateSyncApiStatus(serverId);
      log('USER ADDED');
    } catch (e) {
      log('NEW USER INSERT FAILED', error: e);
    }
  }

  Future<void> updateCategory(Database db, Category category,
      List<CategoryPermissions> categoryPermissions, String serverId) async {
    try {
      int rowsUpdated = await db.update(
          TableCategories.tableName, category.getMap(),
          where: '${TableCategories.categoryId} = ?',
          whereArgs: [category.categoryId]);
      if (rowsUpdated > 0) {
        await db.delete(TableCategoryPermissions.tableName,
            where: '${TableCategoryPermissions.categoryId} = ?',
            whereArgs: [category.categoryId]);
        categoryPermissions.forEach((element) async => await db.insert(
            TableCategoryPermissions.tableName, element.getMap()));
            this.verboseBloc.add(VerboseNotify(message: 'Category Updated'));
      }
      updateSyncApiStatus(serverId);
      log('CATEGORY UPDATED');
    } catch (e) {
      log('CATEGORY UPDATE FAILED', error: e);
    }
  }

  Future<void> insertProduct(Database db, Product product,
      List<ProductPrices> listProductPrices, String serverId) async {
    try {
      List<Map<String, dynamic>> list = await db.query(TableProducts.tableName,
          columns: [TableProducts.id],
          where: '${TableProducts.productId} = ?',
          whereArgs: [product.productId]);
      if (list == null || list.isEmpty) {
        int id =
            await db.insert(TableProducts.tableName, product.getMapForInsert());
        if (id > 0) {
          await db.delete(TableProductPrices.tableName,
              where: '${TableProductPrices.productId} = ?',
              whereArgs: [product.productId]);
          listProductPrices.forEach((element) async => await db.insert(
              TableProductPrices.tableName, element.getMapForInsert()));
              this.verboseBloc.add(VerboseNotify(message: 'Product Added'));
        }
      }
      log('PRODUCT ADDED');
      updateSyncApiStatus(serverId);
    } catch (e) {
      log('PRODUCT INSERT FAILED', error: e);
    }
  }

  Future<void> updateProduct(Database db, Product product,
      List<ProductPrices> productPrices, String serverId) async {
    try {
      int rowsAffected = await db.update(
          TableProducts.tableName, product.getMapForUpdate(),
          where: '${TableProducts.productId} = ?',
          whereArgs: [product.productId]);
      if (rowsAffected > 0) {
        await db.delete(TableProductPrices.tableName,
            where: '${TableProductPrices.productId} = ?',
            whereArgs: [product.productId]);
        productPrices.forEach((element) async => await db.insert(
            TableProductPrices.tableName, element.getMapForInsert()));
            this.verboseBloc.add(VerboseNotify(message: 'Product Updated'));
      }
      updateSyncApiStatus(serverId);
      log('PRODUCT UPDATED');
    } catch (e) {
      log('PRODUCT UPDATE FAILED', error: e);
    }
  }

  Future<void> insertCategory(Database db, Category category,
      List<CategoryPermissions> categoryPermissions, String serverId) async {
    try {
      List<Map<String, dynamic>> list = await db.query(
          TableCategories.tableName,
          columns: [TableCategories.id],
          where: '${TableCategories.categoryId} = ?',
          whereArgs: [category.categoryId]);
      if (list == null || list.isEmpty) {
        await db.insert(TableCategories.tableName, category.getMap());
        await db.delete(TableCategoryPermissions.tableName,
            where: '${TableCategoryPermissions.categoryId} = ?',
            whereArgs: [category.categoryId]);
        categoryPermissions.forEach((element) async => await db.insert(
            TableCategoryPermissions.tableName, element.getMap()));
            this.verboseBloc.add(VerboseNotify(message: 'Category Added'));
      }
      updateSyncApiStatus(serverId);
      log('CATEGORY UPDATED');
    } catch (e) {
      log('CATEGORY UPDATE FAILED', error: e);
    }
  }

  Future<void> updateUser(Database db, User user, String serverId) async {
    try {
      await db.update(TableUsers.tableName, user.getMap(),
          where: '${TableUsers.userId} = ?', whereArgs: [user.userId]);
      updateSyncApiStatus(serverId);
      this.verboseBloc.add(VerboseNotify(message: 'User Updated'));
      log('USER UPDATED');
    } catch (e) {
      log('USER UPDAT FAILED', error: e);
    }
  }

  Future<void> updateCustomer(
      Database db, Customer customer, String serverId) async {
    try {
      await db.update(TableCustomer.tableName, customer.getMap(),
          where: '${TableCustomer.customerId} = ?',
          whereArgs: [customer.customerId]);
      updateSyncApiStatus(serverId);
      this.verboseBloc.add(VerboseNotify(message: 'Customer Updated'));
      log('CUSTOMER UPDATED');
    } catch (e) {
      log('CUSTOMER UPDATE FAILED');
    }
  }

  Future<void> updateSyncApiStatus(String serverId) async {
    await db.update(TableSyncApis.tableName, {TableSyncApis.isUsed: 1},
        where: '${TableSyncApis.serverId} = ?', whereArgs: [serverId]);
  }
}
