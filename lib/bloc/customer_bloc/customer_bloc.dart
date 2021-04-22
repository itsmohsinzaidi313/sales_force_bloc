import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:sales_force/models/objects/customer.dart';
import 'package:sales_force/repositories/customer_repository.dart';
import 'package:sales_force/shared/config.dart';
import 'package:sales_force/shared/constants.dart';

part 'customer_event.dart';
part 'customer_state.dart';

class CustomerBloc extends Bloc<CustomerEvent, CustomerState> {
  CustomerBloc() : super(CustomerInitial());

  @override
  Stream<CustomerState> mapEventToState(
    CustomerEvent event,
  ) async* {
    try {
      if (event is LoadCustomerEvent) {
        yield NormalCustomerState();
        yield CustomerListState(
            list:
                (await CustomerRepo.repo.getAllCustomers(Config.user.userId)));
      }
      if (event is SearchCustomerPressed) {
        yield SearchCustomerState();
      } else if (event is CustomerNameChanged) {
        yield CustomerListState(
            list: (await CustomerRepo.repo
                .searchCustomers(Config.user.userId, event.name)));
      } else if (event is CancelSearchPressed) {
        yield NormalCustomerState();
        yield CustomerListState(
            list:
                (await CustomerRepo.repo.getAllCustomers(Config.user.userId)));
      } else if (event is CustomerSelected) {
        yield TakeCustomerOrder(
            customer: event.customer, paymentmode: event.paymentmode);
      } else if (event is LoadViewSales) {
        yield ShowViewSales(customerId: event.customerId, userId: event.userId);
      }
    } catch (e) {
      log('Error', error: e, name: 'Customer Bloc');
      yield CustomerErrorState(message: e.toString());
    }
  }
}
