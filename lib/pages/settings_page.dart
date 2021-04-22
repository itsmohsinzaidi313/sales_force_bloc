import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sales_force/services/common.dart';
import 'package:sales_force/shared/config.dart';

class SettingsView extends StatefulWidget {
  @override
  _SettingsViewState createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  static const List<String> tileTitle = ['Services', 'Permissions'];
  List<ExpansionTile> _listOfExpansions = List<ExpansionTile>.generate(
      tileTitle.length,
      (i) => ExpansionTile(
            title: Text(tileTitle[i]),
            children: _subTileControler(i),
          ));

  static List<Widget> _subTileControler(int i) {
    switch (i) {
      case 0:
        return getServicesWidgets();
        break;
      case 1:
        return getPermissionsWidgets();
      default:
        return [];
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('SETTINGS'),
        ),
        body: ListView(
          children:
              _listOfExpansions.map((expansionTile) => expansionTile).toList(),
        ));
  }
}

getPermissionsWidgets() {
  return Permission.values
      .where((Permission permission) {
        return permission != Permission.reminders &&
            permission != Permission.photos &&
            permission != Permission.sensors &&
            permission != Permission.sms &&
            permission != Permission.speech &&
            permission != Permission.activityRecognition &&
            permission != Permission.phone &&
            permission != Permission.microphone &&
            permission != Permission.calendar &&
            permission != Permission.contacts &&
            permission != Permission.camera &&
            permission != Permission.phone &&
            permission != Permission.ignoreBatteryOptimizations &&
            permission != Permission.accessMediaLocation &&
            permission != Permission.notification &&
            permission != Permission.unknown;
      })
      .map((permission) => PermissionWidget(permission))
      .toList();
}


getServicesWidgets() {
  return [
  ];
}

class PermissionWidget extends StatefulWidget {
  /// Constructs a [PermissionWidget] for the supplied [Permission].
  const PermissionWidget(this._permission);

  final Permission _permission;

  @override
  _PermissionState createState() => _PermissionState(_permission);
}

class _PermissionState extends State<PermissionWidget> {
  _PermissionState(this._permission);

  final Permission _permission;
  PermissionStatus _permissionStatus = PermissionStatus.limited;

  @override
  void initState() {
    super.initState();

    _listenForPermissionStatus();
  }

  void _listenForPermissionStatus() async {
    final status = await _permission.status;
    setState(() => _permissionStatus = status);
  }

  Color getPermissionColor() {
    switch (_permissionStatus) {
      case PermissionStatus.denied:
        return Colors.red;
      case PermissionStatus.granted:
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(_permission.toString()),
      subtitle: Text(
        _permissionStatus.toString(),
        style: TextStyle(color: getPermissionColor()),
      ),
      trailing: IconButton(
          icon: const Icon(Icons.info),
          onPressed: () {
            checkPermissionStatus(context, _permission);
          }),
      onTap: () {
        requestPermission(_permission);
      },
    );
  }

  void checkPermissionStatus(
      BuildContext context, Permission permission) async {
    Future<PermissionStatus> future = permission.request();
    future.then((onValue) {
      print(onValue.isGranted);
    });
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text((await permission.status).toString()),
    ));
  }

  Future<void> requestPermission(Permission permission) async {
    final status = await permission.request();

    setState(() {
      print(status);
      _permissionStatus = status;
      print(_permissionStatus);
    });
  }
}

class ServicesWidgets extends StatefulWidget {
  String name;

  ServicesWidgets(this.name);

  @override
  _ServicesWidgetsState createState() => _ServicesWidgetsState(name: this.name);
}

class _ServicesWidgetsState extends State<ServicesWidgets> {
  String name;
  bool status;

  _ServicesWidgetsState({this.name});

  final MethodChannel locationServiceChannel =
      new MethodChannel('com.devaj.ddf/locationService');


  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Row(children: [
        Text(name),
        
        FutureBuilder(  builder: (context, snapshot) {
          
        },)
      ],),
      subtitle: Text((status) ? 'Running' : 'Stopped',
          style: TextStyle(color: (status) ? Colors.green : Colors.red)),
      trailing: IconButton(
          icon: Icon((status) ? Icons.play_arrow : Icons.stop),
          onPressed: () {
            
            // FORGROUND SERVICE TESTING
            if (status)
              locationServiceChannel.invokeListMethod('start', {
                'user_id': Config.user.userId,
                'trackingApi': Config.putTrackingAPILink
              });
            else if (!status) locationServiceChannel.invokeListMethod('stop');
            //

            
          }),
    );
  }
}
