import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sales_force/bloc/customer_bloc/customer_bloc.dart';
import 'package:sales_force/bloc/item_menu_bloc/item_menu_bloc.dart';
import 'package:sales_force/bloc/login_bloc/login_bloc.dart';
import 'package:sales_force/bloc/order_payment_bloc/order_payment_bloc.dart';
import 'package:sales_force/bloc/verbose_bloc/verbose_bloc.dart';
import 'package:sales_force/bloc/view_sale_bloc/view_sale_bloc.dart';
import 'package:sales_force/pages/items_menu_page.dart';
import 'package:sales_force/pages/login_page.dart';
import 'package:sales_force/pages/main_menu_page.dart';
import 'package:sales_force/pages/order_payment_page.dart';
import 'package:sales_force/pages/pick_customer_page.dart';
import 'package:sales_force/pages/splash_page.dart';
import 'package:sales_force/pages/view_sale_detail_page.dart';
import 'package:sales_force/pages/view_sales_page.dart';

class RouteConfig {
  // VerboseBloc verboseBloc;
  LoginBloc loginBloc;
  ItemMenuBloc itemMenuBloc;
  CustomerBloc customerBloc;
  OrderPaymentBloc orderPaymentBloc;
  ViewSalesBloc viewSalesBloc;

  RouteConfig() {
    // verboseBloc = VerboseBloc();
    loginBloc = LoginBloc();
    itemMenuBloc = ItemMenuBloc();
    customerBloc = CustomerBloc();
    orderPaymentBloc = OrderPaymentBloc();
    viewSalesBloc = ViewSalesBloc();
  }

  Route onGeneratedRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case '/':
        return MaterialPageRoute(
          builder: (context) => SplashPage(),
        );
        break;
      case '/login':
        loginBloc.add(LoginGetLastLogin());
        return MaterialPageRoute(
          builder: (context) => BlocProvider.value(
            value: loginBloc,
            child: LoginPage(),
          ),
        );
        break;
      case '/menu':
        return MaterialPageRoute(
          builder: (context) => MenuPage(),
        );
        break;
      case '/newSale':
        itemMenuBloc.add(LoadItemsEvent());
        return MaterialPageRoute(
            builder: (context) => BlocProvider.value(
                  value: itemMenuBloc,
                  child: ItemsMenuPage(
                    arguments: routeSettings.arguments,
                  ),
                ));
        break;
      case '/customers':
        customerBloc.add(LoadCustomerEvent());
        return MaterialPageRoute(
          builder: (context) => BlocProvider.value(
            value: customerBloc,
            child: PickCustomer(
              loadFor: routeSettings.arguments,
            ),
          ),
        );
        break;
      case '/orderPayment':
        orderPaymentBloc.customerOrder = routeSettings.arguments;
        orderPaymentBloc.add(LoadOrderPayment());
        return MaterialPageRoute(
          builder: (context) => BlocProvider.value(
            value: orderPaymentBloc,
            child: OrderPaymenPage(),
          ),
        );
        break;
      case '/viewSales':
        List<String> arguments = routeSettings.arguments;
        viewSalesBloc.add(LoadSalesSummary(
          userId: arguments[0],
          customerId: arguments[1],
        ));
        return MaterialPageRoute(
          builder: (context) => BlocProvider.value(
            value: viewSalesBloc,
            child: ViewSalesPage(),
          ),
        );
        break;
      case '/viewSaleDetail':
        return MaterialPageRoute(
          builder: (context) => ViewSaleDetail(
            detailRecord: routeSettings.arguments,
          ),
        );
        break;
      default:
        break;
    }
  }

  void dispose() {
    loginBloc.close();
    itemMenuBloc.close();
    customerBloc.close();
    orderPaymentBloc.close();
    viewSalesBloc.close();
  }
}
