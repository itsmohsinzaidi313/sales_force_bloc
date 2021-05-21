import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sales_force/bloc/customer_bloc/customer_bloc.dart';
import 'package:sales_force/bloc/invoice_bloc/invoice_bloc.dart';
import 'package:sales_force/bloc/item_menu_bloc/item_menu_bloc.dart';
import 'package:sales_force/bloc/login_bloc/login_bloc.dart';
import 'package:sales_force/bloc/order_payment_bloc/order_payment_bloc.dart';
import 'package:sales_force/bloc/view_sale_bloc/view_sale_bloc.dart';
import 'package:sales_force/pages/invoice_pages/invoice_payment_page.dart';
import 'package:sales_force/pages/invoice_pages/invoices_page.dart';
import 'package:sales_force/pages/items_menu_page.dart';
import 'package:sales_force/pages/login_page.dart';
import 'package:sales_force/pages/main_menu_page.dart';
import 'package:sales_force/pages/order_payment_page.dart';
import 'package:sales_force/pages/pick_customer_page.dart';
import 'package:sales_force/pages/settings_page.dart';
import 'package:sales_force/pages/splash_page.dart';
import 'package:sales_force/pages/sql_view_page.dart';
import 'package:sales_force/pages/view_sale_detail_page.dart';
import 'package:sales_force/pages/view_sales_page.dart';
import 'package:sales_force/pages/view_visits_page.dart';

class RouteConfig {
  // VerboseBloc verboseBloc;
  LoginBloc loginBloc;
  ItemMenuBloc itemMenuBloc;
  CustomerBloc customerBloc;
  OrderPaymentBloc orderPaymentBloc;
  ViewSalesBloc viewSalesBloc;
  InvoiceBloc invoiceBloc;

  RouteConfig() {
    // verboseBloc = VerboseBloc();
    loginBloc = LoginBloc();
    itemMenuBloc = ItemMenuBloc();
    customerBloc = CustomerBloc();
    orderPaymentBloc = OrderPaymentBloc();
    viewSalesBloc = ViewSalesBloc();
    invoiceBloc = InvoiceBloc();
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
      case '/invoices':
        invoiceBloc.add(LoadInvoicesEvent());
        return MaterialPageRoute(
          builder: (context) => BlocProvider.value(
            value: invoiceBloc,
            child: InvoicePage(),
          ),
        );
      case '/invoicePayment':
        return MaterialPageRoute(
            builder: (context) => BlocProvider.value(
                  value: invoiceBloc,
                  child: InvoicePaymentPage(
                    invoice: routeSettings.arguments,
                  ),
                ));
      case '/viewVisits':
        return MaterialPageRoute(
          builder: (context) => ViewVisitsPage(),
        );
      case '/settings':
        return MaterialPageRoute(
          builder: (context) => SettingsPage(),
        );
      case '/sql':
        return MaterialPageRoute(
          builder: (context) => SqlViewPage(),
        );
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
    invoiceBloc.close();
  }
}
