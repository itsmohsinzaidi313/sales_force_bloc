import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sales_force/bloc/view_sale_bloc/view_sale_bloc.dart';
import 'package:sales_force/database/tables/order_master_table.dart';
import 'package:sales_force/models/objects/customer.dart';
import 'view_sale_detail_page.dart';
import 'package:sales_force/shared/app_theme.dart';

class ViewSalesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('View Sales')),
      body: Container(
        color: AppTheme.backgroundColor,
        // decoration: BoxDecoration(
        //     image: DecorationImage(
        //         image: AssetImage(AppTheme.backgroundImage),
        //         repeat: ImageRepeat.repeat)),
        child: BlocConsumer<ViewSalesBloc, ViewSalesState>(
          listener: (context, state) {
            if (state is ViewSaleDetailState) {
              Navigator.of(context)
                  .pushNamed('/viewSaleDetail', arguments: state.detailsList);
            }
          },
          buildWhen: (previous, current) => current is ViewSaleStartupState,
          builder: (context, state) {
            if (state is ViewSaleStartupState) {
              return ListView(
                children: getSalesRecordWidget(context, state.masterList),
              );
            } else {
              return AppTheme.progIndicator;
            }
          },
        ),
      ),
    );
  }

  List<Widget> getSalesRecordWidget(
      BuildContext context, List<Map<String, dynamic>> record) {
    List<Widget> widgets = [];

    record.forEach((e) {
      Icon icon;
      if (e[TableOrderMaster.status] == '1')
        icon = Icon(
          Icons.check,
          color: Colors.green,
        );
      else
        icon = Icon(
          Icons.close,
          color: Colors.red,
        );

      widgets.add(GestureDetector(
        onTap: () => passEvent(context,
            LoadSaleDetail(masterId: e[TableOrderMaster.id].toString())),
        child: Card(
          child: Container(
            height: 150,
            child: Column(
              children: <Widget>[
//                Positioned(
//                  top: 0.0,
//                  left: 0.0,
//                  child: ListTile(title: Text('Date:',
//                    style: AppTheme.textStyle(fontSize: 24)),
//                  subtitle: Text('${e['createdon']}',
//                      style: AppTheme.textStyle(fontSize: 18)),),),
//                Positioned(
//                  bottom: 0.0,
//                  left: 0.0,
//                  child: ListTile(title: Text('Receivable:',
//                      style: AppTheme.textStyle(fontSize: 24)), subtitle: Text('${e['order_total']}',
//                      style: AppTheme.textStyle(fontSize: 18))),
//                ),
                ListTile(
                  title: Text('Date:', style: AppTheme.textStyle(fontSize: 24)),
                  subtitle: Text('${e[TableOrderMaster.createdOn]}',
                      style: AppTheme.textStyle(fontSize: 18)),
                  trailing: Icon(Icons.info, color: Colors.grey),
                ),
                ListTile(
                  title: Text('Receivable:',
                      style: AppTheme.textStyle(fontSize: 24)),
                  subtitle: Text('${e[TableOrderMaster.total]}',
                      style: AppTheme.textStyle(fontSize: 18)),
                  trailing: icon,
//                Row(children: <Widget>[
//                  Expanded(
//                      child: ),
//
//                ]),
//              ListTile(title: Text('Before Discount:',
//                  style: AppTheme.textStyle(fontSize: 24)), subtitle: Text(
//                '${e['order_amount']}',
//                style: AppTheme.textStyle(fontSize: 18),
//              ),),
//                Row(children: <Widget>[
//                  Expanded(
//                      child: Text('Before Discount:',
//                          style: AppTheme.textStyle(fontSize: 24))),
//                  Text(
//                    '${e['order_amount']}',
//                    style: AppTheme.textStyle(fontSize: 24),
//                  )
//                ]),
//                ListTile(title: Text('Discount:',
//                          style: AppTheme.textStyle(fontSize: 24)), subtitle: Text('${e['order_discount']}',
//                      style: AppTheme.textStyle(fontSize: 18)),),
//                Row(children: <Widget>[
//                  Expanded(
//                      child: Text('Discount:',
//                          style: AppTheme.textStyle(fontSize: 24))),
//                  Text('${e['order_discount']}',
//                      style: AppTheme.textStyle(fontSize: 24))
//                ]),

//                Row(children: <Widget>[
//                  Expanded(
//                      child: Text('Receivable:',
//                          style: AppTheme.textStyle(fontSize: 24))),
//                  Text('${e['order_total']}',
//                      style: AppTheme.textStyle(fontSize: 24))
//                ]),
//                Row(children: <Widget>[
//                  Expanded(
//                      child: Text('Order Status:',
//                          style: AppTheme.textStyle(fontSize: 24))),
//                  Text('${e['order_status']}',
//                      style: AppTheme.textStyle(fontSize: 24))
//                ]),
                )
              ],
            ),
          ),
        ),
      ));
    });
    if (widgets.length == 0)
      widgets.add(Card(
        child: Padding(
          padding: EdgeInsets.all(30.0),
          child: AppTheme.text(
              text: 'No Data Found.',
              fontSize: 20,
              fontWeight: FontWeight.bold),
        ),
      ));
    return widgets;
  }

  void passEvent(BuildContext context, ViewSalesEvent event) =>
      context.read<ViewSalesBloc>().add(event);
}
