import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sales_force/routes/route_config.dart';

import 'bloc/verbose_bloc/verbose_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(BlocProvider(
    create: (context) => VerboseBloc(),
    child: MyApp(
      routeConfig: RouteConfig(),
    ),
  ));
}

class MyApp extends StatefulWidget {
  final RouteConfig routeConfig;
  MyApp({@required this.routeConfig});

  @override
  _MyAppState createState() => _MyAppState(routeConfig: routeConfig);
}

class _MyAppState extends State<MyApp> {
  RouteConfig routeConfig;
  _MyAppState({this.routeConfig});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sales Force',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      onGenerateRoute: widget.routeConfig.onGeneratedRoute,
      initialRoute: '/',
    );
  }

  @override
  void dispose() {
    super.dispose();
    routeConfig.dispose();
  }
}
