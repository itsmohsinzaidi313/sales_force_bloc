import 'dart:async';
import 'dart:developer';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sales_force/shared/app_theme.dart';
import 'package:sales_force/shared/config.dart';
import 'package:sales_force/shared/constants.dart';
import 'package:sales_force/shared/library.dart';

class MenuPage extends StatelessWidget {
  void onNewSalePressed(BuildContext context) => Navigator.of(context)
      .pushNamed('/customers', arguments: SALETYPE.NEWSALE);

  void onViewSalePressed(BuildContext context) => Navigator.of(context)
      .pushNamed('/customers', arguments: SALETYPE.VIEWSALE);
  void onNewVisitsPressed(BuildContext context) => Navigator.of(context)
      .pushNamed('/customers', arguments: SALETYPE.REGISTERVISIT);

  void onInvoicesPressed(BuildContext context) {}
  void onViewVisitsPressed(BuildContext context) {}
  void onSyncDataPressed(BuildContext context) {}

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
              children: getDashboardButtons2(context),
            ),
          ),
        ));
  }

  List<Widget> getDashboardButtons() {
    try {
      double buttonLabelFontSize = 14.0;
      List<Widget> list = [
        ElevatedButton(
          style: ButtonStyle(
            elevation: MaterialStateProperty.all(4),
            backgroundColor: MaterialStateProperty.all(Colors.white),
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
          ),
          onPressed: () => onNewSalePressed,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                Expanded(
                  child: Image(
                    image: AssetImage('images/newSale2.png'),
                  ),
                ),
                AutoSizeText(
                  'NEW SALE',
                  style: TextStyle(
                      color: Colors.black, fontSize: buttonLabelFontSize),
                ),
              ],
            ),
          ),
        ),
        ElevatedButton(
          style: ButtonStyle(
            elevation: MaterialStateProperty.all(4),
            backgroundColor: MaterialStateProperty.all(Colors.white),
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
          ),
          onPressed: () {},
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                Expanded(
                  child: Image(
                    image: AssetImage('images/viewSale.png'),
                  ),
                ),
                Text(
                  'VIEW SALE',
                  style: TextStyle(
                      color: Colors.black, fontSize: buttonLabelFontSize),
                ),
              ],
            ),
          ),
        ),
        ElevatedButton(
          style: ButtonStyle(
            elevation: MaterialStateProperty.all(4),
            backgroundColor: MaterialStateProperty.all(Colors.white),
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
          ),
          onPressed: () {},
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                Expanded(
                  child: Image(
                    image: AssetImage('images/viewInvoices.png'),
                  ),
                ),
                AutoSizeText(
                  'INVOICES',
                  style: TextStyle(
                      color: Colors.black, fontSize: buttonLabelFontSize),
                ),
              ],
            ),
          ),
        ),
        ElevatedButton(
          style: ButtonStyle(
            elevation: MaterialStateProperty.all(4),
            backgroundColor: MaterialStateProperty.all(Colors.white),
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
          ),
          onPressed: () {},
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                Expanded(
                  child: Image(
                    image: AssetImage('images/viewLocation.png'),
                  ),
                ),
                AutoSizeText(
                  'VIEW VISIT',
                  style: TextStyle(
                      color: Colors.black, fontSize: buttonLabelFontSize),
                ),
              ],
            ),
          ),
        ),
        ElevatedButton(
          style: ButtonStyle(
            elevation: MaterialStateProperty.all(4),
            backgroundColor: MaterialStateProperty.all(Colors.white),
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
          ),
          onPressed: () => onNewVisitsPressed,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                Expanded(
                  child: Image(
                    image: AssetImage('images/visits.png'),
                  ),
                ),
                AutoSizeText(
                  'NEW VISIT',
                  style: TextStyle(
                      color: Colors.black, fontSize: buttonLabelFontSize),
                ),
              ],
            ),
          ),
        ),
        ElevatedButton(
          style: ButtonStyle(
            elevation: MaterialStateProperty.all(4),
            backgroundColor: MaterialStateProperty.all(Colors.white),
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
          ),
          onPressed: () {},
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                Expanded(
                  child: Image(
                    image: AssetImage('images/sync.png'),
                  ),
                ),
                AutoSizeText(
                  'SYNC',
                  style: TextStyle(
                      color: Colors.black, fontSize: buttonLabelFontSize),
                ),
              ],
            ),
          ),
        ),
        ElevatedButton(
          style: ButtonStyle(
            elevation: MaterialStateProperty.all(4),
            backgroundColor: MaterialStateProperty.all(Colors.white),
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
          ),
          onPressed: () {},
          child: AppTheme.text(text: 'SQL'),
        ),
      ];

      if (Config.user.userTypeId == '3') {
        // list.removeLast();
        return list;
      } else if (Config.user.userTypeId == '4') {
        list.removeRange(2, 6);
        return list;
      }
      return list;
    } catch (e) {
      return [];
    }
  }

  List<Widget> getDashboardButtons2(BuildContext context) {
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
            onPressed: () {}),
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

  choice(BuildContext context, String choice) async {
    if (choice == logout) {
      if (await Library.logout(Config.user.userId))
        Navigator.of(context)
            .pushNamedAndRemoveUntil('/login', (route) => false);
    } else if (choice == settings) {
    } else if (choice == update) {}
  }
}
