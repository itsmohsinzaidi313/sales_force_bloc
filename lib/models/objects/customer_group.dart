import 'package:sales_force/database/tables/customer_groups_table.dart';

class CustomerGroup {
  String customerGroupId;
  String name;
  CustomerGroup({this.customerGroupId, this.name});

  CustomerGroup.withMap(Map<String, dynamic> i)
      : customerGroupId = i[TableCustomerGroups.customerGroupId],
        name = i[TableCustomerGroups.name];

  getList() {
    return [this.customerGroupId, this.name];
  }
}
