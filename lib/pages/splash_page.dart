import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:sales_force/bloc/verbose_bloc/verbose_bloc.dart';
import 'package:sales_force/shared/app_theme.dart';
import 'package:sales_force/shared/config.dart';
import 'package:sales_force/shared/library.dart';

class SplashPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    startUp(context);
    return Container(
      height: Config.deviceDisplayHeight(context),
      width: Config.deviceDisplayWidth(context),
      color: AppTheme.ddfColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: SizedBox(),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                  child: Image.asset(
                'images/icon2.jpg',
                scale: 1,
              )),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: SpinKitFadingCircle(
                  color: Colors.purple[200],
                ),
              ),
            ],
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                BlocBuilder<VerboseBloc, VerboseState>(
                  builder: (context, state) {
                    try {
                      return Column(
                        children: [
                          Center(
                            child: RichText(
                              text: TextSpan(
                                text: state.title,
                                style:
                                    TextStyle(color: Colors.grey, fontSize: 16),
                              ),
                            ),
                          ),
                          RichText(
                            text: TextSpan(
                              text: state.message,
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 14),
                            ),
                          ),
                        ],
                      );
                    } catch (e) {
                      return RichText(
                        text: TextSpan(
                          style: TextStyle(color: Colors.grey),
                          text: 'Error Occured',
                          children: [
                            TextSpan(
                              style: TextStyle(color: Colors.grey[400]),
                              text: e.toString(),
                            ),
                          ],
                        ),
                      );
                    }
                  },
                )
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Image.asset(
                'images/devaj_logo_small.png',
                scale: 2,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Timer loadLoginView(BuildContext context) {
    return Timer(Duration(seconds: Config.SplashTimeOut),
        () => Navigator.of(context).pushReplacementNamed('/login'),);
  }

  Future<void> startUp(BuildContext context) async {
    await Library.install(
      context,
      // forceUpdate: true,
      // reinstall: true,
    );
    await Future.delayed(Duration(seconds: 2));
    Navigator.of(context).pushReplacementNamed('/login');
  }
}
