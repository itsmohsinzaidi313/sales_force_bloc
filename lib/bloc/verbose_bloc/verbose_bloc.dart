import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';

part 'verbose_event.dart';
part 'verbose_state.dart';

class VerboseBloc extends Bloc<VerboseEvent, VerboseState> {
  VerboseBloc() : super(VerboseInitial());
  @override
  Stream<VerboseState> mapEventToState(
    VerboseEvent event,
  ) async* {
    if (event is VerboseNewEvent) {
      yield VerboseInitial(
          title: event.title,
          message: event.message,
          value: getValues(event.message));
      if (event.message == 'Installation successful.') {
        yield VerboseProgressComplete(
            title: 'Completed',
            message: event.message,
            value: getValues(event.message));
      } else if (event.message == 'Installation failed.') {
        yield VerboseProgressFailed(
            title: 'Failure',
            message: event.message,
            value: getValues(event.message));
      }
    } else if (event is VerboseNotify) {
      yield VerboseSnackBarState(message: event.message);
    }
  }

  double getValues(String text) {
    double value = 100;
    if (text != null && text != '' && text.contains('/')) {
      List<String> a = text.split('/');
      List<String> b = a.first.split(' ');
      double total = double.parse(a.last);
      double count = double.parse(b.last);
      value = (count / total);
    }
    return value;
  }
}
