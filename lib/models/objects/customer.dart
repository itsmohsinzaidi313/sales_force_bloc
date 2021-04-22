import 'package:sales_force/database/tables/customer_table.dart';

class Customer {
  String customerId;
  String customerGroupId;
  String userId;
  String countryId;
  String cityId;
  String stateId;
  String areaId;
  String firstName;
  String lastName;
  String email;
  String phone;
  String mobile;
  String shopName;
  String address;
  String status;
  String discountType;
  String discount;
  String creditLimit;

  Customer(
      {this.customerId,
      this.customerGroupId,
      this.userId,
      this.countryId,
      this.cityId,
      this.stateId,
      this.areaId,
      this.firstName,
      this.lastName,
      this.email,
      this.phone,
      this.mobile,
      this.shopName,
      this.address,
      this.status,
      this.discountType,
      this.discount,
      this.creditLimit});

  Customer.withMap(List<dynamic> i) {
    if (i.isNotEmpty) {
      this.customerId =
          i[0]['customer_id'] == null ? "" : i[0]['customer_id'].toString();
      this.customerGroupId = i[0]['customer_group_id'] == null
          ? ""
          : i[0]['customer_group_id'].toString();
      this.userId = i[0]['user_id'] == null ? "" : i[0]['user_id'].toString();
      this.countryId =
          i[0]['country_id'] == null ? "" : i[0]['country_id'].toString();
      this.cityId = i[0]['city_id'] == null ? "" : i[0]['city_id'].toString();
      this.stateId =
          i[0]['state_id'] == null ? "" : i[0]['state_id'].toString();
      this.areaId = i[0]['area_id'] == null ? "" : i[0]['area_id'].toString();
      this.firstName = i[0]['customer_first_name'] == null
          ? ""
          : i[0]['customer_first_name'];
      this.lastName =
          i[0]['customer_last_name'] == null ? "" : i[0]['customer_last_name'];
      this.email = i[0]['customer_email'] == null ? "" : i[0]['customer_email'];
      this.phone = i[0]['customer_phone'] == null ? "" : i[0]['customer_phone'];
      this.mobile =
          i[0]['customer_mobile'] == null ? "" : i[0]['customer_mobile'];
      this.shopName =
          i[0]['customer_shop_name'] == null ? "" : i[0]['customer_shop_name'];
      this.address =
          i[0]['customer_address'] == null ? "" : i[0]['customer_address'];
      this.status = i[0]['status'] == null ? "" : i[0]['status'].toString();
      this.discountType =
          i[0]['discount_type'] == null ? "" : i[0]['discount_type'].toString();
      this.discount =
          i[0]['discount'] == null ? "" : i[0]['discount'].toString();
      this.creditLimit =
          i[0]['credit_limit'] == null ? "" : i[0]['credit_limit'].toString();
    }
  }

  getList() {
    return [
      this.customerId,
      this.customerGroupId,
      this.userId,
      this.countryId,
      this.cityId,
      this.stateId,
      this.areaId,
      this.firstName,
      this.lastName,
      this.email,
      this.phone,
      this.mobile,
      this.shopName,
      this.address,
      this.status,
      this.discountType,
      this.discount,
      this.creditLimit
    ];
  }

  Map<String, dynamic> getMap() => {
        TableCustomer.customerId: customerId,
        TableCustomer.customerGroupId: customerGroupId,
        TableCustomer.userId: userId,
        TableCustomer.countryId: countryId,
        TableCustomer.cityId: cityId,
        TableCustomer.stateId: stateId,
        TableCustomer.areaId: areaId,
        TableCustomer.firstName: firstName,
        TableCustomer.lastName: lastName,
        TableCustomer.email: email,
        TableCustomer.phone: phone,
        TableCustomer.mobile: mobile,
        TableCustomer.shopName: shopName,
        TableCustomer.address: address,
        TableCustomer.status: status,
        TableCustomer.discountType: discountType,
        TableCustomer.discount: discount,
        TableCustomer.creditLimit: creditLimit,
      };
}
