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
  @override
  Stream<ViewSalesState> mapEventToState(
    ViewSalesEvent event,
  ) async* {
    try {
      if (event is LoadSalesSummary) {
        final master = await OrdersRepo.repo
            .getOrders(userId: event.userId, customerId: event.customerId);
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
