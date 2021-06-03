import 'dart:async';
import 'dart:developer';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sales_force/shared/app_theme.dart';
import 'package:sales_force/shared/config.dart';
import 'package:sales_force/shared/constants.dart';
import 'package:sales_force/shared/library.dart';
import 'package:sales_force/shared/widgets/verbose_widget.dart';

class MenuPage extends StatelessWidget {
  void onNewSalePressed(BuildContext context) => Navigator.of(context)
      .pushNamed('/customers', arguments: SALETYPE.NEWSALE);

  void onViewSalePressed(BuildContext context) => Navigator.of(context)
      .pushNamed('/customers', arguments: SALETYPE.VIEWSALE);

  void onNewVisitsPressed(BuildContext context) => Navigator.of(context)
      .pushNamed('/customers', arguments: SALETYPE.REGISTERVISIT);

  void onInvoicesPressed(BuildContext context) =>
      Navigator.of(context).pushNamed('/invoices');

  void onViewVisitsPressed(BuildContext context) =>
      Navigator.of(context).pushNamed('/viewVisits');

  void onSyncDataPressed(BuildContext context) async {
    try {
      bool dialogResult = await AppTheme.showAlertDialogYN(context,
          title: 'Attention', message: 'Are you sure?');
      if (dialogResult) {
        bool value = await Library.hasServerAccess();
        if (value) {
          Library.install(context, forceUpdate: true);
          VerboseWidgets(context: context).showVerboseDialog();
        }
      }
    } catch (e) {
      log('Error occured', name: 'MenuPage', error: e);
    }
  }

  void onDbViewPressed(BuildContext context) =>
      Navigator.of(context).pushNamed('/sql');

