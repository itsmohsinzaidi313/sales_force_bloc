import 'package:sales_force/database/tables/sync_apis_table.dart';
import 'package:sales_force/shared/config.dart';

class SyncPacket {
  String id;
  String serverId;
  String module;
  String operation;
  String url;
  String createdOn;
  String isUsed = '0';
  SyncPacket(
      {this.module, this.operation, this.url, this.createdOn, this.serverId});
  SyncPacket.fromMap(Map<String, dynamic> map)
      : serverId = map['sync_id'],
        module = map['sync_module'],
        operation = map['sync_operation'],
        url =
            '${Config.apiPrefix}${map['sync_service']}&user=${Config.user.userId}',
        createdOn = map['createdon'];

  SyncPacket.fromDb(Map<String, dynamic> map)
      : id = map[TableSyncApis.id].toString(),
        serverId = map[TableSyncApis.serverId].toString(),
        module = map[TableSyncApis.module],
        operation = map[TableSyncApis.operation],
        url = map[TableSyncApis.url],
        createdOn = map[TableSyncApis.createdOn],
        isUsed = map[TableSyncApis.isUsed].toString();

  getList() {
    return [
      this.serverId,
      this.module,
      this.operation,
      this.url,
      this.createdOn,
      isUsed
    ];
  }

  getMap() {
    return {
      'server_id': this.serverId,
      'module': this.module,
      'operation': this.operation,
      'url': this.url,
      'createdon': this.createdOn,
      'is_used': this.isUsed
    };
  }
}
