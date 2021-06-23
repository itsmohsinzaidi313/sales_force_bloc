import 'package:sales_force/database/tables/customer_groups_table.dart';
import 'package:sales_force/database/tables/customer_table.dart';
import 'package:sales_force/models/objects/customer.dart';
import 'package:sales_force/models/objects/customer_group.dart';
import 'package:sales_force/shared/config.dart';
import 'package:sqflite_common/sqlite_api.dart';

class CustomerRepo {
  static CustomerRepo repo = CustomerRepo._internal(database: Config.database);
  final Future<Database> database;
  CustomerRepo._internal({this.database});

  Future<List<Customer>> getAllCustomers(String userId) async =>
      (await (await database).query(TableCustomer.tableName,
              where: '${TableCustomer.userId} = ? and ${TableCustomer.customerId} != ?', whereArgs: [userId, '0']))
          .map((e) => Customer.withMap([e]))
          .toList();

  Future<List<CustomerGroup>> getAllCustomerGroups() async =>
      (await (await database).query(TableCustomerGroups.tableName))
          .map((e) => CustomerGroup.withMap(e))
          .toList();

  Future<Customer> getCustomer(String customerId) async =>
      (await (await database).query(TableCustomer.tableName,
              where: '${TableCustomer.customerId} = ?',
              whereArgs: [customerId]))
          .map((e) => Customer.withMap([e]))
          .toList()
          .first;

  Future<List<Customer>> searchCustomers(String userId, String phrase) async =>
      (await (await database).query(TableCustomer.tableName,
              where:
                  '${TableCustomer.userId} = ? and ${TableCustomer.firstName} like ?',
              whereArgs: [int.parse(userId), '%$phrase%']))
          .map((e) => Customer.withMap([e]))
          .toList();
}