  Future<bool> _onWillPop(BuildContext context) async {
    return (await showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text('Are you sure?'),
            content: new Text('Do you want to exit an App'),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(8.0))),
            actions: <Widget>[
              new TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: new Text('No'),
              ),
              new TextButton(
                onPressed: () {
                  SystemNavigator.pop();
                },
                child: new Text('Yes'),
              ),
            ],
          ),
        )) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () => _onWillPop(context),
        child: Scaffold(
          appBar: AppBar(
            title: Text('MAIN MENU'),
            actions: <Widget>[
              PopupMenuButton<String>(
                  shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.vertical(bottom: Radius.circular(20.0))),
                  icon: Icon(Icons.more_vert),
                  onSelected: (value) => choice(context, value),
                  itemBuilder: (BuildContext context) {
                    return choices.map((String choice) {
                      return PopupMenuItem(
                        value: choice,
                        child: Text(choice),
                      );
                    }).toList();
                  })
            ],
          ),
          body: Container(
            color: AppTheme.backgroundColor,
            // decoration: BoxDecoration(
            //     image: DecorationImage(
            //         image: AssetImage(AppTheme.backgroundImage),
            //         repeat: ImageRepeat.repeat)),
            child: GridView.count(
              padding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * 0.08,
                  right: MediaQuery.of(context).size.width * 0.08,
                  top: 20,
                  bottom: 20),
              crossAxisCount: 2,
              crossAxisSpacing: MediaQuery.of(context).size.width * 0.05,
              mainAxisSpacing: MediaQuery.of(context).size.height * 0.05,
              children: getDashboardButtons(context),
            ),
          ),
        ));
  }

  List<Widget> getDashboardButtons(BuildContext context) {
    try {
      Color redColor = Color.fromRGBO(251, 91, 57, 0.7);
      Color blueColor = Color.fromRGBO(145, 202, 245, 0.6);
      double iconSize = MediaQuery.of(context).size.width * 0.14;

      List<Widget> list = [
        AppTheme.roundIconButton(
          text: 'NEW SALE',
          textStyle: TextStyle(
              fontWeight: FontWeight.bold,
              // fontSize: fontSize,
              color: Colors.white),
          icon: Icon(
            Icons.add_shopping_cart,
            color: Colors.white,
          ),
          iconSize: iconSize,
          buttonColor: redColor,
          onPressed: () => onNewSalePressed(context),
        ),
        AppTheme.roundIconButton(
            text: 'VIEW SALE',
            textStyle: TextStyle(
                fontWeight: FontWeight.bold,
                // fontSize: fontSize,
                color: Colors.white),
            icon: Icon(
              Icons.view_headline,
              color: Colors.white,
            ),
            iconSize: iconSize,
            buttonColor: blueColor,
            onPressed: () => onViewSalePressed(context)),
        AppTheme.roundIconButton(
            text: 'INVOICES',
            textStyle: TextStyle(
                fontWeight: FontWeight.bold,
                // fontSize: fontSize,
                color: Colors.white),
            icon: Icon(
              Icons.assignment,
              color: Colors.white,
            ),
            iconSize: iconSize,
            buttonColor: blueColor,
            onPressed: () => onInvoicesPressed(context)),
        AppTheme.roundIconButton(
            text: 'VIEW VISITS',
            textStyle: TextStyle(
                fontWeight: FontWeight.bold,
                // fontSize: fontSize,
                color: Colors.white),
            icon: Icon(
              Icons.not_listed_location,
              color: Colors.white,
            ),
            iconSize: iconSize,
            buttonColor: redColor,
            onPressed: () => onViewVisitsPressed(context)),
        AppTheme.roundIconButton(
            text: 'NEW VISITS',
            textStyle: TextStyle(
                fontWeight: FontWeight.bold,
                // fontSize: fontSize,
                color: Colors.white),
            icon: Icon(
              Icons.add_location,
              color: Colors.white,
            ),
            iconSize: iconSize,
            buttonColor: redColor,
            onPressed: () => onNewVisitsPressed(context)),
        AppTheme.roundIconButton(
            text: 'ADD CUSTOMER',
            textStyle:
                TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
            icon: Icon(Icons.person_add_alt_1, color: Colors.white),
            iconSize: iconSize,
            buttonColor: blueColor,
            onPressed: () => createCustomer(context)),
        AppTheme.roundIconButton(
            text: 'SYNC DATA',
            textStyle: TextStyle(
                fontWeight: FontWeight.bold,
                // fontSize: fontSize,
                color: Colors.white),
            icon: Icon(
              Icons.sync,
              color: Colors.white,
            ),
            iconSize: iconSize,
            buttonColor: blueColor,
            onPressed: () => onSyncDataPressed(context)),
        AppTheme.roundIconButton(
            text: 'SQLITE',
            textStyle: TextStyle(
                fontWeight: FontWeight.bold,
                // fontSize: fontSize,
                color: Colors.white),
            icon: Icon(
              Icons.storage,
              color: Colors.white,
            ),
            iconSize: iconSize,
            buttonColor: redColor,
            onPressed: () => onDbViewPressed(context)),
      ];

      if (Config.user.userTypeId == '3') {
        list.removeLast();
        return list;
      } else if (Config.user.userTypeId == '4') {
        list.removeRange(2, 6);
        list.removeLast();
        return list;
      }
      return list;
    } catch (e) {
      log('MENU PAGE', error: e);
      return [];
    }
  }

  static const String settings = 'Settings';
  static const String logout = 'Logout';
  static const String update = 'Update';
  static const List<String> choices = <String>[logout, settings, update];

  Future<void> choice(BuildContext context, String choice) async {
    if (choice == logout) {
      if (await Library.logout(Config.user.userId))
        Navigator.of(context)
            .pushNamedAndRemoveUntil('/login', (route) => false);
    } else if (choice == settings) {
      Navigator.of(context).pushNamed('/settings');
    } else if (choice == update) {}
  }

  void createCustomer(BuildContext context) {
    String shopName, firstName, lastName, contact, address;
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: SingleChildScrollView(
          child: Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.grey,
                  blurRadius: 5.0,
                ),
              ],
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.0),
            ),
            // height: Config.deviceDisplayHeight(context) * 0.6,
            width: Config.deviceDisplayWidth(context) * 0.6,
            child: Wrap(
              children: <Widget>[
                Container(
                  color: Colors.blue,
                  padding: EdgeInsets.all(8),
                  child: Center(
                    child: Text(
                      'CREATE NEW CUSTOMER',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.white),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: <Widget>[
                      TextField(
                        decoration: InputDecoration(
                          hintText: 'Shop Name',
                          icon: Icon(Icons.business),
                        ),
                        onChanged: (value) => shopName = value,
                      ),
                      TextField(
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          hintText: 'Mobile #',
                          icon: Icon(Icons.phone),
                        ),
                        onChanged: (value) => contact = value,
                      ),
                      TextField(
                        decoration: InputDecoration(
                          hintText: 'First Name',
                          icon: Icon(Icons.person),
                        ),
                        onChanged: (value) => firstName = value,
                      ),
                      TextField(
                        decoration: InputDecoration(
                          hintText: 'Last Name',
                          icon: Icon(Icons.person),
                        ),
                        onChanged: (value) => lastName = value,
                      ),
                      TextField(
                        decoration: InputDecoration(
                          hintText: 'Address',
                          icon: Icon(Icons.business),
                        ),
                        onChanged: (value) => address = value,
                      ),
                    ],
                  ),
                ),
                Center(
                  child: ElevatedButton(
                      style: ButtonStyle(
                          shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5)))),
                      child: Text(
                        'Register',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                      onPressed: () => onCreateCustomerPressed(
                            shopName: shopName,
                            firstName: firstName,
                            lastName: lastName,
                            contact: contact,
                            address: address,
                          )),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void onCreateCustomerPressed(
      {String shopName,
      String firstName,
      String lastName,
      String contact,
      String address}) async {
    if (shopName.isNotEmpty &&
        firstName.isNotEmpty &&
        contact.isNotEmpty &&
        address.isNotEmpty) {
      Position position = await Geolocator.getCurrentPosition(
              desiredAccuracy: LocationAccuracy.high)
          .timeout(
              Duration(
                seconds: 15,
              ),
              onTimeout: () => null);
      if (position != null) {
        try {
          (await Config.database).insert('customer', {
            'user_id': Config.user.userId,
            'customer_first_name': firstName,
            'customer_last_name': lastName,
            'customer_mobile': contact,
            'customer_shop_name': shopName,
            'customer_address1': address,
            'shop_lat': position.latitude.toString(),
            'shop_long': position.longitude.toString(),
            'status': '0'
          });
        } catch (e) {
          log('Error', error: e);
        }
      }
    }
  }
}
