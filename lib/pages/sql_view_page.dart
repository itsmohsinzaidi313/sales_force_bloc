import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:sales_force/shared/config.dart';
import 'package:sqflite/sqlite_api.dart';

class SqlViewPage extends StatefulWidget {
  @override
  _SqlViewPageState createState() => _SqlViewPageState();
}

class _SqlViewPageState extends State<SqlViewPage> {
  bool applyNewLine = false;
  bool capsColumnNames = false;
  final _textEditingController1 = TextEditingController();
  final _textEditingController2 = TextEditingController();
  List<Map<String, dynamic>> result = [];
  List<DataColumn> columns = [DataColumn(label: Text(''))];
  List<DataRow> rows = [
    DataRow(cells: [DataCell(Text(''))])
  ];
  bool check1 = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('SQL VIEW')),
      body: LayoutBuilder(builder: (context, constraints) {
        return SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height - 80,
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: <Widget>[
                ListTile(
                  title: TextField(
                    controller: _textEditingController1,
                    decoration: InputDecoration(labelText: 'Query'),
                  ),
                  leading: IconButton(
                    icon: Icon(
                      Icons.check,
                      color: Colors.red,
                    ),
                    onPressed: () async {
                      Database db = await Config.database;
                      List<Map<String, dynamic>> values =
                          await db.rawQuery(_textEditingController1.text);
                      result = values;
                      columns = [];
                      rows = [];
                      setState(() {
                        if (values.isNotEmpty) {
                          values[0].forEach((key, value) {
                            columns
                                .add(DataColumn(label: Text(key.toString())));
                          });
                          if (columns.length == 0)
                            columns.add(DataColumn(label: Text('')));
                          values.forEach((element) {
                            List<DataCell> cells = [];
                            element.forEach((key, value) {
                              cells.add(DataCell(Text(value.toString())));
                            });
                            rows.add(DataRow(cells: cells));
                          });
                          if (rows.length == 0)
                            rows.add(DataRow(cells: [DataCell(Text(''))]));
                        } else {
                          columns.add(DataColumn(label: Text('')));
                          rows.add(DataRow(cells: [DataCell(Text(''))]));
                        }
                      });
                    },
                  ),
                  trailing: IconButton(
                    icon: Icon(
                      Icons.clear,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      setState(() {
                        result = [];
                        _textEditingController1.text = '';
                      });
                    },
                  ),
                  subtitle: Text('Rows: ${result.length}'),
                ),
                ListTile(
                  title: TextField(
                    controller: _textEditingController2,
                    decoration: InputDecoration(labelText: 'Query'),
                  ),
                  leading: IconButton(
                    icon: Icon(
                      Icons.check,
                      color: Colors.red,
                    ),
                    onPressed: () async {
                      Database db = await  Config.database;
                      List<Map<String, dynamic>> values =
                          await db.rawQuery(_textEditingController2.text);
                      result = values;
                      columns = [];
                      rows = [];
                      setState(() {
                        if (values.isNotEmpty) {
                          values[0].forEach((key, value) {
                            columns.add(DataColumn(
                                label: Text(key.toString().toUpperCase())));
                          });
                          if (columns.length == 0)
                            columns.add(DataColumn(label: Text('')));
                          values.forEach((element) {
                            List<DataCell> cells = [];
                            element.forEach((key, value) {
                              cells.add(DataCell(Text(value.toString())));
                            });
                            rows.add(DataRow(cells: cells));
                          });
                          if (rows.length == 0) rows.add(DataRow(cells: []));
                        } else {
                          columns.add(DataColumn(label: Text('')));
                          rows.add(DataRow(cells: [DataCell(Text(''))]));
                        }
                      });
                    },
                  ),
                  trailing: IconButton(
                    icon: Icon(
                      Icons.clear,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      setState(() {
                        result = [];
                        _textEditingController2.text = '';
                      });
                    },
                  ),
                  subtitle: Text('Rows: ${result.length}'),
                ),
                Expanded(
                    child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columns: columns,
                      rows: rows,
                    ),
                  ),
                )),
              ],
            ),
          ),
        );
      }),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _textEditingController1.dispose();
    _textEditingController2.dispose();
  }
}
