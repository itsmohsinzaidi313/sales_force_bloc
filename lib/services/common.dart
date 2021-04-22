import 'dart:async';
import 'dart:developer';
import '../shared/config.dart';

abstract class ServiceCommon {
  String name;
  String description;
  String serviceVersion;
  bool active = false;
  bool cycleComplete = true;
  int duration = Config.serviceCycleDelay;

  Future<void> perform();

  void setStatus(bool set) => active = set;

  bool status() => active;

  void start() => active = true;

  void stop() => active = false;

  void initiate() => _cycle();

  void forceCycle() => cycleComplete = true;

  void pauseDuration({int seconds = Config.serviceCycleDelay}) {
    this.duration = seconds;
  }

  void _cycle() async =>
      Timer.periodic(Duration(seconds: duration), (Timer t) => _operation());

  void _operation() async {
    if (active && cycleComplete) {
      try {
        perform();
      } catch (e) {
        log('SERVICE $name CRASHED: $e', name: 'ServiceCommon');
        cycleComplete = true;
      }
    }
  }
}
