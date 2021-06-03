import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sales_force/bloc/verbose_bloc/verbose_bloc.dart';

class VerboseWidgets {
  final BuildContext context;
  VerboseWidgets({this.context});
  void showVerboseDialog() => showDialog(
        context: context,
        builder: (context) => Dialog(
          child: Container(
            child: BlocBuilder<VerboseBloc, VerboseState>(
              builder: (context, state) {
                try {
                  return Wrap(
                    children: [
                      ListTile(
                        leading: Icon(Icons.info),
                        title: Text(
                          state.title.toUpperCase(),
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 18,
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
                  return Wrap(
                    children: [
                      ListTile(
                          leading: Icon(Icons.info),
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
