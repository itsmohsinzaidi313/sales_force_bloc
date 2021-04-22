part of 'verbose_bloc.dart';

@immutable
abstract class VerboseEvent {
  final String title;
  final String message;

  VerboseEvent(this.title, this.message);
}

class VerboseNewEvent extends VerboseEvent {
  VerboseNewEvent({String title, String message}) : super(title, message);
}

class VerboseNewOperation extends VerboseEvent {
  VerboseNewOperation({String title, String message}) : super(title, message);
}

class VerboseError extends VerboseEvent {
  VerboseError({String title, String message}) : super(title, message);
}
