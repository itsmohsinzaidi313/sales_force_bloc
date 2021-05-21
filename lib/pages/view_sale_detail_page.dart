import 'package:flutter/material.dart';
import 'package:sales_force/models/objects/product.dart';
import 'package:sales_force/shared/app_theme.dart';

class ViewSaleDetail extends StatelessWidget {
  final List<Product> detailRecord;
  final double cardElementTextSize = 24;

  ViewSaleDetail({this.detailRecord});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppTheme.appBar(title: 'Sale Detail'),
      body: Container(
        color: AppTheme.backgroundColor,
        // decoration: BoxDecoration(
        //     image: DecorationImage(
        //         image: AssetImage(AppTheme.backgroundImage),
        //         repeat: ImageRepeat.repeat)),
        child:
            Center(heightFactor: 1, child: getProductsTableView(detailRecord)),
      ),
    );
  }

  //TABLE VIEW
  Widget getProductsTableView(List<Product> products) => products.isEmpty
      ? Card(
          child: Center(child: Text('No Data')),
        )
      : DataTable(
          columns: [
            DataColumn(label: Text('Product')),
            DataColumn(label: Text('Price')),
            DataColumn(label: Text('Quantity')),
            DataColumn(label: Text('FOC')),
            DataColumn(label: Text('Total')),
          ],
          rows: products
              .map(
                (e) => DataRow(cells: [
                  DataCell(Text(e.title)),
                  DataCell(Text(e.packPrice)),
                  DataCell(Text(e.purchasedQuantity)),
                  DataCell(Text(e.focQuantity.toString())),
                  DataCell(Text(
                      '${double.parse(e.packPrice) * double.parse(e.purchasedQuantity)}')),
                ]),
              )
              .toList(),
        );

  //LIST VIEW
  List<Widget> getProductsWidget(List<Product> products) => products.isEmpty
      ? [
          Card(
            child: Center(child: Text('No Data')),
          )
        ]
      : products
          .map((e) => Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: <Widget>[
//                Row(children: <Widget>[Expanded(child: AppTheme.text()), AppTheme.text()]),
                      Row(
                        children: <Widget>[
                          Expanded(
                              child: AppTheme.text(
                                  text: 'Title',
                                  fontSize: cardElementTextSize)),
                          AppTheme.text(
                              text: '${e.title}',
                              fontSize: cardElementTextSize),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(
                              child: AppTheme.text(
                                  text: 'Price:',
                                  fontSize: cardElementTextSize)),
                          AppTheme.text(
                              text: '${e.packPrice}',
                              fontSize: cardElementTextSize),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(
                              child: AppTheme.text(
                                  text: 'Quantity:',
                                  fontSize: cardElementTextSize)),
                          AppTheme.text(
                              text: '${e.purchasedQuantity}',
                              fontSize: cardElementTextSize),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(
                              child: AppTheme.text(
                                  text: 'FOC Quantity:',
                                  fontSize: cardElementTextSize)),
                          AppTheme.text(
                              text: '${e.focQuantity}',
                              fontSize: cardElementTextSize),
                        ],
                      ),
                      Row(children: <Widget>[
                        Expanded(
                            child: AppTheme.text(
                                text: 'Total', fontSize: cardElementTextSize)),
                        AppTheme.text(
                            text:
                                '${double.parse(e.packPrice) * double.parse(e.purchasedQuantity)}',
                            fontSize: cardElementTextSize)
                      ]),
                    ],
                  ),
                ),
              ))
          .toList();
//   List<Widget> getProductsWidget() {
//     List<Widget> widgets = [];
//     if (detailRecord != null) {
//       for (Product value in detailRecord) {
//         widgets.add(Card(
//           child: Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Column(
//               children: <Widget>[
// //                Row(children: <Widget>[Expanded(child: AppTheme.text()), AppTheme.text()]),
//                 Row(
//                   children: <Widget>[
//                     Expanded(
//                         child: AppTheme.text(
//                             text: 'Title', fontSize: cardElementTextSize)),
//                     AppTheme.text(
//                         text: '${value.title}', fontSize: cardElementTextSize),
//                   ],
//                 ),
//                 Row(
//                   children: <Widget>[
//                     Expanded(
//                         child: AppTheme.text(
//                             text: 'Price:', fontSize: cardElementTextSize)),
//                     AppTheme.text(
//                         text: '${value.packPrice}',
//                         fontSize: cardElementTextSize),
//                   ],
//                 ),
//                 Row(
//                   children: <Widget>[
//                     Expanded(
//                         child: AppTheme.text(
//                             text: 'Quantity:', fontSize: cardElementTextSize)),
//                     AppTheme.text(
//                         text: '${value.purchasedQuantity}',
//                         fontSize: cardElementTextSize),
//                   ],
//                 ),
//                 Row(
//                   children: <Widget>[
//                     Expanded(
//                         child: AppTheme.text(
//                             text: 'FOC Quantity:',
//                             fontSize: cardElementTextSize)),
//                     AppTheme.text(
//                         text: '${value.focQuantity}',
//                         fontSize: cardElementTextSize),
//                   ],
//                 ),
//                 Row(children: <Widget>[
//                   Expanded(
//                       child: AppTheme.text(
//                           text: 'Total', fontSize: cardElementTextSize)),
//                   AppTheme.text(
//                       text:
//                           '${double.parse(value.packPrice) * double.parse(value.purchasedQuantity)}',
//                       fontSize: cardElementTextSize)
//                 ]),
//               ],
//             ),
//           ),
//         ));
//       }
//     } else {
//       widgets.add(Card(
//         child: Center(child: Text('No Data')),
//       ));
//     }
//     return widgets;
//   }

  ListView displayListView(List<Product> products) {
    return ListView(
      children: getProductsWidget(products),
    );
  }

  //GRID VIEW CODE
  GridView displayGridView(List<Product> products) {
    return GridView.count(
      crossAxisCount: 2,
      children: getGridViewWidgets(products),
    );
  }

  List<Widget> getGridViewWidgets(List<Product> products) {
    List<Widget> list = [];
    products.forEach((element) {
      list.add(Card(
        margin: EdgeInsets.all(8.0),
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              Expanded(
                  child: Image.network(element.getNetworkImage(),
                      fit: BoxFit.scaleDown)),
              SizedBox(height: 8.0),
              AppTheme.text(text: element.title, fontWeight: FontWeight.bold),
              AppTheme.text(
                  text: element.packPrice, fontWeight: FontWeight.bold),
              AppTheme.text(
                  text: element.purchasedQuantity, fontWeight: FontWeight.bold),
            ],
          ),
        ),
      ));
    });
    if (list.length == 0)
      list.add(Container(
        child: Column(children: <Widget>[
          Center(
            child: AppTheme.text(text: 'No items to display.'),
          )
        ]),
      ));
    return list;
  }
//
}
