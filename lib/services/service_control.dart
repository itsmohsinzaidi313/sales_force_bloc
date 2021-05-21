import 'dart:developer';

import 'package:sales_force/services/customer_service.dart';
import 'package:sales_force/services/service_common.dart';
import 'package:sales_force/services/invoice_service.dart';
import 'package:sales_force/services/location_service.dart';
import 'package:sales_force/services/orders_service.dart';
import 'package:sales_force/services/sync_service.dart';
import 'package:sales_force/services/visit_service.dart';
import 'package:sqflite/sqflite.dart';

class ServiceControl {
  SPostOrder orderService;
  SPostInvoice invoiceService;
  SPostLocation locationService;
  SPostVisit visitService;
  SSyncService syncService;
  SUploadCustomer customerService;
  static ServiceControl control = ServiceControl._internal();
  ServiceControl._internal();

  void initializeDatabaseDependent({Database database}) async {
    try {
      this.invoiceService = SPostInvoice(database);
      this.orderService = SPostOrder(database);
      this.visitService = SPostVisit(database);
      this.syncService = SSyncService(database);
      this.locationService = SPostLocation(database);
      this.customerService = SUploadCustomer(database);
    } catch (e) {
      log('ERROR ON DATABASE DEPENDENT SERVICES', error: e);
    }
  }

  bool serviceStatus(String name) {
    bool status;
    if (name == locationService.name)
      status = locationService.status();
    else if (name == orderService.name)
      status = orderService.status();
    else if (name == visitService.name)
      status = visitService.status();
    else if (name == syncService.name)
      status = syncService.status();
    else if (name == invoiceService.name)
      status = invoiceService.status();
    else if (name == customerService.name) status = customerService.status();
    return status;
  }

  updateServiceStatus(String name, bool status) {
    if (name == locationService.name)
      locationService.setStatus(status);
    else if (name == orderService.name)
      orderService.setStatus(status);
    else if (name == visitService.name)
      visitService.setStatus(status);
    else if (name == syncService.name) {
      syncService.setStatus(status);
    } else if (name == invoiceService.name) {
      invoiceService.setStatus(status);
    } else if (name == customerService.name) {
      customerService.setStatus(status);
    }
  }

  List<ServiceCommon> getList() {
    return [
      syncService,
      visitService,
      invoiceService,
      orderService,
      locationService,
      customerService,
    ];
  }

  void startAllServices() {
    locationService.start();
    orderService.start();
    invoiceService.start();
    visitService.start();
    syncService.start();
    customerService.start();
  }

  void stopAllService() {
    locationService.stop();
    orderService.stop();
    invoiceService.stop();
    visitService.stop();
    syncService.stop();
    customerService.stop();
  }
}
