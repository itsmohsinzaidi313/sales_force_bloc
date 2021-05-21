import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sales_force/bloc/customer_bloc/customer_bloc.dart';
import 'package:sales_force/models/objects/customer.dart';
import 'package:sales_force/repositories/visit_repository.dart';
import 'package:sales_force/shared/app_theme.dart';
import 'package:sales_force/shared/config.dart';
import 'package:sales_force/shared/constants.dart';

class PickCustomer extends StatelessWidget {
  final SALETYPE loadFor;
  PickCustomer({this.loadFor});
  @override
  Widget build(BuildContext context) {
    return BlocListener<CustomerBloc, CustomerState>(
      listener: (context, state) {
        if (state is CustomerErrorState) {
          AppTheme.snackbar(context, state.message, error: true);
        } else if (state is TakeCustomerOrder) {
          Navigator.of(context).pushNamed('/newSale',
              arguments: [state.paymentmode, state.customer]);
        } else if (state is ShowViewSales) {
          Navigator.of(context).pushNamed('/viewSales',
              arguments: [Config.user.userId, state.customerId]);
        }
      },
      child: Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.blue,
            title: BlocBuilder<CustomerBloc, CustomerState>(
              buildWhen: (previous, current) {
                if (current is SearchCustomerState ||
                    current is NormalCustomerState) {
                  return true;
                } else {
                  return false;
                }
              },
              builder: (context, state) {
                if (state is SearchCustomerState) {
                  return TextField(
                    onChanged: (value) =>
                        passEvent(context, CustomerNameChanged(name: value)),
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                        icon: Icon(
                          Icons.search,
                          color: Colors.white,
                        ),
                        hintText: "Search Shops Here",
                        hintStyle: TextStyle(color: Colors.white)),
                  );
                } else {
                  return Text('Shops');
                }
              },
            ),
            actions: <Widget>[
              BlocBuilder<CustomerBloc, CustomerState>(
                buildWhen: (previous, current) {
                  if (current is SearchCustomerState ||
                      current is NormalCustomerState) {
                    return true;
                  } else {
                    return false;
                  }
                },
                builder: (context, state) {
                  if (state is SearchCustomerState) {
                    return IconButton(
                      icon: Icon(Icons.cancel),
                      onPressed: () =>
                          passEvent(context, CancelSearchPressed()),
                    );
                  } else {
                    return IconButton(
                      icon: Icon(Icons.search),
                      onPressed: () =>
                          passEvent(context, SearchCustomerPressed()),
                    );
                  }
                },
              ),
            ]),
        body: Container(
          color: AppTheme.backgroundColor,
          child: Padding(
            padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
            child: BlocBuilder<CustomerBloc, CustomerState>(
              buildWhen: (previous, current) =>
                  current is CustomerListState ? true : false,
              builder: (context, state) {
                if (state is CustomerListState) {
                  return ListView.builder(
                    itemCount: state.list.length,
                    itemBuilder: (context, index) => Card(
                      child: Container(
                        height: Config.deviceDisplayHeight(context) * 0.20,
                        padding: const EdgeInsets.all(10.0),
                        child: Stack(
                          children: <Widget>[
                            Positioned(
                              top: 45,
                              left: 10,
                              child: Column(
                                children: <Widget>[
                                  Text(
                                    '${state.list[index].shopName}',
                                    style: AppTheme.textStyle(),
                                  ),
                                  Text(
                                    '(${state.list[index].firstName} ${state.list[index].lastName})',
                                    style: AppTheme.textStyle(fontSize: 15),
                                  ),
                                ],
                              ),
                            ),
                            Positioned(
                              top: 15,
                              right: 5,
                              child: Column(
                                children: layoutController(
                                    context, state.list[index]),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                } else {
                  return Container();
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> layoutController(BuildContext context, Customer customer) {
    switch (loadFor) {
      case SALETYPE.NEWSALE:
        return newSaleView(context, customer);
        break;
      case SALETYPE.VIEWSALE:
        return viewSale(context, customer);
        break;
      case SALETYPE.REGISTERVISIT:
        return registerVisit(context, customer);
        break;
      default:
        return <Widget>[Text('EMPTY')];
        break;
    }
  }

  List<Widget> newSaleView(BuildContext context, Customer customer) {
    return <Widget>[
      Row(
        children: <Widget>[
          AppTheme.recElevatedButton(
            text: 'Cash',
            onPressed: () => passEvent(
              context,
              CustomerSelected(
                  customer: customer, paymentmode: PAYMENTMODE.CASH),
            ),
          ),
        ],
      ),
      Row(
        children: <Widget>[
          AppTheme.recElevatedButton(
            text: 'Credit',
            onPressed: () => passEvent(
              context,
              CustomerSelected(
                  customer: customer, paymentmode: PAYMENTMODE.CREDIT),
            ),
          ),
        ],
      ),
    ];
  }

  List<Widget> viewSale(BuildContext context, Customer customer) {
    return <Widget>[
      AppTheme.recElevatedButton(
        text: 'View Sale',
        onPressed: () => passEvent(
          context,
          LoadViewSales(
              customerId: customer.customerId, userId: Config.user.userId),
        ),
      )
    ];
  }

  List<Widget> registerVisit(BuildContext context, Customer customer) {
    return <Widget>[
      AppTheme.recElevatedButton(
          text: 'Add Visit',
          onPressed: () => AppTheme.showAlertDialogYN(
                context,
                title: 'Question',
                message: 'Are you sure?',
              ).then((value) => value
                  ? addVisit(context, customer.customerId)
                  : Navigator.of(context).pop())),
    ];
  }

  void addVisit(BuildContext context, String customerId) async {
    Position position = await Geolocator.getCurrentPosition();
    VisitRepo.repo.addVisit(
        customerId: customerId, userId: Config.user.userId, position: position);
    AppTheme.snackbar(context, 'Visit added');
  }

  void passEvent(BuildContext context, CustomerEvent event) =>
      context.read<CustomerBloc>().add(event);
}
