import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sales_force/bloc/verbose_bloc/verbose_bloc.dart';

class VerboseWidgets {
  final BuildContext context;
  VerboseWidgets({this.context});
  void showVerboseDialog() => showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Dialog(
          child: Container(
            child: BlocBuilder<VerboseBloc, VerboseState>(
              builder: (context, state) {
                try {
                  if (state.title == 'Completed') {
                    Timer(Duration(seconds: 2), () {
                      Navigator.pop(context);
                    });
                  }
                  return Wrap(
                    children: [
                      ListTile(
                        leading: state.title == 'Completed'
                            ? Icon(Icons.check, color: Colors.green)
                            : Icon(Icons.info),
                        title: Text(
                          state.title.toUpperCase(),
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        subtitle: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    state.message,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(fontSize: 12),
                                  ),
                                )
                              ],
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: LinearProgressIndicator(
                                    value: state.value,
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  );
                } catch (e) {
                  Timer(Duration(seconds: 2), () {
                    Navigator.pop(context);
                  });
                  return Wrap(
                    children: [
                      ListTile(
                          leading: Icon(
                            Icons.close,
                            color: Colors.red,
                          ),
                          title: Text('Error Occured'),
                          subtitle: Text(e.toString())),
                    ],
                  );
                }
              },
            ),
          ),
        ),
      );
}
