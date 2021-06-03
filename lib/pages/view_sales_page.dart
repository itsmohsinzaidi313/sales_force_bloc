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
    final fromDateController = TextEditingController(text: '');
    final toDateController = TextEditingController(text: '');
    return Scaffold(
      appBar: AppBar(
        title: Text('View Sales'),
        bottom: AppBar(
          backgroundColor: Colors.blue,
          leadingWidth: 0,
          leading: SizedBox(),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Flexible(
                fit: FlexFit.tight,
                child: ListTile(
                  leading: Icon(Icons.calendar_today, color: Colors.white),
                  title: TextField(
                    readOnly: true,
                    keyboardType: TextInputType.datetime,
                    controller: fromDateController,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'From Date',
                      labelStyle: TextStyle(color: Colors.white),
                    ),
                    onTap: () async =>
                        fromDateController.text = await getDate(context),
                    onChanged: (value) => DateTime.tryParse(value) == null
                        ? AppTheme.snackbar(
                            context, 'Please enter valid from date')
                        : value,
                  ),
                ),
              ),
              Flexible(
                fit: FlexFit.tight,
                child: ListTile(
                  leading: Icon(Icons.calendar_today, color: Colors.white),
                  title: TextField(
                    readOnly: true,
                    keyboardType: TextInputType.datetime,
                    controller: toDateController,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'To Date',
                      labelStyle: TextStyle(color: Colors.white),
                    ),
                    onTap: () async =>
                        toDateController.text = await getDate(context),
                    onChanged: (value) => DateTime.tryParse(value) == null
                        ? AppTheme.snackbar(
                            context, 'Please enter valid from date')
                        : value,
                  ),
                ),
              ),
              IconButton(
                icon: Icon(Icons.search),
                onPressed: () {
                  DateTime fromDate =
                          DateTime.tryParse(fromDateController.text),
                      toDate = DateTime.tryParse(fromDateController.text);
                  if (fromDate != null && toDate != null) {
                    if (fromDate.isBefore(toDate) ||
                        fromDate.isAtSameMomentAs(toDate)) {
                      passEvent(
                        context,
                        SearchSalesRecord(
                            fromDate: fromDateController.text,
                            toDate: toDateController.text),
                      );
                    } else {
                      AppTheme.snackbar(
                          context, "'From date' cannot be after 'To Date'");
                    }
                  } else {
                    AppTheme.snackbar(context, 'Please select valid dates.');
                  }
                },
              ),
            ],
          ),
        ),
      ),
      body: Container(
        color: AppTheme.backgroundColor,
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
              return ListView(
                children: getSalesRecordWidget(context, []),
              );
            }
          },
        ),
      ),
    );
  }

  Future<String> getDate(BuildContext context) async {
    DateTime datetime =
        (await AppTheme.showDateTimeChoose(context)) ?? DateTime.now();
    return datetime.toIso8601String().substring(0, 10);
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
          child: Column(
            children: <Widget>[
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
              )
            ],
          ),
        ),
      ));
    });
    if (widgets.length == 0)
      widgets.add(Card(
        child: Padding(
          padding: EdgeInsets.all(30.0),
          child: Column(
            children: [
              AppTheme.text(
                  text: 'No Data Found.',
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
              AppTheme.text(
                  text:
                      'Please select from/to date and press search to find your sales record.',
                  color: Colors.grey)
            ],
          ),
        ),
      ));
    return widgets;
  }

  void passEvent(BuildContext context, ViewSalesEvent event) =>
      context.read<ViewSalesBloc>().add(event);
}
