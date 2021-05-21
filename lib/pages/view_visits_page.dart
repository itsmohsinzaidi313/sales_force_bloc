import 'package:flutter/material.dart';
import 'package:sales_force/database/tables/visits_table.dart';
import 'package:sales_force/repositories/visit_repository.dart';
import 'package:sales_force/shared/app_theme.dart';
import 'package:sales_force/shared/config.dart';

class ViewVisitsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppTheme.appBar(title: 'Visit History'),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          color: AppTheme.backgroundColor,
          // decoration: BoxDecoration(
          //     image: DecorationImage(
          //         image: AssetImage(AppTheme.backgroundImage),
          //         repeat: ImageRepeat.repeat)),
          child: Column(
            children: <Widget>[
              Container(
                color: Colors.white,
                child: ListTile(
                    title: Text('Visits',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20))),
              ),
              FutureBuilder(
                future: VisitRepo.repo.getAllVisits(Config.user.userId),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List<Map<String, dynamic>> list = snapshot.data;
                    if (list.isNotEmpty) {
                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: list.length,
                        itemBuilder: (context, index) {
                          Icon icon;
                          if (list[index][TableVisits.isUpload] == 1)
                            icon = new Icon(Icons.check, color: Colors.green);
                          else
                            icon = new Icon(Icons.close, color: Colors.red);
                          return Card(
                              color: Colors.white,
                              child: ListTile(
                                  leading: Icon(Icons.location_on),
                                  isThreeLine: true,
                                  title: Text(list[index]['name']),
                                  subtitle: Text(
                                      '${list[index]['shop']}\n${list[index][TableVisits.createdOn]}'),
                                  trailing: icon));
                        },
                      );
                    } else {
                      return Card(
                          color: Colors.white,
                          child: ListTile(
                            title: AppTheme.text(text: 'No Visits To Show.'),
                            trailing: Icon(
                              Icons.priority_high,
                              color: Colors.blue,
                            ),
                          ));
                    }
                  } else {
                    return AppTheme.progIndicator;
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
