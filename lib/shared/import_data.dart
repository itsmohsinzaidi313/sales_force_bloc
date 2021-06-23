import 'dart:developer';

import 'package:sales_force/bloc/verbose_bloc/verbose_bloc.dart';
import 'package:sales_force/database/tables/categories_table.dart';
import 'package:sales_force/database/tables/category_permissions.dart';
import 'package:sales_force/database/tables/customer_groups_table.dart';
import 'package:sales_force/database/tables/customer_table.dart';
import 'package:sales_force/database/tables/invoices_table.dart';
import 'package:sales_force/database/tables/product_foc_table.dart';
import 'package:sales_force/database/tables/product_prices_table.dart';
import 'package:sales_force/database/tables/products_table.dart';
import 'package:sales_force/database/tables/sync_apis_table.dart';
import 'package:sales_force/database/tables/users_table.dart';
import 'package:sales_force/database/tables/users_type_table.dart';
import 'package:sqflite/sqflite.dart';

class ImportData {
  final String status;
  final String message;
  final Map data;
  final VerboseBloc bloc;
  int _count = 1;
  ImportData({this.status, this.message, this.data, this.bloc});

  Future<bool> init(Database _database) async {
    bool importSuccessful = true;
    try {
      if (importSuccessful)
        await _getUserTypesList(data['user_types'], _database);
    } catch (e) {
      log('ERROR ON getUserTypesList', error: e);
      importSuccessful = false;
    }
    try {
      if (importSuccessful) await _getUsersList(data['users'], _database);
    } catch (e) {
      log('ERROR ON getUsersList', error: e);
      importSuccessful = false;
    }
    try {
      if (importSuccessful)
        await _getCategoriesList(data['categories'], _database);
    } catch (e) {
      log('ERROR ON getCategoriesList', error: e);
      importSuccessful = false;
    }
    try {
      if (importSuccessful) await _getProductsList(data['products'], _database);
    } catch (e) {
      log('ERROR ON getProductsList', error: e);
      importSuccessful = false;
    }
    try {
      if (importSuccessful) await _getInvoicesList(data['invoices'], _database);
    } catch (e) {
      log('>>>ERROR ON getInvoicesList\n$e');
      importSuccessful = false;
    }
    try {
      if (importSuccessful)
        await _getCustomerGroupList(data['customer_groups'], _database);
    } catch (e) {
      log('>>>ERROR ON getInvoicesList\n$e');
      importSuccessful = false;
    }
    try {
      if (importSuccessful)
        await _getProductPricesList(data['pcg_prices'], _database);
    } catch (e) {
      log('>>>ERROR ON getInvoicesList\n$e');
      importSuccessful = false;
    }
    try {
      if (importSuccessful)
        await _getCustomersList(data['customers'], _database);
    } catch (e) {
      log('>>>ERROR ON getCustomers\n$e');
      importSuccessful = false;
    }
    return importSuccessful;
  }

  Future<void> _getCustomersList(List<dynamic> i, Database db) async {
    _count = 1;
    for (var item in i) {
      _triggerBlocEvent('Customers', 'Downloading $_count/${i.length}');
      await db.insert(TableCustomer.tableName, {
        TableCustomer.customerId: item['customer_id'],
        TableCustomer.customerGroupId: item['customer_group_id'],
        TableCustomer.userId: item['user_id'],
        TableCustomer.countryId: item['country_id'],
        TableCustomer.cityId: item['city_id'],
        TableCustomer.stateId: item['state_id'],
        TableCustomer.areaId: item['area_id'],
        TableCustomer.firstName: item['customer_first_name'],
        TableCustomer.lastName: item['customer_last_name'],
        TableCustomer.email: item['customer_email'],
        TableCustomer.phone: item['customer_phone'],
        TableCustomer.mobile: item['customer_mobile'],
        TableCustomer.shopName: item['customer_shop_name'],
        TableCustomer.address: item['customer_address1'],
        TableCustomer.status: 1,
        TableCustomer.discountType: item['discount_type'],
        TableCustomer.discount: item['discount'],
        TableCustomer.creditLimit: item['credit_limit'],
        TableCustomer.shopLat: item['shop_board_lat'],
        TableCustomer.shopLong: item['shop_board_long'],
      });
    }
  }

  Future<void> _getProductPricesList(List<dynamic> i, Database db) async {
    _count = 1;
    for (var item in i) {
      _triggerBlocEvent('ProductPrices', 'Downloading $_count/${i.length}');
      await db.insert(TableProductPrices.tableName, {
        TableProductPrices.productId: item['product_id'],
        TableProductPrices.customerGroupId: item['customer_group_id'],
        TableProductPrices.cashPrice: item['cash_price'],
        TableProductPrices.creditPrice: item['credit_price'],
      });
    }
  }

  Future<void> _getCustomerGroupList(List<dynamic> i, Database db) async {
    _count = 1;
    for (var item in i) {
      _triggerBlocEvent('CustomerGroup', 'Downloading $_count/${i.length}');
      await db.insert(TableCustomerGroups.tableName, {
        TableCustomerGroups.customerGroupId: item['customer_group_id'],
        TableCustomerGroups.name: item['name'],
      });
    }
  }

