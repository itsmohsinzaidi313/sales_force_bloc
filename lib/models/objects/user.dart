import 'package:sales_force/database/tables/users_table.dart';

class User {
  String userId;
  String userTypeId;
  String distributorId;
  String firstname;
  String lastname;
  String email;
  String password;
  String phoneNumber;
  String mobile;
  String userStatus;
  String createdon;
  String modifiedon;
  String discountPercent;

  User(
      {this.userId,
      this.userTypeId,
      this.distributorId,
      this.firstname,
      this.lastname,
      this.email,
      this.password,
      this.phoneNumber,
      this.mobile,
      this.userStatus,
      this.createdon,
      this.modifiedon,
      this.discountPercent});

  User.withUser(User user) {
    this.userId = user.userId;
    this.userTypeId = user.userTypeId;
    this.distributorId = user.distributorId;
    this.firstname = user.firstname;
    this.lastname = user.lastname;
    this.email = user.email;
    this.password = user.password;
    this.phoneNumber = user.phoneNumber;
    this.mobile = user.mobile;
    this.userStatus = user.userStatus;
    this.createdon = user.createdon;
    this.modifiedon = user.modifiedon;
  }

  User.withMap(List<dynamic> i) {
    if (i.isNotEmpty) {
      this.userId = i[0]['user_id'] == null ? '' : i[0]['user_id'].toString();
      this.userTypeId =
          i[0]['user_type_id'] == null ? '' : i[0]['user_type_id'].toString();
      this.distributorId =
          i[0]['distributor_id'] == null ? '' : i[0]['distributor_id'].toString();
      this.firstname =
          i[0]['user_first_name'] == null ? '' : i[0]['user_first_name'];
      this.lastname =
          i[0]['user_last_name'] == null ? '' : i[0]['user_last_name'];
      this.email =
          i[0]['user_email_address'] == null ? '' : i[0]['user_email_address'];
      this.password =
          i[0]['user_password'] == null ? '' : i[0]['user_password'];
      this.phoneNumber =
          i[0]['user_phone_number'] == null ? '' : i[0]['user_phone_number'];
      this.mobile = i[0]['user_mobile'] == null ? '' : i[0]['user_mobile'];
      this.userStatus = i[0]['user_status'] == null ? '' : i[0]['user_status'].toString();
      this.createdon = i[0]['createdon'] == null ? '' : i[0]['createdon'];
      this.modifiedon = i[0]['modifiedon'] == null ? '' : i[0]['modifiedon'];
      this.discountPercent =
          i[0]['discount_percent'] == null ? '' : i[0]['discount_percent'].toString();
    }
  }
  User.withQueryResult(List<Map<String, dynamic>> listMap) {
    this.userId = listMap[0]['user_id'] == null ? '' : listMap[0]['user_id'];
    this.userTypeId =
        listMap[0]['user_type_id'] == null ? '' : listMap[0]['user_type_id'];
    this.distributorId = listMap[0]['distributor_id'] == null
        ? ''
        : listMap[0]['distributor_id'];
    this.firstname = listMap[0]['user_first_name'] == null
        ? ''
        : listMap[0]['user_first_name'];
    this.lastname = listMap[0]['user_last_name'] == null
        ? ''
        : listMap[0]['user_last_name'];
    this.email = listMap[0]['user_email_address'] == null
        ? ''
        : listMap[0]['user_email_address'];
    this.password =
        listMap[0]['user_password'] == null ? '' : listMap[0]['user_password'];
    this.phoneNumber = listMap[0]['user_phone_number'] == null
        ? ''
        : listMap[0]['user_phone_number'];
    this.mobile =
        listMap[0]['user_mobile'] == null ? '' : listMap[0]['user_mobile'];
    this.userStatus =
        listMap[0]['user_status'] == null ? '' : listMap[0]['user_status'];
    this.createdon =
        listMap[0]['createdon'] == null ? '' : listMap[0]['createdon'];
    this.modifiedon =
        listMap[0]['modifiedon'] == null ? '' : listMap[0]['modifiedon'];
    this.discountPercent = listMap[0]['discount_percent'] == null
        ? ''
        : listMap[0]['discount_percent'];
  }

  getList() {
    return [
      this.userId,
      this.userTypeId,
      this.distributorId,
      this.firstname,
      this.lastname,
      this.email,
      this.password,
      this.phoneNumber,
      this.mobile,
      this.userStatus,
      this.createdon,
      this.modifiedon,
      this.discountPercent
    ];
  }

  Map<String, dynamic> getMap() => {
        TableUsers.userId: userId,
        TableUsers.userTypeid: userTypeId,
        TableUsers.distributorId: distributorId,
        TableUsers.firstName: firstname,
        TableUsers.lastName: lastname,
        TableUsers.email: email,
        TableUsers.password: password,
        TableUsers.phone: phoneNumber,
        TableUsers.mobile: mobile,
        TableUsers.status: userStatus,
        TableUsers.createdOn: createdon,
        TableUsers.modifiedOn: modifiedon,
        TableUsers.discountP: discountPercent,
      };
}
