import 'package:geolocator/geolocator.dart';
import 'package:sales_force/database/tables/customer_table.dart';
import 'package:sales_force/database/tables/visits_table.dart';
import 'package:sales_force/shared/config.dart';
import 'package:sales_force/shared/library.dart';
import 'package:sqflite/sqflite.dart';

class VisitRepo {
  static VisitRepo repo = VisitRepo._internal(database: Config.database);
  final Future<Database> database;
  VisitRepo._internal({this.database});
  Future<void> addVisit(
          {String customerId, String userId, Position position}) async =>
      (await (await database).insert(TableVisits.tableName, {
        TableVisits.customerId: int.parse(customerId),
        TableVisits.userId: int.parse(userId),
        TableVisits.latitude: position.latitude,
        TableVisits.longitude: position.longitude,
        TableVisits.createdOn: Library.getDateTime(),
        TableVisits.isOrder: 0,
        TableVisits.isUpload: 0,
      }));

  Future<List<Map<String, dynamic>>> getAllVisits(String userId) async {
    List<Map<String, dynamic>> list =
        (await (await database).query(TableVisits.tableName,
            columns: [
              TableVisits.createdOn,
              TableVisits.isUpload,
              "(select ${TableCustomer.firstName} || ' ' ||  ${TableCustomer.lastName} from ${TableCustomer.tableName} where ${TableCustomer.customerId} = ${TableVisits.tableName}.${TableVisits.customerId}) as name",
              "(select ${TableCustomer.shopName} from ${TableCustomer.tableName} where ${TableCustomer.customerId} = ${TableVisits.tableName}.${TableVisits.customerId}) as shop"
            ],
            where: '${TableVisits.userId} = ? and ${TableVisits.isOrder} = ?',
            whereArgs: [int.parse(userId), 0]));
    return list;
  }
}
