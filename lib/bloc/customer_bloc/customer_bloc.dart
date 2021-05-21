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
  List<Customer> customers = [];
  @override
  Stream<CustomerState> mapEventToState(
    CustomerEvent event,
  ) async* {
    try {
      if (event is LoadCustomerEvent) {
        customers = await CustomerRepo.repo.getAllCustomers(Config.user.userId);
        yield NormalCustomerState();
        yield CustomerListState(list: customers);
      }
      if (event is SearchCustomerPressed) {
        yield SearchCustomerState();
      } else if (event is CustomerNameChanged) {
        yield CustomerListState(
            list: customers.where((element) {
          String name = '${element.firstName} ${element.lastName}';
          if (name.toLowerCase().contains(event.name.toLowerCase())) {
            return true;
          } else {
            return false;
          }
        }).toList());
      } else if (event is CancelSearchPressed) {
        yield NormalCustomerState();
        yield CustomerListState(list: customers);
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