  Future<void> _getUsersList(List<dynamic> i, Database db) async {
    _count = 1;

    for (var item in i) {
      _triggerBlocEvent('Users', 'Downloading $_count/${i.length}');
      await db.insert(TableUsers.tableName, {
        TableUsers.userId: item['user_id'],
        TableUsers.userTypeid: item['user_type_id'],
        TableUsers.distributorId: item['distributor_id'],
        TableUsers.firstName: item['user_first_name'],
        TableUsers.lastName: item['user_last_name'],
        TableUsers.email: item['user_email_address'],
        TableUsers.password: item['user_password'],
        TableUsers.phone: item['user_phone_number'],
        TableUsers.mobile: item['user_mobile'],
        TableUsers.status: item['user_status'],
        TableUsers.createdOn: item['createdon'],
        TableUsers.modifiedOn: item['modifiedon'],
        TableUsers.discountP:
            item['discount_percent'] == null ? '0' : item['discount_percent'],
      });
    }
  }

  Future<void> _getUserTypesList(List<dynamic> i, Database db) async {
    _count = 1;
    for (var item in i) {
      _triggerBlocEvent('UserTypes', 'Downloading $_count/${i.length}');
      await db.insert(TableUsersType.tableName, {
        TableUsersType.userTypeId: item['user_type_id'],
        TableUsersType.title: item['user_type_title'],
        TableUsersType.permissions: item['user_type_permission']
      });
    }
  }

  Future<void> _getCategoriesList(List<dynamic> i, Database db) async {
    _count = 1;
    for (var item in i) {
      _triggerBlocEvent('Categories', 'Downloading $_count/${i.length}');
      await db.insert(TableCategories.tableName, {
        TableCategories.categoryId: item['product_category_id'],
        TableCategories.userId: item['user_id'],
        TableCategories.title: item['product_category_title'],
        TableCategories.image: item['product_category_image'],
        TableCategories.createdOn: item['createdon'],
        TableCategories.modifiedOn: item['modifiedon'],
      });
      getCategoryPermissionsList(item['salesman'], db);
    }
  }

  Future<void> getCategoryPermissionsList(List<dynamic> i, Database db) async {
    _count = 1;
    for (var item in i) {
      _triggerBlocEvent(
          'CategoryPermissions', 'Downloading $_count/${i.length}');
      await db.insert(TableCategoryPermissions.tableName, {
        TableCategoryPermissions.categoryId: item['product_category_id'],
        TableCategoryPermissions.userId: item['user_id']
      });
    }
  }

  Future<void> _getInvoicesList(List<dynamic> i, Database db) async {
    _count = 1;

    for (var item in i) {
      _triggerBlocEvent('Invoices', 'Downloading $_count/${i.length}');
      await db.insert(TableInvoices.tableName, {
        TableInvoices.invoiceId: item['invoice_id'],
        TableInvoices.orderId: item['order_id'],
        TableInvoices.customerId: item['customer_id'],
        TableInvoices.userId: item['user_id'],
        TableInvoices.number: item['invoice_number'],
        TableInvoices.date: item['invoice_date'],
        TableInvoices.amount: item['invoice_amount'],
        TableInvoices.discount: item['invoice_discount'],
        TableInvoices.totalAmount: item['invoice_total_amount'],
        TableInvoices.paidAmount: item['invoice_paid_amount'],
        TableInvoices.balance: item['invoice_balance'],
        TableInvoices.status: item['invoice_status'],
        TableInvoices.createdOn: item['createdon'],
        TableInvoices.modifiedOn: item['modifiedon']
      });
    }
  }

  Future<void> _getProductsList(List<dynamic> i, Database db) async {
    _count = 1;
    for (var item in i) {
      _triggerBlocEvent('Products', 'Downloading $_count/${i.length}');
      await db.insert(TableProducts.tableName, {
        TableProducts.productId: item['product_id'],
        TableProducts.categoryId: item['product_category_id'],
        TableProducts.typeId: item['product_type_id'],
        TableProducts.userId: item['user_id'],
        TableProducts.title: item['product_title'],
        TableProducts.packPrice: item['product_pack_price'],
        TableProducts.creditPrice: item['product_credit_price'],
        TableProducts.packsPerCarton: item['product_packs_per_carton'],
        TableProducts.cartonPrice: item['product_carton_price'],
        TableProducts.literPrice: item['product_price_per_liter'],
        TableProducts.discountType: item['discount_type'],
        TableProducts.discount: item['discount'],
        TableProducts.isActive: item['isActive'],
        TableProducts.createdOn: item['createdon'],
        TableProducts.modifiedon: item['modifiedon'],
        TableProducts.image: item['product_image'],
      });
      getProductFoc(item['foc_slab'], db);
    }
  }

  Future<void> getProductFoc(List<dynamic> i, Database db) async {
    if (i != null) {
      _count = 1;
      for (var item in i) {
        _triggerBlocEvent('ProductFoc', 'Downloading $_count/${i.length}');
        await db.insert(TableProductFOC.tableName, {
          TableProductFOC.productId: item['product_id'],
          TableProductFOC.start: item['start'],
          TableProductFOC.end: item['end'],
          TableProductFOC.quantity: item['quantity'],
        });
      }
    }
  }

  Future<bool> importSync(Database db) async {
    int id = 0;
    _count = 1;
    List<dynamic> list = data['data'];
    for (var item in list) {
      _triggerBlocEvent('ProductFoc', 'Downloading $_count/${list.length}');
      id = await db.insert(TableSyncApis.tableName, {
        TableSyncApis.serverId: item['sync_pk'],
        TableSyncApis.module: item['sync_module'],
        TableSyncApis.operation: item['sync_operation'],
        TableSyncApis.url: item['sync_service'],
        TableSyncApis.createdOn: item['createdon'],
        TableSyncApis.isUsed: 1,
      });
    }
    return id > 0 ? true : false;
  }

  void _triggerBlocEvent(String title, String message) {
    _count++;
    bloc.add(VerboseNewEvent(title: title, message: message));
  }
}
