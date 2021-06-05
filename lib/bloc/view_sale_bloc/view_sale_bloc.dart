import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:sales_force/models/objects/product.dart';
import 'package:sales_force/repositories/orders_repository.dart';

part 'view_sale_event.dart';
part 'view_sale_state.dart';

class ViewSalesBloc extends Bloc<ViewSalesEvent, ViewSalesState> {
  ViewSalesBloc() : super(ViewSaleInitial());
  String userId, customerId;
  @override
  Stream<ViewSalesState> mapEventToState(
    ViewSalesEvent event,
  ) async* {
    try {
      if (event is SetSalesValues) {
        this.userId = event.userId;
        this.customerId = event.customerId;

        yield ViewSaleStartupState(masterList: []);
      }
      if (event is SearchSalesRecord) {
        List<Map<String, dynamic>> master = await OrdersRepo.repo.getOrders(
            userId: this.userId,
            customerId: this.customerId,
            from: event.fromDate,
            to: event.toDate);

        yield ViewSaleStartupState(masterList: master);
      } else if (event is LoadSaleDetail) {
        final detail =
            await OrdersRepo.repo.getOrdersDetail(masterId: event.masterId);
        yield ViewSaleDetailState(detailsList: detail);
      }
    } catch (e) {
      log('Error', name: 'ViewSalesBloc', error: e);
    }
  }
}
