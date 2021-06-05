import 'dart:async';
import 'dart:developer';
import 'package:sales_force/bloc/verbose_bloc/verbose_bloc.dart';

import '../shared/config.dart';

abstract class ServiceCommon {
  String name;
  String description;
  String serviceVersion;
  bool active = false;
  bool cycleComplete = true;
  int duration = Config.ServiceCycleDelay;
  VerboseBloc verboseBloc;

  Future<void> perform();

  void setStatus(bool value) {
    log(value ? 'STARTED' : 'STOPPED', name: name);
    active = value;
  }

  bool status() => active;

  void start() {
    log('STARTED', name: name);
    active = true;
  }

  void stop() {
    log('STOPPED', name: name);
    active = false;
  }

  void initiate() => _cycle();

  void forceCycle() => cycleComplete = true;

  void pauseDuration({int seconds = Config.ServiceCycleDelay}) {
    this.duration = seconds;
  }

  void _cycle() async =>
      Timer.periodic(Duration(seconds: duration), (Timer t) => _operation());

  void _operation() async {
    if (active && cycleComplete) {
      try {
        log('RESPONDING', name: '$name');
        await perform();
      } catch (e) {
        log('SERVICE $name CRASHED: $e', name: 'ServiceCommon');
        cycleComplete = true;
      }
    }
  }
}
