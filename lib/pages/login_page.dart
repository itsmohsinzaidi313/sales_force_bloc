import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sales_force/bloc/login_bloc/login_bloc.dart';
import 'package:sales_force/bloc/verbose_bloc/verbose_bloc.dart';
import 'package:sales_force/services/service_control.dart';
import 'package:sales_force/shared/app_theme.dart';
import 'package:sales_force/shared/config.dart';
import 'package:sales_force/shared/library.dart';
import 'package:sales_force/shared/widgets/verbose_widget.dart';

class LoginPage extends StatelessWidget {
  final loginFields = LoginFields();

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state is LoginSuccessful) {
          AppTheme.snackbar(context, state.message);
          Config.database.then((value) => ServiceControl.control
              .initializeDatabaseDependentServices(database: value));
          Navigator.pushNamedAndRemoveUntil(context, '/menu', (route) => false);
        } else if (state is InvalidSubmission) {
          AppTheme.snackbar(context, state.message);
        } else if (state is InvalidPassword) {
          AppTheme.snackbar(context, state.message);
        } else if (state is InvalidEmail) {
          AppTheme.snackbar(context, state.message);
        } else if (state is LoginError) {
          AppTheme.snackbar(context, state.message);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          actions: <Widget>[
            PopupMenuButton<String>(
                shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.vertical(bottom: Radius.circular(20.0))),
                icon: Icon(Icons.more_vert),
                onSelected: (value) => choiceAction(value, context),
                itemBuilder: (BuildContext context) {
                  return choices.map((String choice) {
                    return PopupMenuItem<String>(
                      value: choice,
                      child: Text(choice),
                    );
                  }).toList();
                })
          ],
          elevation: 10.0,
          title: Text('Login'),
        ),
        body: Container(
          color: AppTheme.backgroundColor,
          child: ListView(
            children: <Widget>[
              Container(child: BlocBuilder<LoginBloc, LoginState>(
                buildWhen: (previous, current) => current is NewUser || current is SavedUser,
                builder: (context, state) {
                  if (state is SavedUser) {
                    return LoginButton(email: state.email);
                  } else if (state is NewUser) {
                    return loginFields;
                  } else {
                    return AppTheme.progIndicator;
                  }
                },
              ))
            ],
          ),
        ),
      ),
    );
  }

  static const List<String> choices = [/* Reinstall, */ Update];
  // static const String Reinstall = 'Reinstall';
  static const String Update = 'Update';

  void choiceAction(String choice, BuildContext context) {
    Library.hasServerAccess().then((value) {
      if (value) {
        // if (choice == Reinstall) {
        //   Library.install(context, reinstall: true);
        // } else
        if (choice == Update) {
          Library.install(context, forceUpdate: true);
        }
        VerboseWidgets(context: context).showVerboseDialog();
      } else {
        AppTheme.showAlertDialogOK(context,
            title: 'Attention',
            message: 'Please connect to internet',
            onOK: () => Navigator.pop(context));
      }
    }).catchError((onError) {
      if (onError is SocketException)
        AppTheme.showAlertDialogOK(context,
            title: 'Attention',
            message: 'Please connect to internet',
            onOK: () => Navigator.pop(context));
      else
        AppTheme.showAlertDialogOK(context,
            title: 'Attention',
            message: 'An error has occured.\n${onError.toString()}',
            onOK: () => Navigator.pop(context));
    });
  }
}

class LoginButton extends StatelessWidget {
  final String email;
  LoginButton({@required this.email});
  final Image logo = Image.asset('images/icon2.jpg');
  @override
  Widget build(BuildContext context) {
    return Center(
      heightFactor: MediaQuery.of(context).size.height * 0.0018,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        child: Card(
          elevation: 10.0,
          child: Padding(
            padding: EdgeInsets.only(top: 50),
            child: Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).size.height * 0.03),
                  child: logo,
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Center(
                      child: AppTheme.text(
                          text: email, fontWeight: FontWeight.bold)),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Center(
                      child: AppTheme.roundElevatedButton(
                    text: 'Sign in',
                    onPressed: () => context
                        .read<LoginBloc>()
                        .add(LoginSubmit(forceLogin: true)),
                  )),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class LoginFields extends StatelessWidget {
  final Image logo = Image.asset('images/icon2.jpg');
  @override
  Widget build(BuildContext context) {
    return Center(
      heightFactor: MediaQuery.of(context).size.height * 0.0018,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        child: Card(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 50, 20, 40),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).size.height * 0.02),
                  child: logo,
                ),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Email',
                    icon: Icon(
                      Icons.mail,
                      color: Colors.grey[600],
                    ),
                  ),
                  onChanged: (value) => context
                      .read<LoginBloc>()
                      .add(LoginEmailChanged(email: value)),
                ),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Password',
                    icon: Icon(
                      Icons.lock,
                      color: Colors.grey[600],
                    ),
                  ),
                  onChanged: (value) => context
                      .read<LoginBloc>()
                      .add(LoginPasswordChanged(password: value)),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.blue),
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0)))),
                    child: Text(
                      'Sign in',
                      style: TextStyle(color: Colors.white, fontSize: 25.0),
                    ),
                    onPressed: () =>
                        context.read<LoginBloc>().add(LoginSubmit()),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}